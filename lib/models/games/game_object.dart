import 'package:plock_mobile/models/utils/Vector2.dart';
import 'component_type.dart';

class GameObject {
  late final String name;
  List<ComponentType> components = List<ComponentType>.empty(growable: true);
  Vector2 position = Vector2(0, 0);

  GameObject({required this.name});
}