import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/game_object_type.dart';
import 'package:plock_mobile/pages/my_games/game_editor/add_component_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';
import '../../../models/games/component_type.dart';
import 'edit_component_page.dart';
import 'object_select_parent_page.dart';

/// The page to edit an object.
class ObjectEditorPage extends StatefulWidget {

  /// The object to edit.
  final ObjectComponent object;

  /// All the objects of the game.
  final List<GameObject> objects;

  ObjectEditorPage({super.key, required this.object, required this.objects});

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
      widget.object.gameObject.components.add(instance);
      widget.object.updateDisplay();
    });
  }

  /// Remove a [component] from the object.
  ///
  /// The [component] is removed from the object and the display is updated.
  void removeComponent(ComponentType component) {
    setState(() {
      widget.object.gameObject.components.remove(component);
      widget.object.updateDisplay();
    });
  }

  /// Convert an asset to an object
  void convertAssetToObject() {
    setState(() {
      widget.object.gameObject.type = GameObjectType.object;
      widget.object.gameObject.assetId = null;
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
    TextEditingController(text: widget.object.gameObject.name);

    if (widget.object.gameObject.type == GameObjectType.asset) {
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
                    Text("id : ${widget.object.gameObject.id}"),
                  ],
                ),
                TextField(
                  controller: nameController,
                  onChanged: (value) {
                    widget.object.gameObject.name = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                    label: Text('Name'),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(onPressed: setParent, child: Text(widget.object.gameObject.parent != null ? "Parent: ${widget.object.gameObject.parent!.name}" : "Parent: None")),
                const SizedBox(height: 40),
                for (var component in widget.object.gameObject.components)
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
                      ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ));
    }

  }
}
