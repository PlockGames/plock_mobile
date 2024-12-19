"use strict";
const type_cg = 'component_get';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_cg,
        "message0": "get %1 from %2 of %3",
        "args0": [
            {
                "type": "input_dummy",
                "name": "value",
            },
            {
                "type": "field_dropdown",
                "name": "component",
                "options": [
                    [
                        "rect",
                        "ComponentRect"
                    ],
                    [
                        "circle",
                        "ComponentCircle"
                    ],
                    [
                        "text",
                        "ComponentText"
                    ],
                    [
                        "event",
                        "ComponentEvent"
                    ],
                    [
                        "variable",
                        "ComponentVariable"
                    ]
                ]
            },
            {
                "type": "input_value",
                "name": "object",
                "check": "Number",
                "extensions": "ext_component_getter"
            },
        ],
        "output": "Number",
        "colour": 230,
        "tooltip": "Get field of the rect component of an object",
        "inputsInline": true,
        "helpUrl": "",
        "extensions": ["ext_component_getter"]
    }
]);
javascript.javascriptGenerator.forBlock[type_cg] = function (block, generator) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    return [`sendMessage("getComponentValue", JSON.stringify([${object}, '${component}', '${value}']))`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_cg] = function (block, generator) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = dart.dartGenerator.valueToCode(block, 'object', dart.Order.ATOMIC) || 0;
    return [`getComponentValue(${object}, '${component}', '${value}')`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_cg] = function (block, generator) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = lua.luaGenerator.valueToCode(block, 'object', lua.Order.ATOMIC) || 0;
    return [`getComponentValue(${object}, '${component}', '${value}')`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_cg] = function (block, generator) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = php.phpGenerator.valueToCode(block, 'object', php.Order.ATOMIC) || 0;
    return [`getComponentValue(${object}, '${component}', '${value}')`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_cg] = function (block, generator) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = python.pythonGenerator.valueToCode(block, 'object', python.Order.ATOMIC) || 0;
    return [`getComponentValue(${object}, '${component}', '${value}')`, python.Order.ATOMIC];
};
