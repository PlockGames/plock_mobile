"use strict";
const type_cag = 'camera_get';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_cag,
        "message0": "%1 of camera %2",
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
                "type": "input_dummy"
            }
        ],
        "output": "Number",
        "colour": 230,
        "tooltip": "Get a property of the camera",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_cag] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`sendMessage("getCameraValue", JSON.stringify(['${value}']))`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_cag] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getCameraValue('${value}')`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_cag] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getCameraValue('${value}')`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_cag] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getCameraValue('${value}')`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_cag] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getCameraValue('${value}')`, python.Order.ATOMIC];
};
