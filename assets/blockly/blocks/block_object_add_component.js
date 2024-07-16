"use strict";
const type_oac = 'object_add_component';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_oac,
        "message0": "add component %1 %2 to object %3",
        "args0": [
            {
                "type": "field_dropdown",
                "name": "component",
                "options": [
                    [
                        "rectangle",
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
                "type": "input_dummy"
            },
            {
                "type": "input_value",
                "name": "object",
                "check": "Number"
            }
        ],
        "inputsInline": true,
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "Add a component to an object",
        "helpUrl": "",
        "extensions": ["ext_add_component"]
    }
]);
javascript.javascriptGenerator.forBlock[type_oac] = function (block, generator) {
    const component = block.getFieldValue('component');
    const object = javascript.javascriptGenerator.valueToCode(block, 'object', javascript.Order.ATOMIC) || 0;
    try {
        const event = javascript.javascriptGenerator.valueToCode(block, 'event', javascript.Order.ATOMIC) || "'my_event'";
        const input = block.getInputTargetBlock('event');
        if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
            return `addComponent(${object}, "${component}", String(${event}));\n`;
        }
        return `addComponent(${object}, "${component}", ${event});\n`;
    }
    catch (e) {
        return `addComponent(${object}, "${component}", "\'my_event\'");\n`;
    }
};
dart.dartGenerator.forBlock[type_oac] = function (block, generator) {
    const component = block.getFieldValue('component');
    const object = dart.dartGenerator.valueToCode(block, 'object', dart.Order.ATOMIC) || 0;
    try {
        const event = dart.dartGenerator.valueToCode(block, 'event', dart.Order.ATOMIC) || "'my_event'";
        const input = block.getInputTargetBlock('event');
        if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
            return `addComponent(${object}, "${component}", ${event}.toString());\n`;
        }
        return `addComponent(${object}, "${component}", ${event});\n`;
    }
    catch (e) {
        return `addComponent(${object}, "${component}", "\'my_event\'");\n`;
    }
};
lua.luaGenerator.forBlock[type_oac] = function (block, generator) {
    const component = block.getFieldValue('component');
    const object = lua.luaGenerator.valueToCode(block, 'object', lua.Order.ATOMIC) || 0;
    try {
        const event = lua.luaGenerator.valueToCode(block, 'event', lua.Order.ATOMIC) || "\'my_event\'";
        const input = block.getInputTargetBlock('event');
        if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
            return `addComponent(${object}, "${component}", tostring(${event}))\n`;
        }
        return `addComponent(${object}, "${component}", ${event})\n`;
    }
    catch (e) {
        return `addComponent(${object}, "${component}", "\'my_event\'")\n`;
    }
};
php.phpGenerator.forBlock[type_oac] = function (block, generator) {
    const component = block.getFieldValue('component');
    const object = php.phpGenerator.valueToCode(block, 'object', php.Order.ATOMIC) || 0;
    try {
        const event = php.phpGenerator.valueToCode(block, 'event', php.Order.ATOMIC) || "'my_event'";
        const input = block.getInputTargetBlock('event');
        if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
            return `addComponent(${object}, "${component}", strval(${event}));\n`;
        }
        return `addComponent(${object}, "${component}", ${event});\n`;
    }
    catch (e) {
        return `addComponent(${object}, "${component}", "\'my_event\'");\n`;
    }
};
python.pythonGenerator.forBlock[type_oac] = function (block, generator) {
    const component = block.getFieldValue('component');
    const object = python.pythonGenerator.valueToCode(block, 'object', python.Order.ATOMIC) || 0;
    try {
        const event = python.pythonGenerator.valueToCode(block, 'event', python.Order.ATOMIC) || "'my_event'";
        const input = block.getInputTargetBlock('event');
        if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
            return `addComponent(${object}, "${component}", str(${event}))\n`;
        }
        return `addComponent(${object}, "${component}", ${event})\n`;
    }
    catch (e) {
        return `addComponent(${object}, "${component}", "\'my_event\'")\n`;
    }
};
