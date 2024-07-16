import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';
import 'package:plock_mobile/pages/my_games/game_editor/edit_component_page.dart';

import '../../config.dart';
import 'blocks_positions.dart';

void main() {

  if (SKIP_BLOCKS_MATH)
    return;

  patrolTest(
      'Test Blockly number block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.1, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'local _ = 0\n');
      });

  patrolTest(
      'Test Blockly delta time block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.3, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'local _ = deltaTime()\n');
      });

  patrolTest(
      'Test Blockly + block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.6, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'local _ = 0 + 0\n');
      });

  patrolTest(
      'Test Blockly round block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.8, 0));

        final code = component.fields['event']!.value;
        expect(code, 'local _ = math.floor(3.1 + .5)\n');
      });

  patrolTest(
      'Test Blockly square root block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.3, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.2, 0));

        final code = component.fields['event']!.value;
        expect(code, 'local _ = math.sqrt(9)\n');
      });

  patrolTest(
      'Test Blockly sin block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.3, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.5, 0));

        final code = component.fields['event']!.value;
        expect(code, 'local _ = math.sin(math.rad(0))\n');
      });

  patrolTest(
      'Test Blockly PI block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.3, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.75, 0));

        final code = component.fields['event']!.value;
        expect(code, 'local _ = math.pi\n');
      });

  patrolTest(
      'Test Blockly is even block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.5, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.1, 0));

        final code = component.fields['event']!.value;
        expect(code, 'local _ = 0 % 2 == 0\n');
      });

  patrolTest(
      'Test Blockly sum of list block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.5, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.4, 0));

        final code = component.fields['event']!.value;
        expect(code, 'function math_sum(t)\n'
            '  local result = 0\n'
            '  for _, v in ipairs(t) do\n'
            '    result = result + v\n'
            '  end\n'
            '  return result\n'
            'end\n'
            '\n'
            '\n'
            'local _ = math_sum({})\n');
      });

  patrolTest(
      'Test Blockly remainder block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.5, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.8, 0));

        final code = component.fields['event']!.value;
        expect(code, 'local _ = 64 % 10\n');
      });

  patrolTest(
      'Test Blockly constrain block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.7, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.5, 0));

        final code = component.fields['event']!.value;
        expect(code, 'local _ = math.min(math.max(50, 1), 100)\n');
      });

  patrolTest(
      'Test Blockly random integer block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.9, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.3, 0));

        final code = component.fields['event']!.value;
        expect(code, 'local _ = math.random(0, 100)\n');
      });

  patrolTest(
      'Test Blockly random fraction block',
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
        await $.native2.tap(NativeSelector(android: AndroidSelector(text: "math")), timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.9, 0));
        await $.native2.tapAt(BLOCKLY_BLOCKS + Offset(0.8, 0));

        final code = component.fields['event']!.value;
        expect(code, 'local _ = math.random()\n');
      });
}