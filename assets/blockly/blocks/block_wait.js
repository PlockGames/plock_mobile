"use strict";
const type_w = 'screen_wait';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_w,
        "message0": "wait %1",
        "args0": [
            {
                "type": "input_value",
                "name": "time",
                "check": "Number"
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "wait",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_w] = function (block, generator) {
    const time = javascript.javascriptGenerator.valueToCode(block, 'time', javascript.Order.ATOMIC) || 0;
    return `sendMessage("wait", JSON.stringify([${time}]));\n`;
};
dart.dartGenerator.forBlock[type_w] = function (block, generator) {
    const time = dart.dartGenerator.valueToCode(block, 'time', dart.Order.ATOMIC) || 0;
    return `wait(${time});\n`;
};
lua.luaGenerator.forBlock[type_w] = function (block, generator) {
    const time = lua.luaGenerator.valueToCode(block, 'time', lua.Order.ATOMIC) || 0;
    return `wait(${time})\n`;
};
php.phpGenerator.forBlock[type_w] = function (block, generator) {
    const time = php.phpGenerator.valueToCode(block, 'time', php.Order.ATOMIC) || 0;
    return `wait(${time});\n`;
};
python.pythonGenerator.forBlock[type_w] = function (block, generator) {
    const time = python.pythonGenerator.valueToCode(block, 'time', python.Order.ATOMIC) || 0;
    return `wait(${time})\n`;
};
