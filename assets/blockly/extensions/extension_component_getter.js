"use strict";
const valuesGetTypeList = {
    "ComponentRect": [
        [
            "width",
            "WIDTH",
            actionGetNumber
        ],
        [
            "height",
            "HEIGHT",
            actionGetNumber
        ],
        [
            "color",
            "COLOR",
            actionGetColor
        ]
    ],
    "ComponentCircle": [
        [
            "radius",
            "RADIUS",
            actionGetNumber
        ],
        [
            "color",
            "COLOR",
            actionGetColor
        ]
    ],
    "ComponentText": [
        [
            "text",
            "TEXT",
            actionGetText
        ],
        [
            "color",
            "COLOR",
            actionGetColor
        ]
    ],
    "ComponentEvent": [
        [
            "trigger",
            "TRIGGER",
            actionGetText
        ]
    ],
    "ComponentVariable": [
        [
            "value",
            "VALUE",
            actionGetText
        ]
    ]
};
function actionGetNumber(thisBlock) {
    thisBlock.setOutput(true, 'Number');
}
function actionGetColor(thisBlock) {
    thisBlock.setOutput(true, 'Color');
}
function actionGetText(thisBlock) {
    thisBlock.setOutput(true, ['String', 'Number']);
}
function setNewGetList(thisBlock, component) {
    const valuesList = valuesGetTypeList[component];
    const input = thisBlock.getInput('value');
    if (input?.fieldRow.length && input?.fieldRow.length > 1) {
        const value = input?.fieldRow[1].getText() || '';
        input?.removeField('value');
    }
    input?.insertFieldAt(1, new Blockly.FieldDropdown(valuesList), 'value');
}
function updateGetValueInputs(thisBlock) {
    const component = thisBlock.getFieldValue('component');
    const value = thisBlock.getFieldValue('value');
    const valuesList = valuesGetTypeList[component];
    const valueList = valuesList.find((item) => item[1] === value);
    if (valueList) {
        valueList[2](thisBlock);
    }
}
Blockly.Extensions.register('ext_component_getter', function () {
    var thisBlock = this;
    // Setup initial block
    updateGetValueInputs(thisBlock);
    setNewGetList(thisBlock, thisBlock.getFieldValue('component'));
    // Update block when component changes
    thisBlock.setOnChange(function (changeEvent) {
        const component = thisBlock.getFieldValue('component');
        var value = '';
        if (changeEvent.type === Blockly.Events.BLOCK_CHANGE
            && changeEvent.name === 'component'
            && changeEvent.oldValue !== changeEvent.newValue) {
            setNewGetList(thisBlock, changeEvent.newValue);
            updateGetValueInputs(thisBlock);
        }
        else if (changeEvent.type === Blockly.Events.BLOCK_CHANGE
            && changeEvent.name === 'value'
            && changeEvent.oldValue !== changeEvent.newValue) {
            updateGetValueInputs(thisBlock);
        }
    });
});
