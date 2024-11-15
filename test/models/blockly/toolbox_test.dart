import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox_category.dart';

void main() {
  group('Test Toolbox', () {

    test('Empty Toolbox', () {
      Toolbox toolbox = Toolbox(categories: []);

      expect(toolbox, isNotNull);
      expect(toolbox.categories, []);

      final json = toolbox.toJson();

      expect(json, {'kind': 'categoryToolbox', 'contents': []});
    });

    test('1 empty category Toolbox', () {
      Toolbox toolbox = Toolbox(categories: [
        ToolboxCategory(name: 'Category', blocks: [])
      ]);

      expect(toolbox, isNotNull);
      expect(toolbox.categories.length, 1);
      expect(toolbox.categories[0].name, 'Category');
      expect(toolbox.categories[0].blocks, isNotNull);
      expect(toolbox.categories[0].blocks!.length, 0);

      final json = toolbox.toJson();

      expect(json, {
        'kind': 'categoryToolbox',
        'contents': [
          {
            'kind': 'category',
            'name': 'Category',
            'colour': 0,
            'contents': [

            ]
          }
        ]
      });

    });
    
    test('1 category with 1 block Toolbox', () {
      Toolbox toolbox = Toolbox(categories: [
        ToolboxCategory(name: 'Category', blocks: [ToolboxBlock(data: {'data' : "data"})])
      ]);

      expect(toolbox, isNotNull);
      expect(toolbox.categories.length, 1);
      expect(toolbox.categories[0].name, 'Category');
      expect(toolbox.categories[0].blocks, isNotNull);
      expect(toolbox.categories[0].blocks!.length, 1);
      expect(toolbox.categories[0].blocks![0].data, {'data' : "data"});
      expect(toolbox.categories[0].blocks![0].toJson(), {'data' : "data"});

      final json = toolbox.toJson();

      expect(json, {
        'kind': 'categoryToolbox',
        'contents': [
          {
            'kind': 'category',
            'name': 'Category',
            'colour': 0,
            'contents': [{'data': 'data'}]
          }
        ]
      });

    });

    test('2 categories 2 blocks toolbox', () {
      Toolbox toolbox = Toolbox(categories: [
        ToolboxCategory(name: 'Category1', blocks: [ToolboxBlock(data: {'data' : "data1"})]),
        ToolboxCategory(name: 'Category2', blocks: [ToolboxBlock(data: {'data' : "data2"})])
      ]);

      expect(toolbox, isNotNull);
      expect(toolbox.categories.length, 2);
      expect(toolbox.categories[0].name, 'Category1');
      expect(toolbox.categories[0].blocks, isNotNull);
      expect(toolbox.categories[0].blocks!.length, 1);
      expect(toolbox.categories[0].blocks![0].data, {'data' : "data1"});
      expect(toolbox.categories[0].blocks![0].toJson(), {'data' : "data1"});
      expect(toolbox.categories[1].name, 'Category2');
      expect(toolbox.categories[1].blocks, isNotNull);
      expect(toolbox.categories[1].blocks!.length, 1);
      expect(toolbox.categories[1].blocks![0].data, {'data' : "data2"});
      expect(toolbox.categories[1].blocks![0].toJson(), {'data' : "data2"});

      final json = toolbox.toJson();

      expect(json, {
        'kind': 'categoryToolbox',
        'contents': [
          {
            'kind': 'category',
            'name': 'Category1',
            'colour': 0,
            'contents': [{'data': 'data1'}]
          },
          {
            'kind': 'category',
            'name': 'Category2',
            'colour': 0,
            'contents': [{'data': 'data2'}]
          }
        ]
      });

    });

  });
}
