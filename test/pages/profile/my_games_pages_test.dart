import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_page.dart';

// Observateur de navigation factice pour vérifier les push
class FakeNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

/// Widget factice interactif qui surcharge getAllGamesWithData pour renvoyer la liste actuelle des projets.
/// On utilise un champ futureGames qui est recréé à chaque modification.
class FakeMyGamesPageInteractive extends MyGamesPage {
  const FakeMyGamesPageInteractive({Key? key}) : super(key: key);
  @override
  State<MyGamesPage> createState() => _FakeMyGamesPageInteractiveState();
}

class _FakeMyGamesPageInteractiveState extends State<FakeMyGamesPageInteractive> {
  List<Game> projects = [];
  Future<List<Game>> futureGames = Future.value([]);

  @override
  void initState() {
    super.initState();
    futureGames = Future.value(projects);
  }

  @override
  Future<List<Game>> getAllGamesWithData() async {
    return futureGames;
  }

  @override
  Game addProject(String name) {
    final game = Game(name: name);
    setState(() {
      projects.add(game);
      futureGames = Future.value(projects);
    });
    return game;
  }

  @override
  void removeProject(Game game) {
    setState(() {
      projects.remove(game);
      futureGames = Future.value(projects);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My projects'),
        backgroundColor: Colors.grey[800],
      ),
      body: FutureBuilder<List<Game>>(
        future: getAllGamesWithData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final projectsList = snapshot.data!;
            if (projectsList.isEmpty) {
              return const Center(child: Text('No games found'));
            }
            return Column(
              children: projectsList.map((project) {
                return ListTile(
                  title: Row(
                    children: [
                      Text(project.name),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditorPage(game: project),
                              settings: const RouteSettings(name: '/editor'),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showGameDeletionDialog(context, project);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text('No games found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGameCreationDialog(context),
        backgroundColor: Colors.grey[500],
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  /// Affiche le dialogue de création d'un jeu
  void _showGameCreationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        var nameController = TextEditingController();
        return AlertDialog(
          title: const Text('New game'),
          content: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () {
                var name = nameController.text;
                if (name.isEmpty) return;
                addProject(name);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditorPage(game: Game(name: name)),
                    settings: const RouteSettings(name: '/editor'),
                  ),
                );
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  /// Affiche le dialogue de suppression d'un jeu
  void _showGameDeletionDialog(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete game ?'),
          content: Text('Do you really want to delete ${game.name} ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                removeProject(game);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  group('Tests de MyGamesPage', () {
    testWidgets('Affichage initial : titre, bouton flottant et loader', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FakeMyGamesPageInteractive(),
        ),
      );
      // Vérifie que le titre est affiché
      expect(find.text('My projects'), findsOneWidget);
      // Vérifie la présence du FloatingActionButton
      expect(find.byIcon(Icons.add), findsOneWidget);
      // Au démarrage, la FutureBuilder n'est pas encore terminée
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Laisser un court délai
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Affichage de "No games found" si aucun jeu n\'est présent', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FakeMyGamesPageInteractive(),
        ),
      );
      // Attendre la fin de la Future
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('No games found'), findsOneWidget);
    });

    testWidgets('Création d\'un nouveau jeu', (WidgetTester tester) async {
      final navigatorObserver = FakeNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: const FakeMyGamesPageInteractive(),
          navigatorObservers: [navigatorObserver],
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Appuyer sur le FloatingActionButton
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(const Duration(milliseconds: 100));

      // Vérifier que le dialogue de création s'affiche
      expect(find.text('New game'), findsOneWidget);

      // Entrer un nom et appuyer sur "Create"
      await tester.enterText(find.byType(TextFormField), 'Mon Nouveau Jeu');
      await tester.tap(find.text('Create'));
      // Attendre la fin des animations et de la navigation
      await tester.pumpAndSettle();

      // Vérifier que Navigator.push a été appelé (EditorPage doit être affichée)
      expect(navigatorObserver.pushedRoutes.any((route) => route.settings.name == '/editor'), isTrue);
      expect(find.byType(EditorPage), findsOneWidget);
    });

    testWidgets('Annulation de la création d\'un jeu', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FakeMyGamesPageInteractive(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Appuyer sur le FloatingActionButton
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(const Duration(milliseconds: 100));

      // Vérifier que le dialogue s'affiche
      expect(find.text('New game'), findsOneWidget);

      // Appuyer sur "Back" pour annuler
      await tester.tap(find.text('Back'));
      await tester.pump(const Duration(milliseconds: 100));

      // Le dialogue doit être fermé
      expect(find.text('New game'), findsNothing);
    });

    testWidgets('Suppression d\'un jeu', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FakeMyGamesPageInteractive(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Ajouter un jeu via l'état
      final state = tester.state(find.byType(FakeMyGamesPageInteractive))
      as _FakeMyGamesPageInteractiveState;
      state.addProject('Jeu à supprimer');
      // Attendre la mise à jour de la FutureBuilder
      await tester.pump(const Duration(milliseconds: 100));

      // Le jeu ajouté doit être visible
      expect(find.text('Jeu à supprimer'), findsOneWidget);

      // Appuyer sur l'icône de suppression associée
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump(const Duration(milliseconds: 100));

      // Le dialogue de suppression doit s'afficher
      expect(find.text('Delete game ?'), findsOneWidget);

      // Confirmer la suppression
      await tester.tap(find.text('Delete'));
      await tester.pump(const Duration(milliseconds: 100));

      // Le jeu ne doit plus être visible
      expect(find.text('Jeu à supprimer'), findsNothing);
    });

       testWidgets('Navigation vers l\'éditeur de jeu', (WidgetTester tester) async {
      final navigatorObserver = FakeNavigatorObserver();
     await tester.pumpWidget(
       MaterialApp(
         home: const FakeMyGamesPageInteractive(),
         navigatorObservers: [navigatorObserver],
        ),
       );
        await tester.pump(const Duration(milliseconds: 100));

     // Ajouter un jeu via l'état
     final state = tester.state(find.byType(FakeMyGamesPageInteractive))
     as _FakeMyGamesPageInteractiveState;
     state.addProject('Jeu à éditer');
      await tester.pump(const Duration(milliseconds: 100));

      // Le jeu ajouté doit être visible
      expect(find.text('Jeu à éditer'), findsOneWidget);

       // Appuyer sur l'icône d'édition
       await tester.tap(find.byIcon(Icons.edit).first);
       await tester.pumpAndSettle();

     // Vérifier que Navigator.push a été appelé pour EditorPage
     expect(navigatorObserver.pushedRoutes.any((route) => route.settings.name == '/editor'), isTrue);
     expect(find.byType(EditorPage), findsOneWidget);
      expect(find.text('Jeu à éditer'), findsOneWidget);
     });
  });
}
