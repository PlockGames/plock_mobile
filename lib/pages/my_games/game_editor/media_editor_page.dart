import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_page.dart';

/// The page to add a component to an object.
class MediaEditorPage extends StatefulWidget {
  Media media;

  /// A callback function to convert the media to a media set.
  final Function(Media media) toSet;

  MediaEditorPage({super.key, required this.media, required this.toSet});

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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PaintPage()));
        },
        child: const Icon(Icons.brush),
      ),
      body: Scrollable(
        controller: ScrollController(),
        axisDirection: AxisDirection.down,
        viewportBuilder: (context, position) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
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
                ElevatedButton(
                    onPressed: () async {
                      final XFile? image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {
                        widget.media.file = image;
                      });
                    },
                    child: const Text("Pick Image")),
                widget.media.file == null
                    ? const Text("No image selected")
                    : Image.file(File(widget.media.file!.path)),
                const SizedBox(height: 40),
                if (widget.media is MediaSet)
                  Column(
                    children: [
                      Row(children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              (widget.media as MediaSet).tileWidth =
                                  int.parse(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Tile Width',
                              border: OutlineInputBorder(),
                              label: Text('Tile Width'),
                            ),
                            controller: TextEditingController(
                                text: (widget.media as MediaSet)
                                    .tileWidth
                                    .toString()),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              (widget.media as MediaSet).tileHeight =
                                  int.parse(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Tile Height',
                              border: OutlineInputBorder(),
                              label: Text('Tile Height'),
                            ),
                            controller: TextEditingController(
                                text: (widget.media as MediaSet)
                                    .tileHeight
                                    .toString()),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      Row(children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              (widget.media as MediaSet).offsetX =
                                  int.parse(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Offset X',
                              border: OutlineInputBorder(),
                              label: Text('Offset X'),
                            ),
                            controller: TextEditingController(
                                text: (widget.media as MediaSet)
                                    .offsetX
                                    .toString()),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              (widget.media as MediaSet).offsetY =
                                  int.parse(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Offset Y',
                              border: OutlineInputBorder(),
                              label: Text('Offset Y'),
                            ),
                            controller: TextEditingController(
                                text: (widget.media as MediaSet)
                                    .offsetY
                                    .toString()),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      Row(children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              (widget.media as MediaSet).gapX =
                                  int.parse(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Gap X',
                              border: OutlineInputBorder(),
                              label: Text('Gap X'),
                            ),
                            controller: TextEditingController(
                                text:
                                    (widget.media as MediaSet).gapX.toString()),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              (widget.media as MediaSet).gapY =
                                  int.parse(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Gap Y',
                              border: OutlineInputBorder(),
                              label: Text('Gap Y'),
                            ),
                            controller: TextEditingController(
                                text:
                                    (widget.media as MediaSet).gapY.toString()),
                          ),
                        ),
                      ]),
                    ],
                  )
                else
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        widget.media = widget.toSet(widget.media);
                      });
                    },
                    child: const Text('Convert To Tileset'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
