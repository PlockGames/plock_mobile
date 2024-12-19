"use strict";
const type_dt = 'delta_time';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_dt,
        "message0": "deltatime %1",
        "args0": [
            {
                "type": "input_dummy",
            }
        ],
        "output": "Number",
        "colour": 230,
        "tooltip": "get delta time",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_dt] = function (block, generator) {
    return [`sendMessage("deltaTime", JSON.stringify([]))`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_dt] = function (block, generator) {
    return [`deltaTime()`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_dt] = function (block, generator) {
    return [`deltaTime()`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_dt] = function (block, generator) {
    return [`deltaTime()`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_dt] = function (block, generator) {
    return [`deltaTime()`, python.Order.ATOMIC];
};
