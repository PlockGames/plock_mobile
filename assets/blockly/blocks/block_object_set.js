"use strict";
const type_oset = 'object_set';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_oset,
        "message0": "set %1 of object  %2 to %3",
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
                "name": "object",
                "check": "Number"
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
        "tooltip": "Set a property of the object",
        "inputsInline": true,
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_oset] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    const new_value = javascript.javascriptGenerator.valueToCode(block, 'new_value', javascript.Order.ATOMIC) || 0;
    return `setObjectValue(${object}, '${value}', ${new_value});\n`;
};
dart.dartGenerator.forBlock[type_oset] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = dart.dartGenerator.valueToCode(block, 'object', dart.Order.ATOMIC) || 0;
    const new_value = dart.dartGenerator.valueToCode(block, 'new_value', dart.Order.ATOMIC) || 0;
    return `setObjectValue(${object}, '${value}', ${new_value});\n`;
};
lua.luaGenerator.forBlock[type_oset] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = lua.luaGenerator.valueToCode(block, 'object', lua.Order.ATOMIC) || 0;
    const new_value = lua.luaGenerator.valueToCode(block, 'new_value', lua.Order.ATOMIC) || 0;
    return `setObjectValue(${object}, '${value}', ${new_value})\n`;
};
php.phpGenerator.forBlock[type_oset] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = php.phpGenerator.valueToCode(block, 'object', php.Order.ATOMIC) || 0;
    const new_value = php.phpGenerator.valueToCode(block, 'new_value', php.Order.ATOMIC) || 0;
    return `setObjectValue(${object}, '${value}', ${new_value});\n`;
};
python.pythonGenerator.forBlock[type_oset] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = python.pythonGenerator.valueToCode(block, 'object', python.Order.ATOMIC) || 0;
    const new_value = python.pythonGenerator.valueToCode(block, 'new_value', python.Order.ATOMIC) || 0;
    return `setObjectValue(${object}, '${value}', ${new_value})\n`;
};
