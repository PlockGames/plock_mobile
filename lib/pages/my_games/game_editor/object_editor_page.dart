import 'package:flutter/material.dart';

class ObjectEditorPage extends StatefulWidget {
  const ObjectEditorPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ObjectEditorPageState();
  }
}

class _ObjectEditorPageState extends State<ObjectEditorPage> {
  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Object Editor'),
          ],
        ),
      ),
    );
  }
}