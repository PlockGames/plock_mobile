import 'package:plock_mobile/models/utils/Vector2.dart';
import 'component_type.dart';

class GameObject {
  late String name;
  List<ComponentType> components = List<ComponentType>.empty(growable: true);
  Vector2 position = Vector2(12, 12);

  GameObject({required this.name});
}
