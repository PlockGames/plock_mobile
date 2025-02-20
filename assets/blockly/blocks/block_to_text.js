"use strict";
const type_tt = 'to_text';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_tt,
        "message0": "%1 to text %2",
        "args0": [
            {
                "type": "input_value",
                "name": "number",
                "check": "Number"
            },
            {
                "type": "input_dummy",
            }
        ],
        "output": "String",
        "colour": 230,
        "tooltip": "Convert a number to a text",
        "helpUrl": "",
    }
]);
javascript.javascriptGenerator.forBlock[type_tt] = function (block, generator) {
    const number = javascript.javascriptGenerator.valueToCode(block, 'number', javascript.Order.ATOMIC) || "'0'";
    return ["String(" + number + ")", javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_tt] = function (block, generator) {
    const number = dart.dartGenerator.valueToCode(block, 'number', dart.Order.ATOMIC) || "'0'";
    return ["number.toString()", dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_tt] = function (block, generator) {
    const number = lua.luaGenerator.valueToCode(block, 'number', lua.Order.ATOMIC) || "'0'";
    return ["tostring(" + number + ")", lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_tt] = function (block, generator) {
    const number = php.phpGenerator.valueToCode(block, 'number', php.Order.ATOMIC) || "'0'";
    return ["strval(" + number + ")", php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_tt] = function (block, generator) {
    const number = python.pythonGenerator.valueToCode(block, 'number', python.Order.ATOMIC) || "'0'";
    return ["str(" + number + ")", python.Order.ATOMIC];
};
