import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blockly_plus/flutter_blockly_plus.dart';
import 'package:plock_mobile/models/component_fields/blocky/addons_manager.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:flutter_blockly_plus/flutter_blockly_plus.dart' as Blocky;

import '../../data/initial_toolbox.dart';

/// A field that contain a Blockly (lua code) value.
class ComponentFieldBlockly extends ComponentField {

  /// The initial state of blockly.
  static const Map<String, dynamic> initialJson = {
    'blocks': {
      'languageVersion': 0,
      'blocks': [
      ],
    },
  };

  /// The value of the field.
  String _value_lua = "";

  /// The saved json of the blockly.
  Map<String, dynamic> _value = initialJson;

  Map<String, dynamic> debugData_ = {};



  ComponentFieldBlockly({value, value_lua}) {
    if (value != null) {
      _value = value;
    } else {
      _value = initialJson;
    }

    if (value_lua != null) {
      _value_lua = value_lua;
    } else {
      _value_lua = "";
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
    }

    void onChange(Blocky.BlocklyData data) {
      debugData_ = data.toolbox!;
      print("debug: " + debugData_.toString());
      //debugPrint('onChange: ${data.lua}');
      if (data.json == null) {
        _value = initialJson;
      } else {
        _value = data.json!;
        _value_lua = data.lua!;
        //print(data.lua);
      }
    }

    void onDispose(Blocky.BlocklyData data) {
      //debugPrint('onDispose: ${data.xml}\n${jsonEncode(data.json)}');
    }

    void onError(dynamic err) {
      debugPrint('onError: $err');
    }

    Future<List<String>> getAddons() async {
      var cbm = AddonsManager();
      var addons = await cbm.getAll();
      return addons;
    }

    final addons = getAddons();

    return FutureBuilder(future: addons, builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Expanded(child:
          BlocklyEditorWidget(
          workspaceConfiguration: workspaceConfiguration,
          initial: _value,
          onInject: onInject,
          onChange: onChange,
          onDispose: onDispose,
          onError: onError,
          addons: snapshot.data,
        )
        );
      } else {
        return CircularProgressIndicator();
      }
    });
  }

  @override
  ComponentFieldBlockly instance() {
    return ComponentFieldBlockly(value: _value, value_lua: _value_lua);
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

  @override
  Map<String, dynamic> get debugData => debugData_;
}