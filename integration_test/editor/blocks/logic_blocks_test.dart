import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';
import 'package:plock_mobile/pages/my_games/game_editor/edit_component_page.dart';

import '../../config.dart';
import 'blocks_positions.dart';

void main() {

  if (SKIP_BLOCKS_LOGIC)
    return;

  patrolTest(
      'Test Blockly If block',
      framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive,
  ($) async {

        ComponentEvent component = ComponentEvent();
        final wrapper = MaterialApp(
          home: Scaffold(
            body: EditComponentPage(component: component),
          ),
        );

        // Ensure blockly is launched
        await $.pumpWidgetAndSettle(wrapper);
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "logic")), timeout: Duration(seconds: 10));
        await $.pump(Duration(milliseconds: 100));

        // get screen size
        final size = $.tester.binding.window.physicalSize;

        final debug = component.debugData['event'];
        final x = debug['width'].toDouble() / size.width;
        final y = debug['height'].toDouble() / size.height;

        //expect(x, 0.5);
        await $.native2.tapAt(Offset(x, y));

        //final code = component.fields['event']!.value;
        //expect(code,'if false then\n'
        //'end\n');

  });

}

