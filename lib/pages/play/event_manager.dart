import '../../models/component_types/component_rect.dart';
import '../../models/component_types/component_text.dart';
import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

class EventManager {

  static Map<String, Function> eventsList = {
    "changeRectWidth": changeRectWidth,
    "changeRectHeight": changeRectHeight,
    "changeTextText": changeTextText,
    "changeObjectPosX": changeObjectPosX,
    "changeObjectPosY": changeObjectPosY,
  };

  static void callEvent(String event, Game game) {
    event = event.replaceAll("'", "");
    List<String> parsedEvent = event.split(" ");
    if (parsedEvent.length > 0) {
      String eventName = parsedEvent[0];
      if (eventsList.containsKey(eventName)) {
        eventsList[eventName]!(parsedEvent, game);
      }
    }

  }

  static void changeRectWidth(List<String> args, Game game) {
    String objectName = args[1];
    double newWidth = double.parse(args[2]);
    try {
      GameObject object = game.objects.firstWhere((element) => element.name == objectName);
      ComponentRect rect = object.components.firstWhere((element) => element.type == "ComponentRect") as ComponentRect;
      rect.fields["width"]!.value = newWidth.toInt();
      game.isDirty = true;
    } catch (e) {
      print("Error: $e");
    }
  }

  static void changeRectHeight(List<String> args, Game game) {
    String objectName = args[1];
    double newHeight = double.parse(args[2]);
    try {
      GameObject object = game.objects.firstWhere((element) => element.name == objectName);
      ComponentRect rect = object.components.firstWhere((element) => element.type == "ComponentRect") as ComponentRect;
      rect.fields["height"]!.value = newHeight.toInt();
      game.isDirty = true;
    } catch (e) {
      print("Error: $e");
    }
  }

  static void changeTextText(List<String> args, Game game) {
    String objectName = args[1];
    String newText = args[2];
    try {
      GameObject object = game.objects.firstWhere((element) => element.name == objectName);
      ComponentText text = object.components.firstWhere((element) => element.type == "ComponentText") as ComponentText;
      text.fields["text"]!.value = newText;
      game.isDirty = true;
    } catch (e) {
      print("Error: $e");
    }
  }

  static void changeObjectPosX(List<String> args, Game game) {
    String objectName = args[1];
    double newX = double.parse(args[2]);
    try {
      GameObject object = game.objects.firstWhere((element) => element.name == objectName);
      object.position.x = newX;
      game.isDirty = true;
    } catch (e) {
      print("Error: $e");
    }
  }

  static void changeObjectPosY(List<String> args, Game game) {
    String objectName = args[1];
    double newY = double.parse(args[2]);
    try {
      GameObject object = game.objects.firstWhere((element) => element.name == objectName);
      object.position.x = newY;
      game.isDirty = true;
    } catch (e) {
      print("Error: $e");
    }
  }
}