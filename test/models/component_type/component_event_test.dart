import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';

void main() {
  late ComponentEvent componentEvent;

  setUp(() {
    componentEvent = ComponentEvent();
  });

  test('ComponentEvent initializes with correct default fields', () {
    expect(componentEvent.type, 'ComponentEvent');
    expect(componentEvent.name, 'Event');

    expect(componentEvent.fields.containsKey('name'), isTrue);
    expect(componentEvent.fields['name']!.value, 'my_event');

    expect(componentEvent.fields.containsKey('trigger'), isTrue);
    expect(componentEvent.fields['trigger']!.value, 'ON_START');

    expect(componentEvent.fields.containsKey('event'), isTrue);
  });

  test('Instance method creates a new ComponentEvent with copied fields', () {
    componentEvent.fields['name']!.value = 'custom_event';
    componentEvent.fields['trigger']!.value = 'ON_TAP';

    ComponentEvent newInstance = componentEvent.instance() as ComponentEvent;

    expect(newInstance.fields['name']!.value, 'custom_event');
    expect(newInstance.fields['trigger']!.value, 'ON_TAP');
    expect(newInstance, isNot(same(componentEvent)));
  });

  test('Debug data contains event field data', () {
    final debugData = componentEvent.debugData;

    expect(debugData.containsKey('event'), isTrue);
    expect(debugData['event'], componentEvent.fields['event']!.debugData);
  });
}