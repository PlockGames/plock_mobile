"use strict";
const type_og = 'object_get';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_og,
        "message0": "%1 of object  %2",
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
            }
        ],
        "output": "Number",
        "colour": 230,
        "tooltip": "Get a property of the object",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_og] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    return [`getObjectValue(${object}, '${value}')`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_og] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = dart.dartGenerator.valueToCode(block, 'object', dart.Order.ATOMIC) || 0;
    return [`getObjectValue(${object}, '${value}')`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_og] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = lua.luaGenerator.valueToCode(block, 'object', lua.Order.ATOMIC) || 0;
    return [`getObjectValue(${object}, '${value}')`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_og] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = php.phpGenerator.valueToCode(block, 'object', php.Order.ATOMIC) || 0;
    return [`getObjectValue(${object}, '${value}')`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_og] = function (block, generator) {
    const value = block.getFieldValue('value');
    const object = python.pythonGenerator.valueToCode(block, 'object', python.Order.ATOMIC) || 0;
    return `getObjectValue(${object}, '${value}')`;
};
