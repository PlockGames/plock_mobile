// games_search_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/theme.dart'; // Importer le thème
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';
import 'package:flame/game.dart';
import 'package:plock_mobile/widgets/loading_logo_animation.dart'; // Importer le widget de chargement
import 'package:plock_mobile/widgets/tag_selector.dart'; // Import the tag selector

class GamesSearchPage extends StatefulWidget {
  const GamesSearchPage({Key? key}) : super(key: key);

  @override
  State<GamesSearchPage> createState() => _GamesSearchPageState();
}

class _GamesSearchPageState extends State<GamesSearchPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // ─────────────────────────  STATE
  late Future<List<plock.Game>> _gamesFuture;
  final Map<String, bool> _isLiked = {};
  final Map<String, int> _likesCount = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<plock.Game> _allGames = [];
  List<plock.Game> _filteredGames = [];
  bool _isLoading = true;

  // Paginación
  int _currentPage = 1;
  int _lastPage = 1;
  bool _hasMore = false;

  // Tag filtering
  List<String> _selectedTags = [];
  Map<String, String> _tagNames = {}; // Maps tag ID to tag name

  // Animation controller for filtering
  late final AnimationController _filterAnimationController;
  late final Animation<double> _filterAnimation;

  @override
  void initState() {
    super.initState();
    _gamesFuture = _fetchGames();
    _searchController.addListener(_onSearchChanged);

    // Initialize animation controller
    _filterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    );

    // Load tag names
    _loadTags();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadTags() async {
    try {
      final response = await ApiService.getTags(null);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);

        if (decoded['data'] != null && decoded['data']['data'] != null) {
          final List<dynamic> tagsData = decoded['data']['data'];

          setState(() {
            for (final tag in tagsData) {
              _tagNames[tag['id']] = tag['name'];
            }
          });
        }
      }
    } catch (e) {
      print('Error loading tags: $e');
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
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
      // Imprimir información de depuración sobre lo que estamos haciendo
      print("Fetching games with tags: $_selectedTags");

      // Usar los nuevos parámetros de búsqueda, etiquetas y paginación
      final response = await ApiService.getAllGames(
        _currentPage,
        perPage: 50,
        tags: _selectedTags.isNotEmpty ? _selectedTags : null,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      if (response.statusCode != 200) {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Error fetching games: ${response.statusCode}');
      }

      // Imprimir la respuesta completa para análisis
      print("API response: ${response.body}");

      final decodedResponse = jsonDecode(response.body);
      final decoded = decodedResponse['data']['data'] as List;

      // Actualizar metadata de paginación
      if (decodedResponse['data']['meta'] != null) {
        final meta = decodedResponse['data']['meta'];
        _lastPage = meta['lastPage'] ?? 1;
      }

      final List<plock.Game> games = [];

      // Si tenemos tags seleccionados, vamos a asignarlos a los juegos que recibimos
      // Esto es una solución alternativa en caso de que el servidor no devuelva correctamente los tags
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

          // Add tags from the API response if available
          if (raw['tags'] != null && (raw['tags'] as List).isNotEmpty) {
            print("Game ${game.name} has tags in API response: ${raw['tags']}");
            game.tags = List<String>.from(raw['tags'].map((tag) => tag['id']));
          }
          // Si no hay tags en la respuesta pero estamos filtrando por tags,
          // asignamos manualmente los tags seleccionados a estos juegos
          else if (_selectedTags.isNotEmpty) {
            print("Asignando tags manualmente a ${game.name}");
            // Esta es una solución temporal - asumimos que si el juego fue devuelto
            // por la API cuando filtramos por tags, entonces esos tags aplican a ese juego
            game.tags = List.from(_selectedTags);
          }

          print("Game ${game.name} tags después de procesar: ${game.tags}");

          _isLiked[game.uuid] = raw['hasLiked'] ?? false;
          _likesCount[game.uuid] = raw['likes'] ?? 0;
          games.add(game);
        } catch (e) {
          print('Error processing game: $e');
          continue;
        }
      }

      setState(() {
        // Si es la primera página, reemplazar la lista
        if (_currentPage == 1) {
          _allGames = games;
        } else {
          // Si no, añadir a la lista existente
          _allGames.addAll(games);
        }

        _filteredGames = List.from(_allGames);
        _isLoading = false;
        _hasMore = _currentPage < _lastPage;
      });

      print("Juegos cargados: ${games.length}");
      for (var game in games) {
        print("Juego: ${game.name}, Tags: ${game.tags}");
      }

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
      backgroundColor: PlockTheme.backgroundDark, // Utiliser backgroundDark
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTagFilterBar(),
          Expanded(
            child: FutureBuilder<List<plock.Game>>(
              future: _gamesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _isLoading) {
                  return const LoadingLogoAnimation(); // Utiliser l'animation du logo
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Error loading games'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PlockTheme
                                .primaryOrange, // Utiliser primaryOrange
                            foregroundColor: PlockTheme
                                .textOnPrimaryOrange, // Utiliser textOnPrimaryOrange
                          ),
                          onPressed: _refreshGames,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // If no games match the current filters, show a friendly message
                if (_filteredGames.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: PlockTheme.textMuted,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No games found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PlockTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_searchQuery.isNotEmpty)
                          Text(
                            'No results for "$_searchQuery"',
                            style: const TextStyle(
                              color: PlockTheme.textSecondary,
                            ),
                          ),
                        if (_selectedTags.isNotEmpty)
                          const Text(
                            'Try selecting different tags',
                            style: TextStyle(
                              color: PlockTheme.textSecondary,
                            ),
                          ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset Filters'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PlockTheme.primaryOrange,
                            foregroundColor: PlockTheme.textOnPrimaryOrange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _selectedTags.clear();
                            _refreshGames();
                            _filterAnimationController.reverse();
                          },
                        ),
                      ],
                    ),
                  );
                }

                // If tag filtering is active, show games grouped by tags
                if (_selectedTags.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await _refreshGames();
                    },
                    child: _buildTagBasedGroupList(),
                  );
                }

                // Otherwise, show the regular grid view
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

  Widget _buildTagFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: PlockTheme.backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Filter by Tags',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: PlockTheme.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.filter_list, size: 18),
                label: const Text('Select Tags'),
                onPressed: _showTagSelector,
                style: TextButton.styleFrom(
                  foregroundColor: PlockTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              if (_selectedTags.isNotEmpty)
                TextButton(
                  onPressed: _clearTagFilters,
                  child: const Text('Clear'),
                  style: TextButton.styleFrom(
                    foregroundColor: PlockTheme.errorColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
            ],
          ),
          if (_selectedTags.isNotEmpty)
            SizedBox(
              height: 40,
              child: AnimatedBuilder(
                animation: _filterAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _filterAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_filterAnimation),
                      child: child,
                    ),
                  );
                },
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedTags.length,
                  itemBuilder: (context, index) {
                    final tagId = _selectedTags[index];
                    final tagName = _tagNames[tagId] ?? 'Unknown Tag';

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                      child: Chip(
                        backgroundColor:
                            PlockTheme.primaryBlue.withOpacity(0.2),
                        side: const BorderSide(
                            color: PlockTheme.primaryBlue, width: 1),
                        label: Text(
                          tagName,
                          style: const TextStyle(
                            color: PlockTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 16,
                          color: PlockTheme.primaryBlue,
                        ),
                        onDeleted: () => _removeTag(tagId),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showTagSelector() async {
    print("Currently selected tags: $_selectedTags");
    final selectedTags = await showTagSelector(
      context,
      initialSelectedTags: _selectedTags,
    );

    if (selectedTags != null) {
      print("User selected tags: $selectedTags");
      setState(() {
        _selectedTags = selectedTags;
        _applyFilters();
      });

      if (_selectedTags.isNotEmpty) {
        _filterAnimationController.forward();
      } else {
        _filterAnimationController.reverse();
      }
    }
  }

  void _removeTag(String tagId) {
    setState(() {
      _selectedTags.remove(tagId);
      _applyFilters();
    });

    if (_selectedTags.isEmpty) {
      _filterAnimationController.reverse();
    }
  }

  void _clearTagFilters() {
    setState(() {
      _selectedTags.clear();
      _applyFilters();
    });

    _filterAnimationController.reverse();
  }

  void _applyFilters() {
    // Reiniciar la paginación
    _currentPage = 1;

    // Volver a cargar los juegos con los nuevos filtros
    setState(() {
      _gamesFuture = _fetchGames();
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: PlockTheme.backgroundLight, // Utiliser backgroundLight
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: PlockTheme.textPrimary), // Couleur du texte
        decoration: InputDecoration(
          hintText: 'Search games...',
          hintStyle: TextStyle(color: PlockTheme.textMuted), // Couleur du hint
          prefixIcon: const Icon(Icons.search,
              color: PlockTheme.textMuted), // Couleur icône
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear,
                      color: PlockTheme.textMuted), // Couleur icône
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // Pas de bordure
          ),
          filled: true,
          fillColor: PlockTheme.cardColor, // Utiliser cardColor
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

  Widget _buildTagBasedGroupList() {
    // Create a map of tag ID to games with that tag
    Map<String, List<plock.Game>> gamesByTag = {};

    // Imprimir para depuración
    print("Building tag-based group list");
    print("Selected tags: $_selectedTags");
    print("Filtered games count: ${_filteredGames.length}");

    // Recorrer todos los juegos filtrados
    for (final game in _filteredGames) {
      print("Game ${game.name} has tags: ${game.tags}");

      // Si el juego no tiene tags, saltamos al siguiente
      if (game.tags.isEmpty) continue;

      // Por cada tag seleccionado, verificar si el juego tiene ese tag
      for (final tagId in _selectedTags) {
        if (game.tags.contains(tagId)) {
          // Si el juego tiene el tag, agregarlo al mapa
          if (!gamesByTag.containsKey(tagId)) {
            gamesByTag[tagId] = [];
          }

          // Evitar duplicados
          if (!gamesByTag[tagId]!.contains(game)) {
            gamesByTag[tagId]!.add(game);
          }
        }
      }
    }

    print(
        "Games by tag: ${gamesByTag.map((key, value) => MapEntry(key, value.length))}");

    // Si no hay juegos que coincidan con los tags seleccionados
    if (gamesByTag.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.filter_alt_off,
              size: 64,
              color: PlockTheme.textMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'No games match the selected tags',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: PlockTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Clear Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PlockTheme.primaryOrange,
                foregroundColor: PlockTheme.textOnPrimaryOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: _clearTagFilters,
            ),
          ],
        ),
      );
    }

    // Construir la lista con secciones para cada tag
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: gamesByTag.length,
      itemBuilder: (context, index) {
        final tagId = gamesByTag.keys.elementAt(index);
        final tagName = _tagNames[tagId] ?? 'Tag ID: $tagId';
        final gamesForTag = gamesByTag[tagId]!;

        return _buildTagSection(tagName, gamesForTag);
      },
    );
  }

  Widget _buildTagSection(String tagName, List<plock.Game> games) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Tag chip
              Chip(
                backgroundColor: PlockTheme.primaryBlue.withOpacity(0.2),
                side: const BorderSide(color: PlockTheme.primaryBlue, width: 1),
                label: Text(
                  tagName,
                  style: const TextStyle(
                    color: PlockTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Game count
              Text(
                '${games.length} game${games.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  color: PlockTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Horizontal scrolling list of games for this tag
        SizedBox(
          height: 240,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return _HorizontalGameCard(
                game: game,
                isLiked: _isLiked[game.uuid] ?? false,
                likes: _likesCount[game.uuid] ?? 0,
                onLikeToggle: _handleLikeToggle,
                onTap: () => _openGamePlayer(context, game),
              );
            },
          ),
        ),

        // Divider between sections
        const Divider(
          height: 32,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
      ],
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
                            child: LoadingLogoAnimation(
                                size:
                                    40), // Utiliser l'animation du logo (plus petite)
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
                        color: PlockTheme.textMuted, // Utiliser textMuted
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Stats row with likes and comments
                        Row(
                          children: [
                            // Likes count
                            Icon(
                              Icons.favorite,
                              color: isLiked
                                  ? PlockTheme.errorColor
                                  : PlockTheme
                                      .textMuted, // Utiliser errorColor ou textMuted
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text('$likes'),

                            // Comments count
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.comment,
                              color: PlockTheme
                                  .primaryBlue, // Utiliser primaryBlue
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text('${game.commentsCount}'),
                          ],
                        ),

                        // Like button
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked
                                ? PlockTheme.errorColor
                                : PlockTheme
                                    .textMuted, // Utiliser errorColor ou textMuted
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

class _HorizontalGameCard extends StatelessWidget {
  final plock.Game game;
  final bool isLiked;
  final int likes;
  final void Function(String id, bool like) onLikeToggle;
  final VoidCallback onTap;

  const _HorizontalGameCard({
    Key? key,
    required this.game,
    required this.isLiked,
    required this.likes,
    required this.onLikeToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
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
              // Game thumbnail
              Stack(
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
                                  child:
                                      Icon(Icons.image_not_supported, size: 40),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: LoadingLogoAnimation(size: 40),
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

                  // Play button overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: PlockTheme.primaryBlue.withOpacity(0.8),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Game info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Game title
                      Text(
                        game.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: PlockTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Game type
                      Text(
                        game.gameType ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 12,
                          color: PlockTheme.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Spacer(),

                      // Stats and like button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Stats row with likes and comments
                          Row(
                            children: [
                              // Likes count
                              Icon(
                                Icons.favorite,
                                color: isLiked
                                    ? PlockTheme.errorColor
                                    : PlockTheme.textMuted,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$likes',
                                style: const TextStyle(
                                  color: PlockTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),

                              // Comments count
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.comment,
                                color: PlockTheme.primaryBlue,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${game.commentsCount}',
                                style: const TextStyle(
                                  color: PlockTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          // Like button
                          InkWell(
                            onTap: () => onLikeToggle(game.uuid, !isLiked),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked
                                    ? PlockTheme.errorColor
                                    : PlockTheme.textMuted,
                                size: 20,
                              ),
                            ),
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
      ),
    );
  }
}
