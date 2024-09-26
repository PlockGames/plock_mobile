import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox_category.dart';

void main() {
  group('Test toolbox block', ()
  {

    test('Should return a simple category', () async {

      ToolboxCategory category = ToolboxCategory(name: "category");
      expect(category.name, "category");
      expect(category.blocks, null);
      expect(category.custom, null);
      expect(category.color, 0);
    });

  });
}