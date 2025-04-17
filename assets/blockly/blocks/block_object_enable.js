"use strict";
const type_oe = 'object_enable';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_oe,
        "message0": "enable object %1 to %2",
        "args0": [
            {
                "type": "input_value",
                "name": "object",
                "check": "Number"
            },
            {
                "type": "input_value",
                "name": "enabled",
                "check": "Boolean"
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "Set enabled of object",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_oe] = function (block, generator) {
    const enabled = javascript.javascriptGenerator.valueToCode(block, 'enabled', javascript.Order.ATOMIC) || true;
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    return `sendMessage("objectEnable", JSON.stringify([${enabled}, ${object}]));\n`;
};
dart.dartGenerator.forBlock[type_oe] = function (block, generator) {
    const time = dart.dartGenerator.valueToCode(block, 'enabled', dart.Order.ATOMIC) || 0;
    return `wait(${time});\n`;
};
lua.luaGenerator.forBlock[type_oe] = function (block, generator) {
    const time = lua.luaGenerator.valueToCode(block, 'enabled', lua.Order.ATOMIC) || 0;
    return `wait(${time})\n`;
};
php.phpGenerator.forBlock[type_oe] = function (block, generator) {
    const time = php.phpGenerator.valueToCode(block, 'enabled', php.Order.ATOMIC) || 0;
    return `wait(${time});\n`;
};
python.pythonGenerator.forBlock[type_oe] = function (block, generator) {
    const time = python.pythonGenerator.valueToCode(block, 'enabled', python.Order.ATOMIC) || 0;
    return `wait(${time})\n`;
};
