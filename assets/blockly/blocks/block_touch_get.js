"use strict";
const type_tg = 'touch_get';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_tg,
        "message0": "%1 of touch  %2",
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
                "type": "input_dummy",
            }
        ],
        "output": "Number",
        "colour": 230,
        "tooltip": "Get the position of the touch",
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_tg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`sendMessage("getTouch", JSON.stringify(['${value}']))`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_tg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getTouch('${value}')`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_tg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getTouch('${value}')`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_tg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getTouch('${value}')`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_tg] = function (block, generator) {
    const value = block.getFieldValue('value');
    return [`getTouch('${value}')`, python.Order.ATOMIC];
};
