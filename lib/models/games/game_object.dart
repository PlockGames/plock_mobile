import 'package:plock_mobile/models/utils/Vector2.dart';
import 'component.dart';

class GameObject {
  final String name;
  List<Component> components = List<Component>.empty(growable: true);
  Vector2 position = Vector2(0, 0);

  GameObject({required this.name});
}