"use strict";
const type_as = 'asset_spawn';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_as,
        "message0": "Spawn asset %1 with name %2",
        "args0": [
            {
                "type": "input_value",
                "name": "asset",
                "check": "String"
            },
            {
                "type": "input_value",
                "name": "name",
                "check": "String"
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "Spawn an asset",
        "helpUrl": "",
    }
]);
javascript.javascriptGenerator.forBlock[type_as] = function (block, generator) {
    const value_name = javascript.javascriptGenerator.valueToCode(block, 'name', javascript.Order.ATOMIC) || "'my_object'";
    const value_asset = javascript.javascriptGenerator.valueToCode(block, 'asset', javascript.Order.ATOMIC) || "'my_asset'";
    return "sendMessage(\"spawnAsset\", JSON.stringify([" + value_name + ", " + value_asset + "]));\n";
};
dart.dartGenerator.forBlock[type_as] = function (block, generator) {
    const value_name = dart.dartGenerator.valueToCode(block, 'name', dart.Order.ATOMIC) || "'my_object'";
    const input = block.getInputTargetBlock('name');
    if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
        return "spawnObject((" + value_name + ").toString());\n";
    }
    return "spawnObject(" + value_name + ");\n";
};
lua.luaGenerator.forBlock[type_as] = function (block, generator) {
    const value_name = lua.luaGenerator.valueToCode(block, 'name', lua.Order.ATOMIC) || "'my_object'";
    const input = block.getInputTargetBlock('name');
    if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
        return "spawnObject(tostring(" + value_name + "))\n";
    }
    return "spawnObject(" + value_name + ")\n";
};
php.phpGenerator.forBlock[type_as] = function (block, generator) {
    const value_name = php.phpGenerator.valueToCode(block, 'name', php.Order.ATOMIC) || "'my_object'";
    const input = block.getInputTargetBlock('name');
    if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
        return "spawnObject(strval(" + value_name + "));\n";
    }
    return "spawnObject(" + value_name + ");\n";
};
python.pythonGenerator.forBlock[type_as] = function (block, generator) {
    const value_name = python.pythonGenerator.valueToCode(block, 'name', python.Order.ATOMIC) || "'my_object'";
    const input = block.getInputTargetBlock('name');
    if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
        return "spawnObject(str(" + value_name + "))\n";
    }
    return "spawnObject(" + value_name + ")\n";
};
