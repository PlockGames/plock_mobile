"use strict";
const type_sg = 'screen_get';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_sg,
        "message0": "screen %1",
        "args0": [
            {
                "type": "field_dropdown",
                "name": "value",
                "options": [
                    [
                        "width",
                        "WIDTH"
                    ],
                    [
                        "height",
                        "HEIGHT"
                    ]
                ]
            }
        ],
        "output": "Number",
        "colour": 230,
        "tooltip": "Get a property of the screen",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_sg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getScreenValue('${value}')`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_sg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getScreenValue('${value}')`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_sg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getScreenValue('${value}')`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_sg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getScreenValue('${value}')`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_sg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getScreenValue('${value}')`, python.Order.ATOMIC];
};
