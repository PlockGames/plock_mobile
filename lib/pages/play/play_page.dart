// play_page.dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/models/comment.dart';
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

class PlayPage extends StatefulWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage>
    with AutomaticKeepAliveClientMixin {
  // ─────────────────────────  STATE
  final PageController _pageController = PageController();
  late Future<List<plock.Game>> _gamesFuture;
  final Map<String, bool> _isLiked = {};
  final Map<String, int> _likesCount = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _gamesFuture = _fetchGames();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Always refresh games when entering the page
    setState(() {
      _gamesFuture = _fetchGames();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  // ─────────────────────────  DATA
  Future<List<plock.Game>> _fetchGames() async {
    try {
      // Use the recommendation endpoint instead of getAllGames
      final response = await ApiService.getRecommendedGames(1);

      if (response.statusCode != 200) {
        print('Error: ${response.statusCode} - ${response.body}');
        return [];
      }

      final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      final List<dynamic> decoded = decodedResponse['data'] as List;
      final List<plock.Game> games = [];

      for (final raw in decoded) {
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
            ..likes = raw['likes']
            ..gameType = raw['gameType'] ?? 'Unknown'
            ..commentsCount = raw['commentsCount'] ?? 0;

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
      print('Error fetching recommended games: $e');
      return [];
    }
  }

  // ─────────────────────────  UI
  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAlive
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<plock.Game>>(
        future: _gamesFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data!.isEmpty) {
            return const Center(child: Text('No games available'));
          }
          final games = snap.data!;
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return _GameScreen(
                key: ValueKey(game.uuid),
                game: game,
                isLiked: _isLiked[game.uuid] ?? false,
                likes: _likesCount[game.uuid] ?? 0,
                onLikeToggle: _handleLikeToggle,
              );
            },
          );
        },
      ),
    );
  }

  // ─────────────────────────  LIKE HANDLER
  Future<void> _handleLikeToggle(String gameId, bool like) async {
    setState(() {
      _isLiked[gameId] = like;
      _likesCount[gameId] =
          (_likesCount[gameId] ?? 0) + (like ? 1 : -1).clamp(-1, 1);
    });
    like
        ? await ApiService.addLikeGame(gameId) //
        : await ApiService.deleteGame(gameId);
  }
}

// ─────────────────────────  GAME SCREEN WIDGET
class _GameScreen extends StatelessWidget {
  final plock.Game game;
  final bool isLiked;
  final int likes;
  final void Function(String id, bool like) onLikeToggle;

  const _GameScreen({
    super.key,
    required this.game,
    required this.isLiked,
    required this.likes,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Juego ocupando toda la pantalla
        GameWidget(game: GamePlayer(game: game)),

        // Capa de información
        _BottomOverlay(game: game),

        // Botones flotantes
        _ActionButtons(
          game: game,
          isLiked: isLiked,
          likes: likes,
          onLikeToggle: onLikeToggle,
        ),
      ],
    );
  }
}

// ─────────────────────────  OVERLAYS & BUTTONS (extract‑widget para limpieza)
class _BottomOverlay extends StatelessWidget {
  const _BottomOverlay({required this.game});
  final plock.Game game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 12,
      right: 80,
      bottom: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(game.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('@${game.gameType}',
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.game,
    required this.isLiked,
    required this.likes,
    required this.onLikeToggle,
  });

  final plock.Game game;
  final bool isLiked;
  final int likes;
  final void Function(String id, bool like) onLikeToggle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 80,
      child: Column(
        children: [
          // Like button
          IconButton(
            icon: Icon(Icons.favorite,
                color: isLiked ? Colors.red : Colors.white, size: 40),
            onPressed: () => onLikeToggle(game.uuid, !isLiked),
          ),
          Text('$likes',
              style: const TextStyle(color: Colors.white, fontSize: 14)),

          // Comment button
          const SizedBox(height: 24),
          IconButton(
            icon: const Icon(Icons.comment, color: Colors.white, size: 36),
            onPressed: () async {
              // Show the comments bottom sheet and wait for it to close
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => CommentsBottomSheet(game: game),
              );

              // Force rebuild of the widget to reflect the updated comment count
              // This will ensure the count is updated in the UI after closing the bottom sheet
              if (context.mounted) {
                (context as Element).markNeedsBuild();
              }
            },
          ),
          Text('${game.commentsCount}',
              style: const TextStyle(color: Colors.white, fontSize: 14)),

          // Share button
          const SizedBox(height: 24),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white, size: 36),
            onPressed: () {
              final url = 'https://plock.app/games/${game.uuid}';
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Link copied'),
                  behavior: SnackBarBehavior.floating));
            },
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for displaying and adding comments to a game
class CommentsBottomSheet extends StatefulWidget {
  final plock.Game game;

  const CommentsBottomSheet({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  late Future<List<Comment>> _commentsFuture;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;
  int _currentPage = 1;
  int _lastPage = 1;
  bool _hasMore = false;
  final List<Comment> _comments = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _commentsFuture = _fetchComments();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore &&
        !_isSubmitting) {
      _loadMoreComments();
    }
  }

  Future<void> _loadMoreComments() async {
    if (_currentPage < _lastPage) {
      setState(() {
        _currentPage++;
      });

      final newComments = await _fetchComments(page: _currentPage);

      setState(() {
        _comments.addAll(newComments);
      });
    }
  }

  Future<List<Comment>> _fetchComments({int? page}) async {
    try {
      final response = await ApiService.getGameComments(
        widget.game.uuid,
        page: page ?? 1,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (decoded['data'] == null ||
          decoded['data']['data'] == null ||
          decoded['data']['meta'] == null) {
        throw Exception('Invalid response format');
      }

      final List<dynamic> commentsData = decoded['data']['data'];
      final meta = decoded['data']['meta'];

      // Update pagination info
      _lastPage = meta['lastPage'] ?? 1;
      _hasMore = _currentPage < _lastPage;

      // First load - store all comments
      if (page == null || page == 1) {
        _comments.clear();
        final List<Comment> comments = commentsData
            .map<Comment>((data) => Comment.fromJson(data))
            .toList();
        _comments.addAll(comments);
        return _comments;
      }
      // For pagination, return only the new comments
      else {
        return commentsData
            .map<Comment>((data) => Comment.fromJson(data))
            .toList();
      }
    } catch (e) {
      developer.log('Error fetching comments: $e', name: 'CommentsBottomSheet');
      return [];
    }
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response =
          await ApiService.addGameComment(widget.game.uuid, content);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Clear the input field
        _commentController.clear();

        // Update the comment count on the game
        setState(() {
          widget.game.commentsCount++;
        });

        // Explicitly refetch the comments to ensure we get the latest data
        _currentPage = 1;
        final freshComments =
            await ApiService.getGameComments(widget.game.uuid);

        if (freshComments.statusCode == 200) {
          final Map<String, dynamic> decoded = jsonDecode(freshComments.body);

          if (decoded['data'] != null &&
              decoded['data']['data'] != null &&
              decoded['data']['meta'] != null) {
            final List<dynamic> commentsData = decoded['data']['data'];
            final meta = decoded['data']['meta'];

            final List<Comment> newComments = commentsData
                .map<Comment>((data) => Comment.fromJson(data))
                .toList();

            setState(() {
              _comments.clear();
              _comments.addAll(newComments);
              _lastPage = meta['lastPage'] ?? 1;
              _hasMore = _currentPage < _lastPage;
            });

            // Rebuild the future to ensure FutureBuilder updates
            _commentsFuture = Future.value(_comments);
          }
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add comment: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      developer.log('Error submitting comment: $e',
          name: 'CommentsBottomSheet');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comments (${widget.game.commentsCount})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Comments list
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _comments.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading comments: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (_comments.isEmpty) {
                  return const Center(
                    child: Text(
                      'No comments yet. Be the first to comment!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _comments.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _comments.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final comment = _comments[index];
                    return _CommentItem(comment: comment);
                  },
                );
              },
            ),
          ),

          // Comment input
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.black,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send, color: Colors.blue),
                  onPressed: _isSubmitting ? null : _submitComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final Comment comment;

  const _CommentItem({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              // User avatar
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                backgroundImage: comment.user.profilePic != null
                    ? NetworkImage(comment.user.profilePic!)
                    : null,
                child: comment.user.profilePic == null
                    ? Text(
                        comment.user.username.isNotEmpty
                            ? comment.user.username[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),

              // Username
              Text(
                comment.user.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              // Comment date
              Text(
                _formatDate(comment.createdAt),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Comment content
          Text(
            comment.content,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
