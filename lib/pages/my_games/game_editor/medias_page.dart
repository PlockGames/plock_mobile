import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_scene_component.dart';

import '../../../models/games/component_type.dart';
import '../../../models/games/media.dart';
import 'media_editor_page.dart';

/// The page to add a component to an object.
class MediasPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final Game game;

  const MediasPage({super.key, required this.game});

  @override
  _MediasPageState createState() => _MediasPageState();
}

class _MediasPageState extends State<MediasPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Uint8List>> getImages(List<Media> files) async {
    List<Uint8List> images = [];
    for (var media in files) {
      if (media.file != null) {
        var image = await media.file!.readAsBytes();
        images.add(image);
      }
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {

    Future<List<Uint8List>> images = getImages(widget.game.medias);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medias'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget.game.medias.add(Media(id: widget.game.medias.length ,name: 'New Media'));
          });
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          FutureBuilder(future: images, builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  for (var media in widget.game.medias)
                    ListTile(
                      title: Row(
                        children: [
                          if (media.file != null)
                            Image.memory(
                              snapshot.data![media.id],
                              width: 50,
                              height: 50,
                            ),
                          Expanded(
                            child: Text(media.name),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MediaEditorPage(
                              media: media,
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.game.medias.remove(media);
                          });
                        },
                      ),
                    ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
        ],
      ),
    );
  }
}
