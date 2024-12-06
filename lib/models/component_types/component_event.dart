import 'package:plock_mobile/models/component_fields/component_field_blocky.dart';
import 'package:plock_mobile/models/component_fields/component_field_drop_down.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';

import '../games/component_type.dart';

/// A component that represent an event.
class ComponentEvent extends ComponentType {

  ComponentEvent() {
    fields["name"] = ComponentFieldText(value: "my_event");
    fields["trigger"] = ComponentFieldDropDown(value: "ON_START", options:
    {
      "ON_START": "0n Start",
      "ON_UPDATE": "On Update",
      "ON_TAP": "On Tap",
      "ON_COLLISION": "On Collision",
    });
    fields["event"] = ComponentFieldBlockly();
  }

  @override
  Map<String, dynamic> get debugData => {
    "event": fields["event"]!.debugData,
  };

  @override
  String get type => 'ComponentEvent';

  @override
  String get name => 'Event';

  @override
  ComponentType instance() {
    ComponentEvent comp = ComponentEvent();
    fields.forEach((key, value) {
      comp.fields[key] = value.instance();
    });
    return comp;
  }
}