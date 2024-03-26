import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/add_component_page.dart';

import '../../../models/games/component.dart';

class ObjectEditorPage extends StatefulWidget {
  GameObject gameObject = GameObject(name: 'New Object');

  ObjectEditorPage({super.key, required this.gameObject});

  @override
  State<StatefulWidget> createState() {
    return _ObjectEditorPageState();
  }
}

class _ObjectEditorPageState extends State<ObjectEditorPage> {
  GameObject gameObject = GameObject(name: 'New Object');

  @override
  void initState() {
    super.initState();
    gameObject = widget.gameObject;
  }

  void addComponent(Component component) {
    setState(() {
      gameObject.components.add(component);
    });
  }

  void removeComponent(Component component) {
    setState(() {
      gameObject.components.remove(component);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: gameObject.name);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            BackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Text('Object Editor'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              onChanged: (value) {
                gameObject.name = value;
              },
              decoration: const InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(),
                label: Text('Name'),
              ),
            ),
            const SizedBox(height: 40),
            for (var component in gameObject.components)
              Row(
                children: [
                  Text(component.name),
                  const Spacer(),
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
      )
    );
  }
}