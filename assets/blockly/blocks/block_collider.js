"use strict";
const type_c = 'collider';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_c,
        "message0": "get collider %1",
        "args0": [
            {
                "type": "input_dummy"
            },
        ],
        "output": "String",
        "colour": 230,
        "tooltip": "get collider data",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_c] = function (block, generator) {
    return [`collider`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_c] = function (block, generator) {
    return [`collider`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_c] = function (block, generator) {
    return [`collider`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_c] = function (block, generator) {
    return [`collider`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_c] = function (block, generator) {
    return [`collider`, python.Order.ATOMIC];
};
