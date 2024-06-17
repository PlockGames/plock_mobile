import 'package:flame/components.dart';
import 'package:flame/events.dart';

class ComponentFlameText extends TextComponent with TapCallbacks, DragCallbacks {
  final onTapeUpCallback;
  final onDragStartCallback;
  final onDragUpdateCallback;
  final onDragEndCallback;
  final onDragCancelCallback;


  ComponentFlameText({
    required this.onDragStartCallback,
    required this.onTapeUpCallback,
    required this.onDragCancelCallback,
    required this.onDragEndCallback,
    required this.onDragUpdateCallback,
    super.position,
    super.text
  });

  @override
  bool onTapUp(TapUpEvent info) {
    return onTapeUpCallback(info);
  }

  @override
  void onDragStart(DragStartEvent event) {
    onDragStartCallback(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    onDragUpdateCallback(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    onDragEndCallback(event);
  }

  void onDragCancel(DragCancelEvent event) {
    onDragCancelCallback(event);
  }

}