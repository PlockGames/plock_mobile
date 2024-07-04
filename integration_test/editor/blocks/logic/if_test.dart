import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_blocky.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:patrol/patrol.dart';

void main() {
  ComponentFieldBlockly componentFieldBlockly = ComponentFieldBlockly();

  patrolTest(
      'Open Component Field Blocky Widget',
  ($) async {
    await $.pumpWidget(componentFieldBlockly.getField('integration_test'));

    await $('Logic').tap();
  });
}