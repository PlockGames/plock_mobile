import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/game_object_type.dart';
import 'package:plock_mobile/pages/my_games/game_editor/add_component_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_scene_component.dart';
import '../../../models/games/component_type.dart';
import '../../../models/games/media.dart';
import 'edit_component_page.dart';
import 'editor/editor_canvas.dart';
import 'editor/object_component.dart';
import 'object_select_parent_page.dart';

/// The page to edit an object.
class ObjectEditorPage extends StatefulWidget {

  /// The object to edit.
  final ObjectComponent object;

  /// All the objects of the game.
  final List<GameObject> objects;

  /// All the media of the game.
  final List<Media> medias;

  /// The canvas of the object.
  final EditorCanvas canvas;

  ObjectEditorPage({super.key, required this.object, required this.objects, required this.medias, required this.canvas});

  @override
  State<StatefulWidget> createState() {
    return _ObjectEditorPageState();
  }
}

class _ObjectEditorPageState extends State<ObjectEditorPage> {
  @override
  void initState() {
    super.initState();
  }

  /// Add a [component] to the object.
  ///
  /// The [component] is added to the object and the display is updated.
  void addComponent(ComponentType component) {
    setState(() {
      ComponentType instance = component.instance();
      instance.setOnUpdate(widget.object.updateDisplay);
      widget.object.getGameObject().components.add(instance);
      widget.object.updateDisplay();
    });
  }

  /// Remove a [component] from the object.
  ///
  /// The [component] is removed from the object and the display is updated.
  void removeComponent(ComponentType component) {
    setState(() {
      widget.object.getGameObject().components.remove(component);
      widget.object.updateDisplay();
    });
  }

  /// Convert an asset to an object
  void convertAssetToObject() {
    setState(() {
      widget.object.getGameObject().type = GameObjectType.object;
      widget.object.getGameObject().assetId = null;
    });
  }

  void setParent() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ObjectSelectParentPage(
              objects: widget.objects,
              object: widget.object,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
    TextEditingController(text: widget.object.getGameObject().name);

    if (widget.object.getGameObject().type == GameObjectType.asset) {
      return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Text('Object Editor'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text("Assets can't be edited. Please edit the asset in the asset editor."),
                // Add button to convert asset to object
                ElevatedButton(onPressed: convertAssetToObject, child: Text("Convert to Object"))
              ],
            )
          )
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Text('Object Editor'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("id : ${widget.object.getGameObject().id}"),
                  ],
                ),
                TextField(
                  controller: nameController,
                  onChanged: (value) {
                    widget.object.getGameObject().name = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                    label: Text('Name'),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(onPressed: setParent, child: Text(widget.object.getGameObject().parent != null ? "Parent: ${widget.object.getGameObject().parent!.name}" : "Parent: None")),
                const SizedBox(height: 40),
                for (var component in widget.object.getGameObject().components)
                  Row(
                    children: [
                      Text(component.name),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditComponentPage(
                                    component: component,
                                    medias: widget.medias,
                                  ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          removeComponent(component);
                        },
                      ),
                    ],
                  )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AddComponentPage(
                        onAddComponent: addComponent,
                        canvas: widget.canvas,
                      ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ));
    }

  }
}
