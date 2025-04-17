"use strict";
const type_csn = 'change_scene';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_csn,
        "message0": "go to scene %1",
        "args0": [
            {
                "type": "input_value",
                "name": "scene",
                "check": "String"
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "wait",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_csn] = function (block, generator) {
    const scene = javascript.javascriptGenerator.valueToCode(block, 'scene', javascript.Order.ATOMIC) || "";
    return `await sendMessage("changeScene", JSON.stringify([${scene}]));\n`;
};
dart.dartGenerator.forBlock[type_csn] = function (block, generator) {
    const scene = dart.dartGenerator.valueToCode(block, 'scene', dart.Order.ATOMIC) || 0;
    return `changeScene(${scene});\n`;
};
lua.luaGenerator.forBlock[type_csn] = function (block, generator) {
    const scene = lua.luaGenerator.valueToCode(block, 'scene', lua.Order.ATOMIC) || 0;
    return `changeScene(${scene})\n`;
};
php.phpGenerator.forBlock[type_csn] = function (block, generator) {
    const scene = php.phpGenerator.valueToCode(block, 'scene', php.Order.ATOMIC) || 0;
    return `changeScene(${scene});\n`;
};
python.pythonGenerator.forBlock[type_csn] = function (block, generator) {
    const scene = python.pythonGenerator.valueToCode(block, 'scene', python.Order.ATOMIC) || 0;
    return `changeScene(${scene})\n`;
};
