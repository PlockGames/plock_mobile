"use strict";
const type_cas = 'camera_set';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_cas,
        "message0": "set %1 of camera to %2",
        "args0": [
            {
                "type": "field_dropdown",
                "name": "value",
                "options": [
                    [
                        "x",
                        "X"
                    ],
                    [
                        "y",
                        "Y"
                    ]
                ]
            },
            {
                "type": "input_value",
                "name": "new_value",
                "check": "Number"
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "Set a property of the camera",
        "inputsInline": true,
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_cas] = function (block, generator) {
    const value = block.getFieldValue('value');
    const new_value = javascript.javascriptGenerator.valueToCode(block, 'new_value', javascript.Order.ATOMIC) || 0;
    return `sendMessage("setCameraValue", JSON.stringify(['${value}', ${new_value}]));\n`;
};
dart.dartGenerator.forBlock[type_cas] = function (block, generator) {
    const value = block.getFieldValue('value');
    const new_value = dart.dartGenerator.valueToCode(block, 'new_value', dart.Order.ATOMIC) || 0;
    return `setCameraValue('${value}', ${new_value});\n`;
};
lua.luaGenerator.forBlock[type_cas] = function (block, generator) {
    const value = block.getFieldValue('value');
    const new_value = lua.luaGenerator.valueToCode(block, 'new_value', lua.Order.ATOMIC) || 0;
    return `setCameraValue('${value}', ${new_value})\n`;
};
php.phpGenerator.forBlock[type_cas] = function (block, generator) {
    const value = block.getFieldValue('value');
    const new_value = php.phpGenerator.valueToCode(block, 'new_value', php.Order.ATOMIC) || 0;
    return `setCameraValue('${value}', ${new_value});\n`;
};
python.pythonGenerator.forBlock[type_cas] = function (block, generator) {
    const value = block.getFieldValue('value');
    const new_value = python.pythonGenerator.valueToCode(block, 'new_value', python.Order.ATOMIC) || 0;
    return `setCameraValue('${value}', ${new_value})\n`;
};
