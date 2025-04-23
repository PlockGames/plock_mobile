import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import '../../pages/play/game_player_object.dart';
import '../../pages/play/game_player_ui_object.dart';
import '../component_fields/component_field_number.dart';
import '../component_fields/component_field_sprite.dart';
import '../component_fields/sprite/sprite_animation.dart';
import '../component_flame/component_flame_sprite.dart';
import '../games/component_type.dart';
import '../games/media.dart';

/// A component that contain an object level variable
class ComponentUiSprite extends ComponentType {

  ComponentUiSprite() {
    fields["size"] = ComponentFieldNumber(value: 100.0);
    fields["current"] = ComponentFieldText(value: "");
    fields["animator"] = ComponentFieldSprite(value: List<PlockSpriteAnimation>.empty(growable: true));
  }

  @override
  String get type => 'ComponentUiSprite';

  @override
  String get name => 'Sprite';

  @override
  ComponentType instance() {
    ComponentUiSprite comp = ComponentUiSprite();
    fields.forEach((key, value) {
      comp.fields[key] = value.instance();
    });
    return comp;
  }

  @override
  DisplayComponents getDisplayComponent(List<Media> medias,
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback) {

    List<PlockSpriteAnimation> animator = fields["animator"]!.value;
    String current = fields["current"]!.value;

    if (animator.isEmpty) {
      return DisplayComponents(display: null, select: null);
    }

    PlockSpriteAnimation? animation;
    try {
      animation = animator.firstWhere((element) => element.name == current);
    } catch (e) {
      animation = null;
    }
    animation ??= animator.first;

    if (animation.images.isEmpty) {
      return DisplayComponents(display: null, select: null);
    }

    ComponentFlameSprite display = ComponentFlameSprite(
        onDragStartCallback: onDragStartCallback,
        onTapeUpCallback: onTapeUpCallback,
        onDragCancelCallback: onDragCancelCallback,
        onDragEndCallback: onDragEndCallback,
        onDragUpdateCallback: onDragUpdateCallback,
        animation: animation,
        medias: medias,
        initScale: Vector2(
            fields["size"]!.value.toDouble(), fields["size"]!.value.toDouble()),
        componentType: this
    );

    return DisplayComponents(display: display, select: null);
  }

  @override
  Component? getGameDisplayComponent(List<Media> medias,
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback) {
    List<PlockSpriteAnimation> animator = fields["animator"]!.value;
    String current = fields["current"]!.value;

    if (animator.isEmpty) {
      return null;
    }

    PlockSpriteAnimation? animation;
    try {
      animation = animator.firstWhere((element) => element.name == current);
    } catch (e) {
      animation = null;
    }
    animation ??= animator.first;

    ComponentFlameSprite display = ComponentFlameSprite(
        onDragStartCallback: onDragStartCallback,
        onTapeUpCallback: onTapeUpCallback,
        onDragCancelCallback: onDragCancelCallback,
        onDragEndCallback: onDragEndCallback,
        onDragUpdateCallback: onDragUpdateCallback,
        animation: animation,
        medias: medias,
        initScale: Vector2(
            fields["size"]!.value.toDouble(), fields["size"]!.value.toDouble()),
        componentType: this
    );

    return display;

  }

  @override
  Future<GamePlayerUiObject> updateDisplayUi(Component? component,
      GamePlayerUiObject parent) async {
    if (component is ComponentFlameSprite) {
      ComponentFlameSprite sprite = component;
      sprite.animation = fields["animator"]!.value.firstWhere((element) => element.name == fields["current"]!.value);
    }
    return parent;
  }

}
