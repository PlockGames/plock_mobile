import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';
import 'package:plock_mobile/pages/my_games/game_editor/edit_component_page.dart';

import '../../config.dart';
import 'blocks_positions.dart';

void main() {
  if (SKIP_BLOCKS_TEXT)
    return;

  patrolTest(
      'Test Blockly get letter block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.1, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'local _ = string.sub(\'\', 1, 1)\n');
      });

  patrolTest(
      'Test Blockly text block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.7, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'local _ = \'text\'\n');
      });

  patrolTest(
      'Test Blockly text from number block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.25, 0));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.1, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'local _ = tostring(0)\n');
      });

  patrolTest(
      'Test Blockly length of block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.25, 0));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.7, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'local _ = #\'abc\'\n');
      });

  patrolTest(
      'Test Blockly is empty of block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.36, 0));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.2, 0)); // Tap on the repeat block

        final code = component.fields['event']!.value;
        expect(code, 'local _ = #\'\' == 0\n');
      });

  patrolTest(
      'Test Blockly find first occurence block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.36, 0));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.8, 0));

        final code = component.fields['event']!.value;
        expect(code, '');
      });

  patrolTest(
      'Test Blockly find create with block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.6, 0));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.2, 0));

        final code = component.fields['event']!.value;
        expect(code, '');
      });

  patrolTest(
      'Test Blockly find substring block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.6, 0));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.8, 0));

        final code = component.fields['event']!.value;
        expect(code, '');
      });

  patrolTest(
      'Test Blockly find uppercase block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.78, 0));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.15, 0));

        final code = component.fields['event']!.value;
        expect(code, '');
      });

  patrolTest(
      'Test Blockly find trim spaces block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.78, 0));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.7, 0));

        final code = component.fields['event']!.value;
        expect(code, '');
      });

  patrolTest(
      'Test Blockly find number from text block',
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
        await $.native2.tap(
            NativeSelector(android: AndroidSelector(text: "text")),
            timeout: Duration(seconds: 10));
        await $.native.swipe(from: BLOCKLY_SCROLL_MATH + Offset(0.1, 0), to: BLOCKLY_SCROLL_MATH + Offset(0.8, 0));
        await $.native2.tapAt(
            BLOCKLY_BLOCKS + Offset(0.8, 0));

        final code = component.fields['event']!.value;
        expect(code, '');
      });
}

