"use strict";
const type_oet = 'object_event_trigger';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_oet,
        "message0": "trigger event %1 of object  %2 with params %3",
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
                "type": "input_value",
                "name": "params",
                "check": "Array"
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "trigger event of object",
        "inputsInline": true,
        "helpUrl": ""
    }
]);
javascript.javascriptGenerator.forBlock[type_oet] = function (block, generator) {
    const name = javascript.javascriptGenerator.valueToCode(block, 'name', javascript.Order.ATOMIC) || "";
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    const params = javascript.javascriptGenerator.valueToCode(block, 'params', javascript.Order.ATOMIC) || [];
    return `sendMessage("triggerEvent", JSON.stringify([${object}, ${name}, ${params}]))\n`;
};
dart.dartGenerator.forBlock[type_oet] = function (block, generator) {
    const name = dart.dartGenerator.valueToCode(block, 'name', dart.Order.ATOMIC) || "";
    const object = dart.dartGenerator.valueToCode(block, 'object', dart.Order.ATOMIC) || 0;
    const params = dart.dartGenerator.valueToCode(block, 'params', dart.Order.ATOMIC) || 0;
    return `setComponentValue(${object}, 'ComponentVariable', 'VALUE', toString(${params}))\n`;
};
lua.luaGenerator.forBlock[type_oet] = function (block, generator) {
    const name = lua.luaGenerator.valueToCode(block, 'name', lua.Order.ATOMIC) || "";
    const object = lua.luaGenerator.valueToCode(block, 'object', lua.Order.ATOMIC) || 0;
    const params = lua.luaGenerator.valueToCode(block, 'params', lua.Order.ATOMIC) || 0;
    return `setComponentValue(${object}, 'ComponentVariable', 'VALUE', tostring(${params}))\n`;
};
php.phpGenerator.forBlock[type_oet] = function (block, generator) {
    const name = php.phpGenerator.valueToCode(block, 'name', php.Order.ATOMIC) || "";
    const object = php.phpGenerator.valueToCode(block, 'object', php.Order.ATOMIC) || 0;
    const params = php.phpGenerator.valueToCode(block, 'params', php.Order.ATOMIC) || 0;
    return `setComponentValue(${object}, 'ComponentVariable', 'VALUE', ${params})\n`;
};
python.pythonGenerator.forBlock[type_oet] = function (block, generator) {
    const name = python.pythonGenerator.valueToCode(block, 'name', python.Order.ATOMIC) || "";
    const object = python.pythonGenerator.valueToCode(block, 'object', python.Order.ATOMIC) || 0;
    const params = python.pythonGenerator.valueToCode(block, 'params', python.Order.ATOMIC) || 0;
    return `setComponentValue(${object}, 'ComponentVariable', 'VALUE', ${params})\n`;
};
