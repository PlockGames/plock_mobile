import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/initial_toolbox.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:flutter_blockly/flutter_blockly.dart' as Blocky;

import 'blocky/data/custom_blocks_list.dart';
import 'blocky/data/pl_blockly_editor_widget.dart';

/// A field that contain a Blockly (lua code) value.
class ComponentFieldBlockly extends ComponentField {

  /// The initial state of blockly.
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

  /// The value of the field.
  String _value_lua = "";

  /// The saved json of the blockly.
  Map<String, dynamic> _value = initialJson;

  ComponentFieldBlockly({value}) {
    if (value != null) {
      _value = value;
    } else {
      _value = initialJson;
    }
  }

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

    Blocky.BlocklyOptions workspaceConfiguration = Blocky.BlocklyOptions(
      theme: blockyTheme,
      css: true,
      move: const Blocky.MoveOptions(
        drag: true,
        wheel: true,
        scrollbars: Blocky.ScrollbarOptions(
          horizontal: true,
          vertical: true,
        )
      ),
      toolbox: Blocky.ToolboxInfo.fromJson(initialToolbox.toJson()),
      horizontalLayout: true,
      collapse: false,
      trashcan: false,
    );

    void onInject(Blocky.BlocklyData data) {
      //debugPrint('onInject: ${data.xml}\n${jsonEncode(data.json)}');
    }

    void onChange(Blocky.BlocklyData data) {
      //debugPrint('onChange: ${data.lua}');
      if (data.json == null) {
        _value = initialJson;
      } else {
        _value = data.json!;
        _value_lua = data.lua;
      }
    }

    void onDispose(Blocky.BlocklyData data) {
      //debugPrint('onDispose: ${data.xml}\n${jsonEncode(data.json)}');
    }

    void onError(dynamic err) {
      debugPrint('onError: $err');
    }


    return Expanded(
        child: PlBlocklyEditorWidget(
          workspaceConfiguration: workspaceConfiguration,
          initial: _value,
          onInject: onInject,
          onChange: onChange,
          onDispose: onDispose,
          onError: onError,
          blocks: customBlocksManager.toJs(),
        )
    );
  }

  @override
  ComponentFieldBlockly instance() {
    return ComponentFieldBlockly(value: _value);
  }

  @override
  String get value => _value_lua;

  @override
  set value(dynamic value) {
    _value_lua = value;
  }

  @override
  String toJson() {
    return "\"$_value_lua\"";
  }

  @override
  void updateFromJson(dynamic jsonVal) {
    _value_lua = jsonVal as String;
  }
}