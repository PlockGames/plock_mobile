"use strict";
const type_od = 'object_destroy';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_od,
        "message0": "Destroy object %1",
        "args0": [
            {
                "type": "input_value",
                "name": "object",
                "check": "Number"
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "Spawn an object",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_od] = function (block, generator) {
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    return `destroyObject(${object});\n`;
};
dart.dartGenerator.forBlock[type_od] = function (block, generator) {
    const object = dart.dartGenerator.valueToCode(block, 'object', dart.Order.ATOMIC) || 0;
    return `destroyObject(${object});\n`;
};
lua.luaGenerator.forBlock[type_od] = function (block, generator) {
    const object = lua.luaGenerator.valueToCode(block, 'object', lua.Order.ATOMIC) || 0;
    return `destroyObject(${object})\n`;
};
php.phpGenerator.forBlock[type_od] = function (block, generator) {
    const object = php.phpGenerator.valueToCode(block, 'object', php.Order.ATOMIC) || 0;
    return `destroyObject(${object});\n`;
};
python.pythonGenerator.forBlock[type_od] = function (block, generator) {
    const object = python.pythonGenerator.valueToCode(block, 'object', python.Order.ATOMIC) || 0;
    return `destroyObject(${object})\n`;
};
