import 'game_object.dart';

class Game {
  final String name;
  List<GameObject> objects = List<GameObject>.empty(growable: true);

  Game({required this.name});
}