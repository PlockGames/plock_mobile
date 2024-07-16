import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';
import 'package:plock_mobile/pages/my_games/game_editor/edit_component_page.dart';

import '../../config.dart';
import 'blocks_positions.dart';

void main() {

  if (SKIP_BLOCKS_LOOPS)
    return;

  patrolTest(
      'Test Blockly repeat block',
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
    await $.native2.tap(NativeSelector(android: AndroidSelector(text: "loops")), timeout: Duration(seconds: 10));
    await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.1, 0)); // Tap on the repeat block

    final code = component.fields['event']!.value;
    expect(code,'for count = 1, 1 do\n'
    'end\n');
  });

  patrolTest(
      'Test Blockly while block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "loops")), timeout: Duration(seconds: 10));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.5, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'while false do\n'
            'end\n');
      });

  patrolTest(
      'Test Blockly for block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "loops")), timeout: Duration(seconds: 10));
        await $.native2.tapAt(BLOCKLY_SCROLL_LOOPS + Offset(0.45, 0)); // Scroll to the for block
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.5, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'for controls_for = 1, 10, 1 do\n'
            'end\n');
      });

  patrolTest(
      'Test Blockly foreach item block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "loops")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_LOOPS + Offset(0.1, 0), to: BLOCKLY_SCROLL_LOOPS + Offset(0.8, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.5, 0));

        final code = component.fields['event']!.value;
        expect(code, 'for _, i in ipairs({}) do\n'
            'end\n');
      });

  patrolTest(
      'Test Blockly break block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "loops")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_LOOPS + Offset(0.1, 0), to: BLOCKLY_SCROLL_LOOPS + Offset(0.8, 0));
        // break block can't be used as standalone, so we're using foreach block
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.5, 0)); // foreach block

        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "loops")));
        await $.native.swipe(from: BLOCKLY_SCROLL_LOOPS + Offset(0.1, 0), to: BLOCKLY_SCROLL_LOOPS + Offset(0.8, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.8, 0)); // break block
        await $.native.swipe(from: BLOCKLY_BLOCKS + Offset(0.8, 0), to: BLOCKLY_BLOCKS + Offset(0.47, 0.06));

        final code = component.fields['event']!.value;
        expect(code,
            'for _, i in ipairs({}) do\n'
            '  break\n'
            'end\n');
      });
}