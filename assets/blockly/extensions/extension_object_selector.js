"use strict";
Blockly.Extensions.register('ext_object_selector', function () {
    var thisBlock = this;
    thisBlock.setOnChange(function (changeEvent) {
        if (thisBlock.id !== changeEvent.blockId) {
            return;
        }
        const changeType = changeEvent.type;
        if (changeType === Blockly.Events.BLOCK_CHANGE) {
            console.log('block changed', changeEvent);
            const newValue = changeEvent.newValue;
            const input = thisBlock.getInput('obj_name');
            console.log(newValue);
            if (newValue === 'OBJECT_NAME') {
                if (!input) {
                    thisBlock.appendValueInput('obj_name')
                        .setCheck(['String', 'Number']);
                }
            }
            else {
                const input = thisBlock.getInput('obj_name');
                if (input) {
                    thisBlock.removeInput('obj_name');
                }
            }
        }
        else if (changeType === Blockly.Events.BLOCK_CREATE) {
            const blockJson = changeEvent.json;
            //console.log('block created', blockJson);
            const inputs = blockJson?.inputs;
            const fields = blockJson?.fields;
            const field = fields?.object;
            if (field === 'OBJECT_NAME') {
                const name = thisBlock.getInput('obj_name');
                if (!name) {
                    thisBlock.appendValueInput('obj_name')
                        .setCheck(['String', 'Number']);
                }
            }
            else {
                const name = thisBlock.getInput('obj_name');
                console.log(name);
                if (name) {
                    thisBlock.removeInput('obj_name');
                }
            }
        }
    });
});
