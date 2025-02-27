import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';

class TilemapEditorPage extends StatefulWidget {
  final Tilemap tilemap;
  final Function? onUpdate;

  TilemapEditorPage({required this.tilemap, required this.onUpdate});

  @override
  _SpriteEditorPageState createState() => _SpriteEditorPageState();
}

class _SpriteEditorPageState extends State<TilemapEditorPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Tilemap Editor'),
        ),
        body: Column(
          children: [

          ],
        )
    );
  }
}