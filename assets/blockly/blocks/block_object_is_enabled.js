"use strict";
const type_oie = 'object_is_enabled';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_oie,
        "message0": "is enabled object %1",
        "args0": [
            {
                "type": "input_value",
                "name": "object",
                "check": "Number"
            }
        ],
        "output": "Boolean",
        "colour": 230,
        "tooltip": "Set enabled of object",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_oie] = function (block, generator) {
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    return [`sendMessage("objectIsEnabled", JSON.stringify([${object}]))`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_oie] = function (block, generator) {
    const time = dart.dartGenerator.valueToCode(block, 'object', dart.Order.ATOMIC) || 0;
    return [`objectIsEnabled(${time})`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_oie] = function (block, generator) {
    const time = lua.luaGenerator.valueToCode(block, 'object', lua.Order.ATOMIC) || 0;
    return [`objectIsEnabled(${time})`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_oie] = function (block, generator) {
    const time = php.phpGenerator.valueToCode(block, 'object', php.Order.ATOMIC) || 0;
    return [`objectIsEnabled(${time})`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_oie] = function (block, generator) {
    const time = python.pythonGenerator.valueToCode(block, 'object', python.Order.ATOMIC) || 0;
    return [`objectIsEnabled(${time})`, python.Order.ATOMIC];
};
