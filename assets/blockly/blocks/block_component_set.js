"use strict";
const type_cs = 'component_set';
Blockly.defineBlocksWithJsonArray([
    {
        "type": type_cs,
        "message0": "set %1 of %2 of %3 to %4 %5",
        "args0": [
            {
                "type": "field_dropdown",
                "name": "value",
                "options": [
                    [
                        "width",
                        "WIDTH",
                    ]
                ]
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
            {
                "type": "input_dummy",
            },
            {
                "type": "input_value",
                "name": "newValue",
                "check": ["Number", "String"]
            }
        ],
        "previousStatement": null,
        "nextStatement": null,
        "colour": 230,
        "tooltip": "set field of a component of an object",
        "inputsInline": true,
        "helpUrl": "",
        "extensions": ["ext_component_setter"]
    }
]);
function setComponentValue(block, generator, order) {
    const component = block.getFieldValue('component');
    const value = block.getFieldValue('value');
    const object = generator.valueToCode(block, 'object', order) || 0;
    try {
        let newValue = generator.valueToCode(block, 'newValue', order) || 0;
        if (value === 'EVENT') {
            newValue = "'" + generator.statementToCode(block, 'newValue') + "'" || '""';
        }
        const input = block.getInputTargetBlock('newValue');
        if (input && input.outputConnection && input.outputConnection.getCheck()?.includes('Number')) {
            return { object: object, component: component, value: value, newValue: newValue, toText: true };
        }
        return { object: object, component: component, value: value, newValue: newValue, toText: false };
    }
    catch (e) {
        return { object: object, component: component, value: value, newValue: 0, toText: false };
    }
}
javascript.javascriptGenerator.forBlock[type_cs] = function (block, generator) {
    const { object, component, value, newValue, toText } = setComponentValue(block, generator, javascript.Order.ATOMIC);
    if (toText) {
        return `setComponentValue(${object}, '${component}', '${value}', toString(${newValue}))\n`;
    }
    return `setComponentValue(${object}, '${component}', '${value}', ${newValue})\n`;
};
dart.dartGenerator.forBlock[type_cs] = function (block, generator) {
    const { object, component, value, newValue, toText } = setComponentValue(block, generator, dart.Order.ATOMIC);
    if (toText) {
        return `setComponentValue(${object}, '${component}', '${value}', ${newValue}.toString())\n`;
    }
    return `setComponentValue(${object}, '${component}', '${value}', ${newValue})\n`;
};
lua.luaGenerator.forBlock[type_cs] = function (block, generator) {
    const { object, component, value, newValue, toText } = setComponentValue(block, generator, lua.Order.ATOMIC);
    if (toText) {
        return `setComponentValue(${object}, '${component}', '${value}', tostring(${newValue}))\n`;
    }
    return `setComponentValue(${object}, '${component}', '${value}', ${newValue})\n`;
};
php.phpGenerator.forBlock[type_cs] = function (block, generator) {
    const { object, component, value, newValue, toText } = setComponentValue(block, generator, php.Order.ATOMIC);
    if (toText) {
        return `setComponentValue(${object}, '${component}', '${value}', strval(${newValue}))\n`;
    }
    return `setComponentValue(${object}, '${component}', '${value}', ${newValue})\n`;
};
python.pythonGenerator.forBlock[type_cs] = function (block, generator) {
    const { object, component, value, newValue, toText } = setComponentValue(block, generator, python.Order.ATOMIC);
    if (toText) {
        return `setComponentValue(${object}, '${component}', '${value}', str(${newValue}))\n`;
    }
    return `setComponentValue(${object}, '${component}', '${value}', ${newValue})\n`;
};
