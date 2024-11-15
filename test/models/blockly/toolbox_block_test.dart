import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';

void main() {
  group('Test toolbox block', ()
  {

    test('Should return ', () async {

      const block_controls_if = {
        "kind": "block",
        "type": "controls_if"
      };

      ToolboxBlock block = ToolboxBlock(data: block_controls_if);
      expect(block.data, block_controls_if);
    });
    
  });
}