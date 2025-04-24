import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/services/api.dart';
import 'dart:convert';

/// A page that displays all games created by a specific user
class UserGamesPage extends StatefulWidget {
  final String userId;
  final String username;
  final String? profilePic;

  const UserGamesPage({
    Key? key,
    required this.userId,
    required this.username,
    this.profilePic,
  }) : super(key: key);

  @override
  State<UserGamesPage> createState() => _UserGamesPageState();
}

class _UserGamesPageState extends State<UserGamesPage> {
  late Future<List<plock.Game>> _gamesFuture;
  bool _isLoading = false;
  int _currentPage = 1;
  final List<plock.Game> _games = [];
  bool _hasMoreGames = true;
  final ScrollController _scrollController = ScrollController();
  final Map<String, bool> _isLiked = {};
  final Map<String, int> _likesCount = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _gamesFuture = _fetchUserGames(page: 1);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMoreGames) {
      _loadMoreGames();
    }
  }

  Future<void> _loadMoreGames() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _currentPage++;
    });

    try {
      final moreGames = await _fetchUserGames(page: _currentPage);
      if (moreGames.isEmpty) {
        setState(() => _hasMoreGames = false);
      } else {
        setState(() => _games.addAll(moreGames));
      }
    } catch (e) {
      print('Error loading more games: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<plock.Game>> _fetchUserGames({required int page}) async {
    try {
      final response = await ApiService.getUserGames(widget.userId, page: page);

      if (response.statusCode != 200) {
        print('Error: ${response.statusCode} - ${response.body}');
        return [];
      }

      final decodedResponse = jsonDecode(response.body);
      final gamesData = decodedResponse['data']['data'] as List<dynamic>?;
      final meta = decodedResponse['data']['meta'];

      if (gamesData == null) {
        print('Invalid response format');
        return [];
      }

      _hasMoreGames = page < (meta['lastPage'] ?? 1);
      final List<plock.Game> games = [];

      if (page == 1) {
        _games.clear();
      }

      for (final raw in gamesData) {
        try {
          final gameJson = await http.get(Uri.parse(raw['gameUrl']));
          final game = await plock.Game.jsonToGame(
            name: raw['title'],
            json: jsonDecode(gameJson.body),
            lastUpdate: DateTime.parse(raw['updatedAt']),
          );
          if (game == null) continue;

          game
            ..uuid = raw['id']
            ..thumbnailUrl = raw['thumbnailUrl']
            ..likes = raw['likes'] ?? 0
            ..gameType = raw['gameType'] ?? 'Unknown'
            ..commentsCount = raw['commentsCount'] ?? 0;

          if (raw['creator'] != null) {
            game.creatorId = raw['creator']['id'] ?? '';
            game.creatorUsername = raw['creator']['username'] ?? '';
            game.creatorAvatarUrl = raw['creator']['pofilePic'] ?? '';
          } else {
            game.creatorId = widget.userId;
            game.creatorUsername = widget.username;
            game.creatorAvatarUrl = widget.profilePic ?? '';
          }

          _isLiked[game.uuid] = raw['hasLiked'] ?? false;
          _likesCount[game.uuid] = raw['likes'] ?? 0;
          games.add(game);
        } catch (e) {
          print('Error processing game: $e');
          continue;
        }
      }

      return games;
    } catch (e) {
      print('Error fetching user games: $e');
      return [];
    }
  }

  Future<void> _handleLikeToggle(String gameId, bool like) async {
    setState(() {
      _isLiked[gameId] = like;
      _likesCount[gameId] =
          (_likesCount[gameId] ?? 0) + (like ? 1 : -1).clamp(-1, 1);
    });
    like
        ? await ApiService.addLikeGame(gameId)
        : await ApiService.deleteGame(gameId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              backgroundImage: (widget.profilePic ?? '').isNotEmpty
                  ? NetworkImage(widget.profilePic!)
                  : null,
              child: (widget.profilePic ?? '').isEmpty
                  ? Text(
                      widget.username.isNotEmpty
                          ? widget.username[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              "${widget.username}'s Games",
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _currentPage = 1;
            _hasMoreGames = true;
            _gamesFuture = _fetchUserGames(page: 1);
          });
        },
        child: FutureBuilder<List<plock.Game>>(
          future: _gamesFuture,
          builder: (context, snapshot) {
            // 1) Loading indicator while first page is fetched
            if (snapshot.connectionState == ConnectionState.waiting &&
                _games.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            // 2) Error state
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading games: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentPage = 1;
                          _gamesFuture = _fetchUserGames(page: 1);
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }
            // 3) Populate list on data
            if (snapshot.hasData && _games.isEmpty) {
              _games.addAll(snapshot.data!);
            }
            // 4) Empty state if still no games
            if (_games.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videogame_asset_off,
                        color: Colors.grey, size: 80),
                    const SizedBox(height: 16),
                    Text(
                      "${widget.username} hasn't created any games yet",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            // 5) List of games
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _games.length + (_hasMoreGames ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _games.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final game = _games[index];
                return _GameCard(
                  game: game,
                  isLiked: _isLiked[game.uuid] ?? false,
                  likes: _likesCount[game.uuid] ?? 0,
                  onLikeToggle: _handleLikeToggle,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final plock.Game game;
  final bool isLiked;
  final int likes;
  final Function(String, bool) onLikeToggle;

  const _GameCard({
    required this.game,
    required this.isLiked,
    required this.likes,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: game.thumbnailUrl != null &&
                          game.thumbnailUrl!.isNotEmpty
                      ? Image.network(
                          game.thumbnailUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(Icons.broken_image,
                                    size: 40, color: Colors.white70),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(Icons.image,
                                size: 40, color: Colors.white70),
                          ),
                        ),
                ),
                // Play button overlay
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Navigate to play the game directly
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => _GamePlayScreen(game: game),
                          ),
                        );
                      },
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Game type badge
                if (game.gameType != null && game.gameType!.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        game.gameType!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Game info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Game title
                Text(
                  game.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Game stats (likes, comments)
                Row(
                  children: [
                    // Likes
                    InkWell(
                      onTap: () => onLikeToggle(game.uuid, !isLiked),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$likes',
                            style: TextStyle(
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Comments
                    Row(
                      children: [
                        const Icon(
                          Icons.comment,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${game.commentsCount}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Share button
                    IconButton(
                      icon:
                          const Icon(Icons.share, color: Colors.grey, size: 20),
                      onPressed: () {
                        final url = 'https://plock.app/games/${game.uuid}';
                        Clipboard.setData(ClipboardData(text: url));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Link copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// A simple wrapper for playing a game
class _GamePlayScreen extends StatelessWidget {
  final plock.Game game;

  const _GamePlayScreen({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(game.name),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "Game play screen placeholder for: ${game.name}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
