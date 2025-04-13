"use strict";
const type_scg = 'sprite_change';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_scg,
        "message0": "change sprite of object %1 to %2",
        "args0": [
            {
                "type": "input_value",
                "name": "object",
                "check": "Number"
            },
            {
                "type": "input_value",
                "name": "name",
                "check": "String"
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "change sprite animation to name",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_scg] = function (block, generator) {
    const name = javascript.javascriptGenerator.valueToCode(block, 'name', javascript.Order.ATOMIC) || "";
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    return `sendMessage("changeSprite", JSON.stringify([${name}, ${object}]));\n`;
};
dart.dartGenerator.forBlock[type_scg] = function (block, generator) {
    const time = dart.dartGenerator.valueToCode(block, 'name', dart.Order.ATOMIC) || 0;
    return `wait(${time});\n`;
};
lua.luaGenerator.forBlock[type_scg] = function (block, generator) {
    const time = lua.luaGenerator.valueToCode(block, 'name', lua.Order.ATOMIC) || 0;
    return `wait(${time})\n`;
};
php.phpGenerator.forBlock[type_scg] = function (block, generator) {
    const time = php.phpGenerator.valueToCode(block, 'name', php.Order.ATOMIC) || 0;
    return `wait(${time});\n`;
};
python.pythonGenerator.forBlock[type_scg] = function (block, generator) {
    const time = python.pythonGenerator.valueToCode(block, 'name', python.Order.ATOMIC) || 0;
    return `wait(${time})\n`;
};
