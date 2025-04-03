// import 'package:flutter_test/flutter_test.dart';
// import 'package:plock_mobile/data/initial_toolbox.dart';

// void main() {
//   group('Initial Toolbox Tests', () {
//     test('Toolbox should be initialized with correct number of categories', () {
//       expect(initialToolbox.categories.length, 9);
//     });

//     test('Toolbox should contain all expected categories', () {
//       final categoryNames = initialToolbox.categories.map((c) => c.name).toList();

//       expect(categoryNames, contains('logic'));
//       expect(categoryNames, contains('loops'));
//       expect(categoryNames, contains('math'));
//       expect(categoryNames, contains('text'));
//       expect(categoryNames, contains('lists'));
//       expect(categoryNames, contains('colour'));
//       expect(categoryNames, contains('system'));
//       expect(categoryNames, contains('objects'));
//       expect(categoryNames, contains('variables'));
//     });

//     test('Logic category should contain the correct blocks', () {
//       final logicCategory = initialToolbox.categories
//           .firstWhere((category) => category.name == 'logic');

//       expect(logicCategory.blocks?.length, 6);

//       // Vérifier que certains blocs spécifiques sont présents
//       final blockTypes = logicCategory.blocks?.map((b) => b.data['type']).toList();
//       expect(blockTypes, contains('controls_if'));
//       expect(blockTypes, contains('logic_compare'));
//       expect(blockTypes, contains('logic_operation'));
//       expect(blockTypes, contains('logic_boolean'));
//     });

//     test('Math category should contain the correct blocks', () {
//       final mathCategory = initialToolbox.categories
//           .firstWhere((category) => category.name == 'math');

//       expect(mathCategory.blocks?.length, 14);

//       final blockTypes = mathCategory.blocks?.map((b) => b.data['type']).toList();
//       expect(blockTypes, contains('math_number'));
//       expect(blockTypes, contains('math_arithmetic'));
//       expect(blockTypes, contains('to_number'));
//     });

//     test('Variables category should have custom attribute set', () {
//       final variablesCategory = initialToolbox.categories
//           .firstWhere((category) => category.name == 'variables');

//       expect(variablesCategory.custom, 'VARIABLE');
//       expect(variablesCategory.blocks, isNull);
//     });

//     test('Objects category should contain game-specific blocks', () {
//       final objectsCategory = initialToolbox.categories
//           .firstWhere((category) => category.name == 'objects');

//       expect(objectsCategory.blocks?.length, 16);

//       final blockTypes = objectsCategory.blocks?.map((b) => b.data['type']).toList();
//       expect(blockTypes, contains('object'));
//       expect(blockTypes, contains('object_spawn'));
//       expect(blockTypes, contains('component_get'));
//       expect(blockTypes, contains('component_variable_get')); // Corrigé
//       expect(blockTypes, contains('asset_spawn'));
//       expect(blockTypes, contains('object_force_add')); // Corrigé
//       expect(blockTypes, contains('object_force_set')); // Corrigé
//     });

//     test('System category should contain system-related blocks', () {
//       final systemCategory = initialToolbox.categories
//           .firstWhere((category) => category.name == 'system');

//       final blockTypes = systemCategory.blocks?.map((b) => b.data['type']).toList();
//       expect(blockTypes, contains('delta_time'));
//       expect(blockTypes, contains('collider'));
//       expect(blockTypes, contains('camera_get'));
//       expect(blockTypes, contains('screen_wait')); // Corrigé
//       expect(blockTypes, contains('touch_get'));
//     });
//   });
// }