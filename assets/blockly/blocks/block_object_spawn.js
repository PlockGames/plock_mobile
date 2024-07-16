"use strict";
const type_os = 'object_spawn';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_os,
        "message0": "Spawn object %1",
        "args0": [
            {
                "type": "input_value",
                "name": "name",
                "check": "String"
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "Spawn an object",
        "helpUrl": "",
    }
]);
javascript.javascriptGenerator.forBlock[type_os] = function (block, generator) {
    const value_name = javascript.javascriptGenerator.valueToCode(block, 'name', javascript.Order.ATOMIC) || "'my_object'";
    const input = block.getInputTargetBlock('name');
    if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
        return "spawnObject(toString(" + value_name + "));\n";
    }
    return "spawnObject(" + value_name + ");\n";
};
dart.dartGenerator.forBlock[type_os] = function (block, generator) {
    const value_name = dart.dartGenerator.valueToCode(block, 'name', dart.Order.ATOMIC) || "'my_object'";
    const input = block.getInputTargetBlock('name');
    if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
        return "spawnObject((" + value_name + ").toString());\n";
    }
    return "spawnObject(" + value_name + ");\n";
};
lua.luaGenerator.forBlock[type_os] = function (block, generator) {
    const value_name = lua.luaGenerator.valueToCode(block, 'name', lua.Order.ATOMIC) || "'my_object'";
    const input = block.getInputTargetBlock('name');
    if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
        return "spawnObject(tostring(" + value_name + "))\n";
    }
    return "spawnObject(" + value_name + ")\n";
};
php.phpGenerator.forBlock[type_os] = function (block, generator) {
    const value_name = php.phpGenerator.valueToCode(block, 'name', php.Order.ATOMIC) || "'my_object'";
    const input = block.getInputTargetBlock('name');
    if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
        return "spawnObject(strval(" + value_name + "));\n";
    }
    return "spawnObject(" + value_name + ");\n";
};
python.pythonGenerator.forBlock[type_os] = function (block, generator) {
    const value_name = python.pythonGenerator.valueToCode(block, 'name', python.Order.ATOMIC) || "'my_object'";
    const input = block.getInputTargetBlock('name');
    if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
        return "spawnObject(str(" + value_name + "))\n";
    }
    return "spawnObject(" + value_name + ")\n";
};
