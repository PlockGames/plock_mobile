import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game_object.dart' as Plock;
import 'package:plock_mobile/pages/my_games/game_editor/asset_editor_page.dart';

import '../../../models/games/game.dart' as Plock;
import '../../../models/games/game_object_type.dart';

/// The page to add a component to an object.
class AssetsPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final Plock.Game game;
  final Function(Plock.GameObject) spawnAsset;
  final Function(Plock.GameObject) updateAsset;

  const AssetsPage({required this.game, required this.spawnAsset, required this.updateAsset});

  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Plock.GameObject newAsset = Plock.GameObject(name: "New Asset", id: widget.game.assets.length);
            newAsset.assetId = widget.game.assets.length;
            newAsset.type = GameObjectType.asset;
            widget.game.assets.add(newAsset);
          });
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (var object in widget.game.assets)
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(object.name),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      widget.spawnAsset(object);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AssetEditorPage(object: object, updateAsset: widget.updateAsset, medias: widget.game.medias)));
              },
            ),
        ],
      ),
    );
  }
}
