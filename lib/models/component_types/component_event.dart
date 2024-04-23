import 'package:plock_mobile/models/component_fields/component_field_blocky.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';

import '../games/component_type.dart';

class ComponentEvent extends ComponentType {

  ComponentEvent() {
    fields["trigger"] = ComponentFieldText(value: "test");
    fields["event"] = ComponentFieldBlocky();
  }

  @override
  String get type => 'ComponentEvent';

  @override
  String get name => 'Event';
}