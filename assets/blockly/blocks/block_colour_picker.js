"use strict";
var colour_picker;
(function (colour_picker) {
    /**
     * @license
     * Copyright 2024 Google LLC
     * SPDX-License-Identifier: Apache-2.0
     */
    /** The name this block is registered under. */
    const BLOCK_NAME = 'colour_picker';
    // Block for colour picker.
    const jsonDefinition = {
        type: BLOCK_NAME,
        message0: '%1',
        args0: [
            {
                type: 'field_colour',
                name: 'COLOUR',
                colour: '#ff0000',
            },
        ],
        output: 'Colour',
        helpUrl: '%{BKY_COLOUR_PICKER_HELPURL}',
        style: 'colour_blocks',
        tooltip: '%{BKY_COLOUR_PICKER_TOOLTIP}',
        extensions: ['parent_tooltip_when_inline'],
    };
    /**
     * Javascript block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The JavascriptGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toJavascript(block, generator) {
        // Colour picker.
        const code = generator.quote_(block.getFieldValue('COLOUR'));
        return [code, javascript.Order.ATOMIC];
    }
    /**
     * Dart block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The DartGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toDart(block, generator) {
        // Colour picker.
        const code = generator.quote_(block.getFieldValue('COLOUR'));
        return [code, dart.Order.ATOMIC];
    }
    /**
     * Lua block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The LuaGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toLua(block, generator) {
        // Colour picker.
        const code = generator.quote_(block.getFieldValue('COLOUR'));
        return [code, lua.Order.ATOMIC];
    }
    /**
     * PHP block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The PhpGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toPhp(block, generator) {
        // Colour picker.
        const code = generator.quote_(block.getFieldValue('COLOUR'));
        return [code, php.Order.ATOMIC];
    }
    /**
     * Python block generator function.
     *
     * @param block The Block instance to generate code for.
     * @param generator The PythonGenerator calling the function.
     * @returns A tuple containing the code string and precedence.
     */
    function toPython(block, generator) {
        // Colour picker.
        const code = generator.quote_(block.getFieldValue('COLOUR'));
        return [code, python.Order.ATOMIC];
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
})(colour_picker || (colour_picker = {}));
