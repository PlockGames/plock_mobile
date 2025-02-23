import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/game_object_type.dart';
import 'package:plock_mobile/pages/my_games/game_editor/add_component_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';
import '../../../models/games/component_type.dart';
import '../../../models/games/media.dart';
import 'edit_component_page.dart';

/// The page to edit an object.
class AssetEditorPage extends StatefulWidget {

  /// The object to edit.
  late GameObject object;

  /// The callback function to update the object.
  final Function(GameObject) updateAsset;

  /// All the media of the game.
  List<Media> medias;

  AssetEditorPage({super.key, required this.object, required this.updateAsset, required this.medias});

  @override
  State<StatefulWidget> createState() {
    return _ObjectEditorPageState();
  }
}

class _ObjectEditorPageState extends State<AssetEditorPage> {
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
      widget.object.components.add(instance);
      widget.updateAsset(widget.object);
    });
  }

  /// Remove a [component] from the object.
  ///
  /// The [component] is removed from the object and the display is updated.
  void removeComponent(ComponentType component) {
    setState(() {
      widget.object.components.remove(component);
      widget.updateAsset(widget.object);
    });
  }

  /// Update a [component] from the object.
  ///
  /// The [component] is updated from the object and the display is updated.
  void updateComponent() {
    setState(() {
      widget.updateAsset(widget.object);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: widget.object.name);

    return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Text('Asset Editor'),
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
                  Text("id : ${widget.object.id}"),
                ],
              ),
              TextField(
                controller: nameController,
                onChanged: (value) {
                  widget.object.name = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                  label: Text('Name'),
                ),
              ),
              const SizedBox(height: 40),
              for (var component in widget.object.components)
                Row(
                  children: [
                    Text(component.name),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditComponentPage(
                              component: component,
                              updateComponent: updateComponent,
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
                builder: (context) => AddComponentPage(
                  onAddComponent: addComponent,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
