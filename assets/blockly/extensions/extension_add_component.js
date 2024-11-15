"use strict";
Blockly.Extensions.register('ext_add_component', function () {
    var thisBlock = this;
    thisBlock.setOnChange(function (changeEvent) {
        const component = thisBlock.getFieldValue('component');
        if (component === 'ComponentEvent') {
            if (thisBlock.getInput('event') === null) {
                thisBlock.appendValueInput('event').appendField("with name").setCheck(['String', 'Number']);
            }
        }
        else {
            if (thisBlock.getInput('event') !== null) {
                thisBlock.removeInput('event');
            }
        }
    });
});
