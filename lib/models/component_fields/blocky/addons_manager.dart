import 'dart:convert';

import 'package:flutter/services.dart';

/// Manage custom blocks for blockly
class AddonsManager {

  AddonsManager();

  /// Return the list of all the custom blocks.
  Future<List<String>> getBlocks() async {
      var assets = await rootBundle.loadString('AssetManifest.json');
      Map json = jsonDecode(assets);
      List<String> jsFiles = json.keys.where((element) => element.endsWith(".js")).toList() as List<String>;
      List<String> blocks = jsFiles.where((element) => element.startsWith("assets/blockly/blocks")).toList();
      List<String> blocksList = [];
      for (String block in blocks) {
        blocksList.add(await rootBundle.loadString(block));
      }
      return blocksList;
  }

  /// Return the list of all the custom extensions.
  Future<List<String>> getExtensions() async {
    var assets = await rootBundle.loadString('AssetManifest.json');
    Map json = jsonDecode(assets);
    List<String> jsFiles = json.keys.where((element) => element.endsWith(".js")).toList() as List<String>;
    List<String> extensions = jsFiles.where((element) => element.startsWith("assets/blockly/extensions")).toList();
    List<String> extensionsList = [];
    for (String extension in extensions) {
      extensionsList.add(await rootBundle.loadString(extension));
    }
    return extensionsList;
  }

  /// Return the list of all the plugins
  Future<List<String>> getPlugins() async {
    var assets = await rootBundle.loadString('AssetManifest.json');
    Map json = jsonDecode(assets);
    List<String> jsFiles = json.keys.where((element) => element.endsWith(".js")).toList() as List<String>;
    List<String> plugins = jsFiles.where((element) => element.startsWith("assets/blockly/plugins")).toList();
    List<String> pluginsList = [];
    for (String plugin in plugins) {
      pluginsList.add(await rootBundle.loadString(plugin));
    }
    return pluginsList;
  }

  /// Return the list of all the custom blocks, extensions and plugins.
  Future<List<String>> getAll() async {
    List<String> blocks = await getBlocks();
    List<String> extensions = await getExtensions();
    List<String> plugins = await getPlugins();
    List<String> all = [];
    all.addAll(blocks);
    all.addAll(extensions);
    all.addAll(plugins);
    return all;
  }

}