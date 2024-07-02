import 'dart:convert';

import 'custom_block.dart';

/// Manage custom blocks for blockly
class CustomBlocksManager {

  /// The list of blocks.
  List<CustomBlock> blocks = [];

  CustomBlocksManager();

  /// Add a block to the manager.
  CustomBlocksManager addBlock(CustomBlock block) {
    blocks.add(block);
    return this;
  }

  /// Convert the blocks into a javascript injection.
  String toJs() {
    String js = "";
    for (var block in blocks) {
      js += "Blockly.defineBlocksWithJsonArray([";
      js += jsonEncode(block.toJson());
      js += "]);\n";
      js += "\n";
      js += "lua.luaGenerator.forBlock['${block.type}'] = function(block, generator) {\n";
      js += block.functionLua;
      js += "};";
      js += "\n";
      js += "dart.dartGenerator.forBlock['${block.type}'] = function(block, generator) {\n";
      js += block.functionDart;
      js += "};";
      js += "\n";
      js += "javascript.javascriptGenerator.forBlock['${block.type}'] = function(block, generator) {\n";
      js += block.functionJs;
      js += "};";
      js += "\n";
      js += "python.pythonGenerator.forBlock['${block.type}'] = function(block, generator) {\n";
      js += block.functionPython;
      js += "};";
      js += "\n";
      js += "php.phpGenerator.forBlock['${block.type}'] = function(block, generator) {\n";
      js += block.functionPhp;
      js += "};";
      js += "\n";
    }
    return js;
  }

}