import '../../models/component_types/component_rect.dart';
import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

class EventManager {

  static Map<String, Function> eventsList = {
    "changeRectWidth": changeRectWidth,
    "changeRectHeight": changeRectHeight,
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
}