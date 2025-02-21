"use strict";
const type_cn = 'collider_name';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_cn,
        "message0": "get collider name %1",
        "args0": [
            {
                "type": "input_dummy"
            },
        ],
        "output": "String",
        "colour": 230,
        "tooltip": "get collider name",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_cn] = function (block, generator) {
    return [`colliderName`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_cn] = function (block, generator) {
    return [`colliderName`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_cn] = function (block, generator) {
    return [`colliderName`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_cn] = function (block, generator) {
    return [`colliderName`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_cn] = function (block, generator) {
    return [`colliderName`, python.Order.ATOMIC];
};
