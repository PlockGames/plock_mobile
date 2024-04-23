import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/initial_toolbox.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:flutter_blockly/flutter_blockly.dart' as Blocky;

class ComponentFieldBlocky extends ComponentField {
  static const Map<String, dynamic> initialJson = {
    'blocks': {
      'languageVersion': 0,
      'blocks': [
        {
          'type': 'text',
          'x': 70,
          'y': 30,
          'fields': {'TEXT': 'JSON'}
        }
      ],
    },
  };

  ComponentFieldBlocky();

  @override
  String get type => 'ComponentFieldBlocky';

  @override
  Widget getField(String name) {
    const Blocky.Theme blockyTheme = Blocky.Theme(
      name: 'classic',
      fontStyle: Blocky.BlocklyFontStyle(
        family: 'Arial, sans-serif',
        weight: 'normal',
        size: 8,
      ),
    );

    print(initialToolbox.toJson());
    Blocky.BlocklyOptions workspaceConfiguration = Blocky.BlocklyOptions(
      theme: blockyTheme,
      css: true,
      move: const Blocky.MoveOptions(
        drag: true,
        wheel: true,
        scrollbars: Blocky.ScrollbarOptions(
          horizontal: false,
          vertical: false,
        )
      ),
      toolbox: Blocky.ToolboxInfo.fromJson(initialToolbox.toJson()),
      horizontalLayout: true,
      collapse: false,
      trashcan: false,

    );

    void onInject(Blocky.BlocklyData data) {
      debugPrint('onInject: ${data.xml}\n${jsonEncode(data.json)}');
    }

    void onChange(Blocky.BlocklyData data) {
      debugPrint('onChange: ${data.xml}\n${jsonEncode(data.json)}\n${data.dart}');
    }

    void onDispose(Blocky.BlocklyData data) {
      debugPrint('onDispose: ${data.xml}\n${jsonEncode(data.json)}');
    }

    void onError(dynamic err) {
      debugPrint('onError: $err');
    }


    return Expanded(
        child: Blocky.BlocklyEditorWidget(
          workspaceConfiguration: workspaceConfiguration,
          initial: initialJson,
          onInject: onInject,
          onChange: onChange,
          onDispose: onDispose,
          onError: onError,
        )
    );
  }

  @override
  ComponentFieldBlocky instance() {
    return ComponentFieldBlocky();
  }
}