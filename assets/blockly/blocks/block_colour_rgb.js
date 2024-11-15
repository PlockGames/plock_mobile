"use strict";
var colourRgb;
(function (colourRgb) {
    /**
     * @license
     * Copyright 2024 Google LLC
     * SPDX-License-Identifier: Apache-2.0
     */
    /** The name this block is registered under. */
    const BLOCK_NAME = 'colour_rgb';
    // Block for composing a colour from RGB components.
    const jsonDefinition = {
        type: BLOCK_NAME,
        message0: '%{BKY_COLOUR_RGB_TITLE} %{BKY_COLOUR_RGB_RED} %1 %{BKY_COLOUR_RGB_GREEN} %2 %{BKY_COLOUR_RGB_BLUE} %3',
        args0: [
            {
                type: 'input_value',
                name: 'RED',
                check: 'Number',
                align: 'RIGHT',
            },
            {
                type: 'input_value',
                name: 'GREEN',
                check: 'Number',
                align: 'RIGHT',
            },
            {
                type: 'input_value',
                name: 'BLUE',
                check: 'Number',
                align: 'RIGHT',
            },
        ],
        output: 'Colour',
        helpUrl: '%{BKY_COLOUR_RGB_HELPURL}',
        style: 'colour_blocks',
        tooltip: '%{BKY_COLOUR_RGB_TOOLTIP}',
    };
    /**
     * Javascript block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The JavascriptGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toJavascript(block, generator) {
        // Compose a colour from RGB components expressed as percentages.
        const red = generator.valueToCode(block, 'RED', javascript.Order.NONE) || 0;
        const green = generator.valueToCode(block, 'GREEN', javascript.Order.NONE) || 0;
        const blue = generator.valueToCode(block, 'BLUE', javascript.Order.NONE) || 0;
        const functionName = generator.provideFunction_('colourRgb', `
function ${generator.FUNCTION_NAME_PLACEHOLDER_}(r, g, b) {
  r = Math.max(Math.min(Number(r), 100), 0) * 2.55;
  g = Math.max(Math.min(Number(g), 100), 0) * 2.55;
  b = Math.max(Math.min(Number(b), 100), 0) * 2.55;
  r = ('0' + (Math.round(r) || 0).toString(16)).slice(-2);
  g = ('0' + (Math.round(g) || 0).toString(16)).slice(-2);
  b = ('0' + (Math.round(b) || 0).toString(16)).slice(-2);
  return '#' + r + g + b;
}
`);
        const code = `${functionName}(${red}, ${green}, ${blue})`;
        return [code, javascript.Order.FUNCTION_CALL];
    }
    /**
     * Dart block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The DartGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toDart(block, generator) {
        // Compose a colour from RGB components expressed as percentages.
        const red = generator.valueToCode(block, 'RED', dart.Order.NONE) || 0;
        const green = generator.valueToCode(block, 'GREEN', dart.Order.NONE) || 0;
        const blue = generator.valueToCode(block, 'BLUE', dart.Order.NONE) || 0;
        // TODO(#7600): find better approach than casting to any to override
        // CodeGenerator declaring .definitions protected.
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        generator.definitions_['import_dart_math'] =
            "import 'dart:math' as Math;";
        const functionName = generator.provideFunction_('colour_rgb', `
String ${generator.FUNCTION_NAME_PLACEHOLDER_}(num r, num g, num b) {
  num rn = (Math.max(Math.min(r, 100), 0) * 2.55).round();
  String rs = rn.toInt().toRadixString(16);
  rs = '0$rs';
  rs = rs.substring(rs.length - 2);
  num gn = (Math.max(Math.min(g, 100), 0) * 2.55).round();
  String gs = gn.toInt().toRadixString(16);
  gs = '0$gs';
  gs = gs.substring(gs.length - 2);
  num bn = (Math.max(Math.min(b, 100), 0) * 2.55).round();
  String bs = bn.toInt().toRadixString(16);
  bs = '0$bs';
  bs = bs.substring(bs.length - 2);
  return '#$rs$gs$bs';
}
`);
        const code = `${functionName}(${red}, ${green}, ${blue})`;
        return [code, dart.Order.UNARY_POSTFIX];
    }
    /**
     * Lua block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The LuaGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toLua(block, generator) {
        // Compose a colour from RGB components expressed as percentages.
        const functionName = generator.provideFunction_('colour_rgb', `
function ${generator.FUNCTION_NAME_PLACEHOLDER_}(r, g, b)
  r = math.floor(math.min(100, math.max(0, r)) * 2.55 + .5)
  g = math.floor(math.min(100, math.max(0, g)) * 2.55 + .5)
  b = math.floor(math.min(100, math.max(0, b)) * 2.55 + .5)
  return string.format("#%02x%02x%02x", r, g, b)
end
`);
        const red = generator.valueToCode(block, 'RED', lua.Order.NONE) || 0;
        const green = generator.valueToCode(block, 'GREEN', lua.Order.NONE) || 0;
        const blue = generator.valueToCode(block, 'BLUE', lua.Order.NONE) || 0;
        const code = `${functionName}(${red}, ${green}, ${blue})`;
        return [code, lua.Order.HIGH];
    }
    /**
     * PHP block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The PhpGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toPhp(block, generator) {
        // Compose a colour from RGB components expressed as percentages.
        const red = generator.valueToCode(block, 'RED', php.Order.NONE) || 0;
        const green = generator.valueToCode(block, 'GREEN', php.Order.NONE) || 0;
        const blue = generator.valueToCode(block, 'BLUE', php.Order.NONE) || 0;
        const functionName = generator.provideFunction_('colour_rgb', `
function ${generator.FUNCTION_NAME_PLACEHOLDER_}($r, $g, $b) {
  $r = round(max(min($r, 100), 0) * 2.55);
  $g = round(max(min($g, 100), 0) * 2.55);
  $b = round(max(min($b, 100), 0) * 2.55);
  $hex = '#';
  $hex .= str_pad(dechex($r), 2, '0', STR_PAD_LEFT);
  $hex .= str_pad(dechex($g), 2, '0', STR_PAD_LEFT);
  $hex .= str_pad(dechex($b), 2, '0', STR_PAD_LEFT);
  return $hex;
}
`);
        const code = `${functionName}(${red}, ${green}, ${blue})`;
        return [code, php.Order.FUNCTION_CALL];
    }
    /**
     * Python block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The PythonGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toPython(block, generator) {
        // Compose a colour from RGB components expressed as percentages.
        const functionName = generator.provideFunction_('colour_rgb', `
def ${generator.FUNCTION_NAME_PLACEHOLDER_}(r, g, b):
  r = round(min(100, max(0, r)) * 2.55)
  g = round(min(100, max(0, g)) * 2.55)
  b = round(min(100, max(0, b)) * 2.55)
  return '#%02x%02x%02x' % (r, g, b)
`);
        const r = generator.valueToCode(block, 'RED', python.Order.NONE) || 0;
        const g = generator.valueToCode(block, 'GREEN', python.Order.NONE) || 0;
        const b = generator.valueToCode(block, 'BLUE', python.Order.NONE) || 0;
        const code = functionName + '(' + r + ', ' + g + ', ' + b + ')';
        return [code, python.Order.FUNCTION_CALL];
    }
    Blockly.defineBlocksWithJsonArray([
        jsonDefinition,
    ]);
    /**
     * Install the `colour_rgb` block and all of its dependencies.
     *
     * @param gens The CodeGenerators to install per-block
     *     generators on.
     */
    function installBlock() {
        javascript.javascriptGenerator.forBlock[BLOCK_NAME] = toJavascript;
        dart.dartGenerator.forBlock[BLOCK_NAME] = toDart;
        dart.dartGenerator.addReservedWords('Math');
        lua.luaGenerator.forBlock[BLOCK_NAME] = toLua;
        php.phpGenerator.forBlock[BLOCK_NAME] = toPhp;
        python.pythonGenerator.forBlock[BLOCK_NAME] = toPython;
    }
    installBlock();
})(colourRgb || (colourRgb = {}));
