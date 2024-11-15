import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/blocky/addons_manager.dart';

void main() {
  group('Test Addon Manager', ()
  {
    WidgetsFlutterBinding.ensureInitialized();

    test('Should return assets plugins', () async {
      AddonsManager addonsManager = AddonsManager();
      final plugins = await addonsManager.getPlugins();

      expect(addonsManager, isNotNull);
      expect(plugins, isList);
    });

    test('Should return assets extensions', () async {
      AddonsManager addonsManager = AddonsManager();
      final extensions = await addonsManager.getExtensions();

      expect(addonsManager, isNotNull);
      expect(extensions, isList);
    });

    test('Should return assets blocks', () async {
      AddonsManager addonsManager = AddonsManager();
      final blocks = await addonsManager.getBlocks();

      expect(addonsManager, isNotNull);
      expect(blocks, isList);
    });

    test('Should return all assets', () async {
      AddonsManager addonsManager = AddonsManager();
      final assets = await addonsManager.getAll();

      expect(addonsManager, isNotNull);
      expect(assets, isList);
    });
  });
}