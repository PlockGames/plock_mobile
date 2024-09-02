import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/component_types/component_circle.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';
import 'package:plock_mobile/models/component_types/component_rect.dart';
import 'package:plock_mobile/models/component_types/component_text.dart';
import 'package:plock_mobile/models/component_types/component_variable.dart';

void main() {
  test('Should return all components in a list', () {

    final components = ComponentList.get();

    expect(components, isMap);

  });

  test("Should return correct components", () {
    expect(ComponentList.getByName("ComponentRect"), isA<ComponentRect>());
    expect(ComponentList.getByName("ComponentCircle"), isA<ComponentCircle>());
    expect(ComponentList.getByName("ComponentText"), isA<ComponentText>());
    expect(ComponentList.getByName("ComponentEvent"), isA<ComponentEvent>());
    expect(ComponentList.getByName("ComponentVariable"), isA<ComponentVariable>());
  });
}