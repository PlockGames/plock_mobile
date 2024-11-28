"use strict";
const type_oeset = 'object_event_set';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_oeset,
        "message0": "set event %1 of object  %2 to %3",
        "args0": [
            {
                "type": "input_value",
                "name": "name",
                "check": "String"
            },
            {
                "type": "input_value",
                "name": "object",
                "check": "Number"
            },
            {
                "type": "input_statement",
                "name": "newValue",
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "Set an event of the object",
        "inputsInline": true,
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_oeset] = function (block, generator) {
    const name = javascript.javascriptGenerator.valueToCode(block, 'name', javascript.Order.ATOMIC) || "";
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    const newValue = javascript.javascriptGenerator.valueToCode(block, 'newValue', javascript.Order.ATOMIC) || 0;
    return `setComponentValue(${object}, 'ComponentEvent', 'EVENT', toString(${newValue}))\n`;
};
dart.dartGenerator.forBlock[type_oeset] = function (block, generator) {
    const name = dart.dartGenerator.valueToCode(block, 'name', dart.Order.ATOMIC) || "";
    const object = dart.dartGenerator.valueToCode(block, 'object', dart.Order.ATOMIC) || 0;
    const newValue = dart.dartGenerator.valueToCode(block, 'newValue', dart.Order.ATOMIC) || 0;
    return `setComponentValue(${object}, 'ComponentEvent', 'EVENT', toString(${newValue}))\n`;
};
lua.luaGenerator.forBlock[type_oeset] = function (block, generator) {
    const name = lua.luaGenerator.valueToCode(block, 'name', lua.Order.ATOMIC) || "";
    const object = lua.luaGenerator.valueToCode(block, 'object', lua.Order.ATOMIC) || 0;
    const newValue = lua.luaGenerator.valueToCode(block, 'newValue', lua.Order.ATOMIC) || 0;
    return `setComponentValue(${object}, 'ComponentEvent', 'EVENT', tostring(${newValue}))\n`;
};
php.phpGenerator.forBlock[type_oeset] = function (block, generator) {
    const name = php.phpGenerator.valueToCode(block, 'name', php.Order.ATOMIC) || "";
    const object = php.phpGenerator.valueToCode(block, 'object', php.Order.ATOMIC) || 0;
    const newValue = php.phpGenerator.valueToCode(block, 'newValue', php.Order.ATOMIC) || 0;
    return `setComponentValue(${object}, 'ComponentEvent', 'EVENT', ${newValue})\n`;
};
python.pythonGenerator.forBlock[type_oeset] = function (block, generator) {
    const name = python.pythonGenerator.valueToCode(block, 'name', python.Order.ATOMIC) || "";
    const object = python.pythonGenerator.valueToCode(block, 'object', python.Order.ATOMIC) || 0;
    const newValue = python.pythonGenerator.valueToCode(block, 'newValue', python.Order.ATOMIC) || 0;
    return `setComponentValue(${object}, 'ComponentEvent', 'EVENT', ${newValue})\n`;
};
