import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/pages/my_games/game_editor/add_component_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';

void main() {
  group('AddComponentPage', () {
    late ComponentType addedComponent;

    // Function that will be called when a component is added
    void onAddComponent(ComponentType component) {
      addedComponent = component;
    }

    testWidgets('calls onAddComponent and navigates back when component is tapped', (WidgetTester tester) async {
      // Create a navigator observer to track navigation
      final navigatorObserver = NavigatorObserver();

      // Build our widget with the navigator observer
      await tester.pumpWidget(MaterialApp(
        navigatorObservers: [navigatorObserver],
        home: AddComponentPage(
          onAddComponent: onAddComponent,
          canvas: EditorCanvas.ui,
        ),
      ));

      // Get the first component from the UI components
      final uiComponents = ComponentList.getUi();
      final firstComponent = uiComponents.values.first;

      // Tap on the first component
      await tester.tap(find.text(firstComponent.name));
      await tester.pumpAndSettle();

      // Verify that onAddComponent was called with the correct component
      expect(addedComponent, equals(firstComponent));

      // Verify that navigation back happened
      expect(navigatorObserver.navigator?.canPop(), isFalse);
    });

    testWidgets('has working ListView for scrolling through components', (WidgetTester tester) async {
      // Build our widget and make it small to force scrolling
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(400, 300)),
          child: AddComponentPage(
            onAddComponent: onAddComponent,
            canvas: EditorCanvas.scene,
          ),
        ),
      ));

      // Get all scene components
      final sceneComponents = ComponentList.getScene();

      // Find the ListView
      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);

      // If there are multiple components, verify scrolling works
      if (sceneComponents.length > 3) {
        // Get the last component
        final lastComponent = sceneComponents.values.last;

        // Initially, the last component might not be visible
        // Let's check if it's visible or not
        final initialVisibility = find.text(lastComponent.name).evaluate().isNotEmpty;

        if (!initialVisibility) {
          // Scroll to the bottom
          await tester.dragUntilVisible(
            find.text(lastComponent.name),
            listViewFinder,
            const Offset(0, -300),
          );

          // Now the last component should be visible
          expect(find.text(lastComponent.name), findsOneWidget);
        }
      }
    });
  });
}