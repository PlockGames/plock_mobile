import 'dart:ui';

const BLOCKLY_WAIT_DURATION = Duration(seconds: 6);

// Base
const BLOCKLY_START = Offset(0.05, 0.3); // The top left corner of the blockly webview
final BLOCKLY_BLOCKS = BLOCKLY_START + Offset(0.0, 0.11); // The top left corner of the blockly blocks selection

// Scroll
final BLOCKLY_SCROLL_LOGIC = BLOCKLY_START + Offset(0.0, 0.19);
final BLOCKLY_SCROLL_LOOPS = BLOCKLY_START + Offset(0.0, 0.2);
final BLOCKLY_SCROLL_MATH = BLOCKLY_START + Offset(0.0, 0.16);
final BLOCKLY_SCROLL_TEXT = BLOCKLY_START + Offset(0.0, 0.18);
