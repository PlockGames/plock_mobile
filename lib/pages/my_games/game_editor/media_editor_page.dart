import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_page.dart';

/// The page to add a component to an object.
class MediaEditorPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final Media media;

  const MediaEditorPage({super.key, required this.media});

  @override
  _MediasPageState createState() => _MediasPageState();
}

class _MediasPageState extends State<MediaEditorPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
    TextEditingController(text: widget.media.name);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Editor'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PaintPage()));
        },
        child: const Icon(Icons.brush),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("id : ${widget.media.id}"),
              ],
            ),
            TextField(
              controller: nameController,
              onChanged: (value) {
                widget.media.name = value;
              },
              decoration: const InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(),
                label: Text('Name'),
              ),
            ),
            const SizedBox(height: 40),
            TextButton(onPressed: () async {
              final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
              setState(() {
                widget.media.file = image;
              });
            },child: const Text("Pick Image")),
            widget.media.file == null ? const Text("No image selected") : Image.file(File(widget.media.file!.path)),
          ],
        ),
      ),
    );
  }
}
