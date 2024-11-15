"use strict";
Blockly.Extensions.register('ext_object_selector', function () {
    var thisBlock = this;
    thisBlock.setOnChange(function (changeEvent) {
        const component = thisBlock.getFieldValue('object');
        if (component === 'OBJECT_NAME') {
            if (thisBlock.getInput('name') === null) {
                thisBlock.appendValueInput('name').setCheck(['String', "Number"]);
                thisBlock.setInputsInline(true);
            }
        }
        else {
            if (thisBlock.getInput('name') !== null) {
                thisBlock.removeInput('name');
            }
        }
    });
});
