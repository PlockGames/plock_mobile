"use strict";
const type_o = 'object';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_o,
        "message0": "%1",
        "args0": [
            {
                "type": "field_dropdown",
                "name": "object",
                "options": [
                    [
                        "this object",
                        "THIS_OBJECT"
                    ],
                    [
                        "last object spawned",
                        "LAST_OBJECT"
                    ],
                    [
                        "object with name",
                        "OBJECT_NAME"
                    ],
                ]
            },
        ],
        "output": "Number",
        "colour": 230,
        "tooltip": "Spawn an object",
        "helpUrl": "",
        "extensions": ["ext_object_selector"]
    }
]);
javascript.javascriptGenerator.forBlock[type_o] = function (block, generator) {
    const object = block.getFieldValue('object');
    if (object === 'THIS_OBJECT') {
        return ["sendMessage(\"thisObject\", JSON.stringify([]))", javascript.Order.ATOMIC];
    }
    else if (object === 'LAST_OBJECT') {
        return ["sendMessage(\"lastObject\", JSON.stringify([]))", javascript.Order.ATOMIC];
    }
    else if (object === 'OBJECT_NAME') {
        try {
            const name = javascript.javascriptGenerator.valueToCode(block, 'name', javascript.Order.ATOMIC) || "'my_object'";
            const input = block.getInputTargetBlock('name');
            if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
                return ["sendMessage(\"objectByName\", JSON.stringify([String(" + name + ")]))", javascript.Order.ATOMIC];
            }
            return ["sendMessage(\"objectByName\", JSON.stringify([" + name + "]))", javascript.Order.ATOMIC];
        }
        catch (e) {
        }
    }
    return [`ERROR(${type_o}`, javascript.Order.ATOMIC];
};
dart.dartGenerator.forBlock[type_o] = function (block, generator) {
    const object = block.getFieldValue('object');
    if (object === 'THIS_OBJECT') {
        return ["thisObject()", dart.Order.ATOMIC];
    }
    else if (object === 'LAST_OBJECT') {
        return ["lastObject()", dart.Order.ATOMIC];
    }
    else if (object === 'OBJECT_NAME') {
        try {
            const name = dart.dartGenerator.valueToCode(block, 'name', dart.Order.ATOMIC) || "'my_object'";
            const input = block.getInputTargetBlock('name');
            if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
                return ["objectByName(" + name + ".toString())", dart.Order.ATOMIC];
            }
            return ["objectByName(" + name + ")", dart.Order.ATOMIC];
        }
        catch (e) {
            return ["objectByName('my_object')", dart.Order.ATOMIC];
        }
    }
    return [`ERROR(${type_o}`, dart.Order.ATOMIC];
};
lua.luaGenerator.forBlock[type_o] = function (block, generator) {
    const object = block.getFieldValue('object');
    if (object === 'THIS_OBJECT') {
        return ["thisObject()", lua.Order.ATOMIC];
    }
    else if (object === 'LAST_OBJECT') {
        return ["lastObject()", lua.Order.ATOMIC];
    }
    else if (object === 'OBJECT_NAME') {
        try {
            const name = lua.luaGenerator.valueToCode(block, 'name', lua.Order.ATOMIC) || "'my_object'";
            const input = block.getInputTargetBlock('name');
            if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
                return ["objectByName(tostring(" + name + "))", lua.Order.ATOMIC];
            }
            return ["objectByName(" + name + ")", lua.Order.ATOMIC];
        }
        catch (e) {
            return ["objectByName('my_object')", lua.Order.ATOMIC];
        }
    }
    return [`ERROR(${type_o}`, lua.Order.ATOMIC];
};
php.phpGenerator.forBlock[type_o] = function (block, generator) {
    const object = block.getFieldValue('object');
    if (object === 'THIS_OBJECT') {
        return ["thisObject()", php.Order.ATOMIC];
    }
    else if (object === 'LAST_OBJECT') {
        return ["lastObject()", php.Order.ATOMIC];
    }
    else if (object === 'OBJECT_NAME') {
        try {
            const name = php.phpGenerator.valueToCode(block, 'name', php.Order.ATOMIC) || "'my_object'";
            const input = block.getInputTargetBlock('name');
            if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
                return ["objectByName(strval(" + name + "))", php.Order.ATOMIC];
            }
            return ["objectByName(" + name + ")", php.Order.ATOMIC];
        }
        catch (e) {
            return ["objectByName('my_object')", php.Order.ATOMIC];
        }
    }
    return [`ERROR(${type_o}`, php.Order.ATOMIC];
};
python.pythonGenerator.forBlock[type_o] = function (block, generator) {
    const object = block.getFieldValue('object');
    if (object === 'THIS_OBJECT') {
        return ["thisObject()", python.Order.ATOMIC];
    }
    else if (object === 'LAST_OBJECT') {
        return ["lastObject()", python.Order.ATOMIC];
    }
    else if (object === 'OBJECT_NAME') {
        try {
            const name = python.pythonGenerator.valueToCode(block, 'name', python.Order.ATOMIC) || "'my_object'";
            const input = block.getInputTargetBlock('name');
            if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
                return ["objectByName(str(" + name + "))", python.Order.ATOMIC];
            }
            return ["objectByName(" + name + ")", python.Order.ATOMIC];
        }
        catch (e) {
            return ["objectByName('my_object')", python.Order.ATOMIC];
        }
    }
    return [`ERROR(${type_o}`, python.Order.ATOMIC];
};
