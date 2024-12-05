"use strict";
var colourRandom;
(function (colourRandom) {
    /**
     * @license
     * Copyright 2024 Google LLC
     * SPDX-License-Identifier: Apache-2.0
     */
    /** The name this block is registered under. */
    const BLOCK_NAME = 'colour_random';
    // Block for random colour.
    const jsonDefinition = {
        type: BLOCK_NAME,
        message0: '%{BKY_COLOUR_RANDOM_TITLE}',
        output: 'Colour',
        helpUrl: '%{BKY_COLOUR_RANDOM_HELPURL}',
        style: 'colour_blocks',
        tooltip: '%{BKY_COLOUR_RANDOM_TOOLTIP}',
    };
    /**
     * Javascript block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The JavascriptGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toJavascript(block, generator) {
        // Generate a random colour.
        const functionName = generator.provideFunction_('colourRandom', `
function ${generator.FUNCTION_NAME_PLACEHOLDER_}() {
  var num = Math.floor(Math.random() * 0x1000000);
  return '#' + ('00000' + num.toString(16)).substr(-6);
}
`);
        const code = functionName + '()';
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
        // Generate a random colour.
        // TODO(#7600): find better approach than casting to any to override
        // CodeGenerator declaring .definitions protected.
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        generator.definitions_['import_dart_math'] =
            "import 'dart:math' as Math;";
        const functionName = generator.provideFunction_('colour_random', `
String ${generator.FUNCTION_NAME_PLACEHOLDER_}() {
  String hex = '0123456789abcdef';
  var rnd = new Math.Random();
  return '#\${hex[rnd.nextInt(16)]}\${hex[rnd.nextInt(16)]}'
      '\${hex[rnd.nextInt(16)]}\${hex[rnd.nextInt(16)]}'
      '\${hex[rnd.nextInt(16)]}\${hex[rnd.nextInt(16)]}';
}
`);
        const code = functionName + '()';
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
        // Generate a random colour.
        const code = 'string.format("#%06x", math.random(0, 2^24 - 1))';
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
        // Generate a random colour.
        const functionName = generator.provideFunction_('colour_random', `
function ${generator.FUNCTION_NAME_PLACEHOLDER_}() {
  return '#' . str_pad(dechex(mt_rand(0, 0xFFFFFF)), 6, '0', STR_PAD_LEFT);
}
`);
        const code = functionName + '()';
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
        // Generate a random colour.
        // TODO(#7600): find better approach than casting to any to override
        // CodeGenerator declaring .definitions protected.
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        generator.definitions_['import_random'] = 'import random';
        const code = "'#%06x' % random.randint(0, 2**24 - 1)";
        return [code, python.Order.FUNCTION_CALL];
    }
    Blockly.defineBlocksWithJsonArray([
        jsonDefinition,
    ]);
    /**
     * Install the `colour_picker` block and all of its dependencies.
     *
     * @param gens The CodeGenerators to install per-block
     *     generators on.
     */
    function installBlock() {
        javascript.javascriptGenerator.forBlock[BLOCK_NAME] = toJavascript;
        dart.dartGenerator.forBlock[BLOCK_NAME] = toDart;
        lua.luaGenerator.forBlock[BLOCK_NAME] = toLua;
        php.phpGenerator.forBlock[BLOCK_NAME] = toPhp;
        python.pythonGenerator.forBlock[BLOCK_NAME] = toPython;
    }
    installBlock();
})(colourRandom || (colourRandom = {}));
