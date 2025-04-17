import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game_object.dart' as Plock;
import 'package:plock_mobile/pages/my_games/game_editor/asset_editor_page.dart';

import '../../../models/games/game.dart' as Plock;
import '../../../models/games/game_object_type.dart';
import 'editor/editor_canvas.dart';

/// The page to add a component to an object.
class AssetsPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final Plock.Game game;
  final Function(Plock.GameObject, EditorCanvas) spawnAsset;
  final Function(Plock.GameObject) updateAsset;
  final EditorCanvas canvas;

  const AssetsPage({required this.game, required this.spawnAsset, required this.updateAsset, required this.canvas});

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
    var assets = widget.game.assets;
    if (widget.canvas == EditorCanvas.ui) {
      assets = widget.game.uiAssets;
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Plock.GameObject newAsset = Plock.GameObject(name: "New Asset", id: widget.game.assets.length);
            newAsset.assetId = widget.game.assetCount;
            newAsset.type = GameObjectType.asset;
            if (widget.canvas == EditorCanvas.ui) {
              widget.game.uiAssets.add(newAsset);
            } else {
              widget.game.assets.add(newAsset);
            }
            widget.game.assetCount++;
          });
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (var object in assets)
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(object.name),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      widget.spawnAsset(object, widget.canvas);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AssetEditorPage(object: object, updateAsset: widget.updateAsset, medias: widget.game.medias, canvas: widget.canvas)));
              },
            ),
        ],
      ),
    );
  }
}
