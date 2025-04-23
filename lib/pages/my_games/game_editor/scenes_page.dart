import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/games/scene.dart';

/// The page to add a component to an object.
class ScenesPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final List<Scene> scenes;
  final Function(Scene) changeScene;
  final Function(Scene) removeScene;
  final int selectedScene;

  const ScenesPage({super.key, required this.scenes, required this.changeScene, required this.removeScene, required this.selectedScene});

  @override
  _AddComponentPageState createState() => _AddComponentPageState();
}

class _AddComponentPageState extends State<ScenesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objects'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // show a dialog to add a new scene
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final TextEditingController controller = TextEditingController();
              return AlertDialog(
                title: const Text('Add scene'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Scene name'),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.scenes.add(Scene(name: controller.text));
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (var scene in widget.scenes)
            ListTile(
              title: Row(
                children: [
                  Text(scene.name),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      if (widget.selectedScene == widget.scenes.indexOf(scene)) {
                        // show a dialog that ask the user to change the scene before deleting it
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete scene'),
                              content: const Text('You are about to delete the current scene. Please change the scene before deleting it.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );

                      } else {
                        setState(() {
                          widget.removeScene(scene);
                          widget.scenes.remove(scene);
                        });
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                widget.changeScene(scene);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
