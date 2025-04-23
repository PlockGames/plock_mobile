// games_search_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';
import 'package:flame/game.dart';

class GamesSearchPage extends StatefulWidget {
  const GamesSearchPage({Key? key}) : super(key: key);

  @override
  State<GamesSearchPage> createState() => _GamesSearchPageState();
}

class _GamesSearchPageState extends State<GamesSearchPage>
    with AutomaticKeepAliveClientMixin {
  // ─────────────────────────  STATE
  late Future<List<plock.Game>> _gamesFuture;
  final Map<String, bool> _isLiked = {};
  final Map<String, int> _likesCount = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<plock.Game> _allGames = [];
  List<plock.Game> _filteredGames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _gamesFuture = _fetchGames();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterGames();
    });
  }

  void _filterGames() {
    if (_searchQuery.isEmpty) {
      _filteredGames = List.from(_allGames);
    } else {
      _filteredGames = _allGames
          .where((game) =>
              game.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (game.gameType != null &&
                  game.gameType!
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase())))
          .toList();
    }
  }

  @override
  bool get wantKeepAlive => true;

  // ─────────────────────────  DATA
  Future<List<plock.Game>> _fetchGames() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.getAllGames(null);
      final decoded = jsonDecode(response.body)['data']['data'] as List;
      final List<plock.Game> games = [];

      for (final raw in decoded) {
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
          ..gameType = raw['gameType'] ?? 'Unknown';

        _isLiked[game.uuid] = raw['hasLiked'] ?? false;
        _likesCount[game.uuid] = raw['likes'] ?? 0;
        games.add(game);
      }

      setState(() {
        _allGames = games;
        _filteredGames = List.from(_allGames);
        _isLoading = false;
      });

      return games;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching games: $e');
      return [];
    }
  }

  Future<void> _refreshGames() async {
    setState(() {
      _gamesFuture = _fetchGames();
    });
  }

  // ─────────────────────────  LIKE HANDLER
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

  // ─────────────────────────  UI
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAlive
    return Scaffold(
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: FutureBuilder<List<plock.Game>>(
              future: _gamesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Error loading games'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshGames,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (_filteredGames.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No games found'),
                        if (_searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('No results for "$_searchQuery"'),
                        ],
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshGames,
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _refreshGames();
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = _filteredGames[index];
                      return _GameCard(
                        key: ValueKey(game.uuid),
                        game: game,
                        isLiked: _isLiked[game.uuid] ?? false,
                        likes: _likesCount[game.uuid] ?? 0,
                        onLikeToggle: _handleLikeToggle,
                        onTap: () => _openGamePlayer(context, game),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surface,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search games...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ),
    );
  }

  void _openGamePlayer(BuildContext context, plock.Game game) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(game.name),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: GameWidget(game: GamePlayer(game: game)),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final plock.Game game;
  final bool isLiked;
  final int likes;
  final void Function(String id, bool like) onLikeToggle;
  final VoidCallback onTap;

  const _GameCard({
    Key? key,
    required this.game,
    required this.isLiked,
    required this.likes,
    required this.onLikeToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: game.thumbnailUrl != null
                  ? Image.network(
                      game.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 40),
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
                        child: Icon(Icons.image, size: 40),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.gameType ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text('$likes'),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : null,
                          ),
                          iconSize: 22,
                          onPressed: () => onLikeToggle(game.uuid, !isLiked),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
