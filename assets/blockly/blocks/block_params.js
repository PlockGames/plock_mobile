"use strict";
const type_pam = 'system_params';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_pam,
        "message0": "get params %1",
        "args0": [
            {
                "type": "input_dummy"
            },
        ],
        "output": "Array",
        "colour": 230,
        "tooltip": "get params",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_pam] = function (block, generator) {
    return [`params`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_pam] = function (block, generator) {
    return [`params`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_pam] = function (block, generator) {
    return [`params`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_pam] = function (block, generator) {
    return [`params`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_pam] = function (block, generator) {
    return [`params`, python.Order.ATOMIC];
};
