import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

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

  @override
  Widget build(BuildContext context) {
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
          for (var media in widget.game.medias)
            ListTile(
              title: Text(media.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaEditorPage(media: media),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
