"use strict";
const type_clg = 'component_list_get';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_clg,
        "message0": "get values from list named %1 of %2",
        "args0": [
            {
                "type": "input_value",
                "name": "name",
                "check": "String",
            },
            {
                "type": "input_value",
                "name": "object",
                "check": "Number",
            },
        ],
        "output": "Array",
        "colour": 230,
        "tooltip": "Get values from list component of an object",
        "inputsInline": true,
        "helpUrl": "",
    }
]);
javascript.javascriptGenerator.forBlock[type_clg] = function (block, generator) {
    const name = javascript.javascriptGenerator.valueToCode(block, 'name', javascript.Order.ATOMIC) || "''";
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    return [`sendMessage("getListValue", JSON.stringify([${object}, ${name}]))`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_clg] = function (block, generator) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = dart.dartGenerator.valueToCode(block, 'object', dart.Order.ATOMIC) || 0;
    return [`getListValue(${object}, '${component}', '${value}')`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_clg] = function (block, generator) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = lua.luaGenerator.valueToCode(block, 'object', lua.Order.ATOMIC) || 0;
    return [`getListValue(${object}, '${component}', '${value}')`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_clg] = function (block, generator) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = php.phpGenerator.valueToCode(block, 'object', php.Order.ATOMIC) || 0;
    return [`getListValue(${object}, '${component}', '${value}')`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_clg] = function (block, generator) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = python.pythonGenerator.valueToCode(block, 'object', python.Order.ATOMIC) || 0;
    return [`getListValue(${object}, '${component}', '${value}')`, python.Order.ATOMIC];
};
