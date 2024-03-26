import 'package:plock_mobile/models/component_fields/component_field_number.dart';

import '../games/component_type.dart';

class ComponentRect extends ComponentType {

  ComponentRect() {
    fields["width"] = ComponentFieldNumber(value: 0);
    fields["height"] = ComponentFieldNumber(value: 0);
  }

  @override
  String get type => 'ComponentRect';

  @override
  String get name => 'Rectangle';
}