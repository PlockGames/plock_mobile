// play_page.dart
import 'dart:convert';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';

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
    final response = await ApiService.getAllGames(1);
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
    return games;
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
            return const Center(child: Text('Sin juegos disponibles'));
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
          IconButton(
            icon: Icon(Icons.favorite,
                color: isLiked ? Colors.red : Colors.white, size: 40),
            onPressed: () => onLikeToggle(game.uuid, !isLiked),
          ),
          Text('$likes',
              style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 24),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white, size: 36),
            onPressed: () {
              final url = 'https://plock.app/games/${game.uuid}';
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Enlace copiado'),
                  behavior: SnackBarBehavior.floating));
            },
          ),
        ],
      ),
    );
  }
}
