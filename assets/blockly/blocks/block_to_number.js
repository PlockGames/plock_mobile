"use strict";
const type_tn = 'to_number';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_tn,
        "message0": "%1 to number %2",
        "args0": [
            {
                "type": "input_value",
                "name": "text",
                "check": "String"
            },
            {
                "type": "input_dummy",
            }
        ],
        "output": "Number",
        "colour": 230,
        "tooltip": "Convert a text to a number",
        "helpUrl": "",
    }
]);
javascript.javascriptGenerator.forBlock[type_tn] = function (block, generator) {
    const text = javascript.javascriptGenerator.valueToCode(block, 'text', javascript.Order.ATOMIC) || "'0'";
    return ["Number(" + text + ")", javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_tn] = function (block, generator) {
    const text = dart.dartGenerator.valueToCode(block, 'text', dart.Order.ATOMIC) || "'0'";
    return ["double.parse(" + text + ")", dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_tn] = function (block, generator) {
    const text = lua.luaGenerator.valueToCode(block, 'text', lua.Order.ATOMIC) || "'0'";
    return ["tonumber(" + text + ")", lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_tn] = function (block, generator) {
    const text = php.phpGenerator.valueToCode(block, 'text', php.Order.ATOMIC) || "'0'";
    return ["intval(" + text + ")", php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_tn] = function (block, generator) {
    const text = python.pythonGenerator.valueToCode(block, 'text', python.Order.ATOMIC) || "'0'";
    return ["int(" + text + ")", python.Order.ATOMIC];
};
