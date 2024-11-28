"use strict";
const valuesSetTypeList = {
    "ComponentRect": [
        [
            "width",
            "WIDTH",
            actionSetNumber
        ],
        [
            "height",
            "HEIGHT",
            actionSetNumber
        ],
        [
            "color",
            "COLOR",
            actionSetColor
        ]
    ],
    "ComponentCircle": [
        [
            "radius",
            "RADIUS",
            actionSetNumber
        ],
        [
            "color",
            "COLOR",
            actionSetColor
        ]
    ],
    "ComponentText": [
        [
            "text",
            "TEXT",
            actionSetText
        ],
        [
            "color",
            "COLOR",
            actionSetColor
        ]
    ],
    "ComponentEvent": [
        [
            "trigger",
            "TRIGGER",
            actionSetText
        ]
    ],
    "ComponentVariable": [
        [
            "value",
            "VALUE",
            actionSetText
        ]
    ]
};
function actionRemoveAll(thisBlock, types) {
    const input = thisBlock.getInput('newValue');
    var hasTypeChanged = true;
    if (input && types) {
        for (const type of types) {
            if (input?.connection?.targetConnection?.check.includes(type)) {
                hasTypeChanged = false;
            }
        }
    }
    if (input && hasTypeChanged) {
        if (input.connection) {
            const targetBlock = input.connection.targetBlock();
            if (targetBlock && targetBlock.isShadow()) {
                input.connection.setShadowDom(null);
                targetBlock.unplug();
            }
            thisBlock.removeInput('newValue');
            return true;
        }
    }
    return false;
}
function actionSetNumber(thisBlock) {
    if (actionRemoveAll(thisBlock, ['Number'])) {
        const input = thisBlock.appendValueInput('newValue');
        input.setCheck('Number');
        const shadow = thisBlock.workspace.newBlock('math_number');
        shadow.setShadow(true);
        input.connection.connect(shadow.outputConnection);
        input.setShadowDom(Blockly.Xml.blockToDom(shadow));
    }
}
function actionSetColor(thisBlock) {
    if (actionRemoveAll(thisBlock, ['Colour'])) {
        const input = thisBlock.appendValueInput('newValue');
        input.setCheck('Colour');
        const shadow = thisBlock.workspace.newBlock('colour_picker');
        shadow.setShadow(true);
        input.connection.connect(shadow.outputConnection);
        input.setShadowDom(Blockly.Xml.blockToDom(shadow));
    }
}
function actionSetText(thisBlock) {
    if (actionRemoveAll(thisBlock, ['String', 'Number'])) {
        const input = thisBlock.appendValueInput('newValue');
        input.setCheck(['String', 'Number']);
        const shadow = thisBlock.workspace.newBlock('text');
        shadow.setShadow(true);
        input.connection.connect(shadow.outputConnection);
        input.setShadowDom(Blockly.Xml.blockToDom(shadow));
    }
}
function setNewList(thisBlock, component, newValue) {
    const valuesList = valuesSetTypeList[component];
    const input = thisBlock.inputList[0];
    if (input.fieldRow.find((item) => item.name === 'value')) {
        const value = input?.fieldRow[1].getText() || '';
        input?.removeField('value');
    }
    input?.insertFieldAt(1, new Blockly.FieldDropdown(valuesList), 'value');
    if (newValue) {
        input?.fieldRow.find((item) => item.name === 'value')?.setValue(newValue);
        updateValueInputs(thisBlock, newValue);
    }
}
function updateValueInputs(thisBlock, value) {
    const component = thisBlock.getFieldValue('component');
    if (!value)
        value = thisBlock.getFieldValue('value');
    const valuesList = valuesSetTypeList[component];
    const valueList = valuesList.find((item) => item[1] === value);
    if (valueList) {
        valueList[2](thisBlock);
    }
}
Blockly.Extensions.register('ext_component_setter', function () {
    var thisBlock = this;
    // Update block when component changes
    thisBlock.setOnChange(function (changeEvent) {
        if (changeEvent.blockId !== thisBlock.id)
            return;
        if (changeEvent.type === Blockly.Events.BLOCK_CREATE) {
            setNewList(thisBlock, changeEvent.json.fields.component, changeEvent.json.fields.value);
            updateValueInputs(thisBlock, changeEvent.json.fields.value);
        }
        const component = thisBlock.getFieldValue('component');
        var value = '';
        if (changeEvent.type === Blockly.Events.BLOCK_CHANGE
            && changeEvent.name === 'component'
            && changeEvent.oldValue !== changeEvent.newValue) {
            setNewList(thisBlock, changeEvent.newValue);
            updateValueInputs(thisBlock);
        }
        else if (changeEvent.type === Blockly.Events.BLOCK_CHANGE
            && changeEvent.name === 'value'
            && changeEvent.oldValue !== changeEvent.newValue) {
            updateValueInputs(thisBlock);
        }
    });
});
