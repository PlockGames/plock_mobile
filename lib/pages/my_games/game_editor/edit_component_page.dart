import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/games/component_type.dart';
import '../../../models/games/media.dart';

/// The page to edit a component.
class EditComponentPage extends StatefulWidget {

  /// The component to edit.
  final ComponentType component;

  /// Is component in debug mode ?
  final bool debug;

  /// The callback function to update the component. optional
  final Function()? updateComponent;

  /// All the media of the game.
  List<Media> medias;

  EditComponentPage({super.key, required this.component, this.debug = false, this.updateComponent, required this.medias});

  @override
  _EditComponentPageState createState() => _EditComponentPageState();

  dynamic getDebugData() {
    return component.debugData;
  }
}

class _EditComponentPageState extends State<EditComponentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    for (var pair in widget.component.fields.entries) {
      if (widget.updateComponent != null) {
        Function? update = pair.value.onUpdate;
        pair.value.onUpdate = () {
          if (update != null) {
            update();
          }
          widget.updateComponent!();
        };
      }
    }

    if (widget.component.isScrollable) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit ${widget.component.name}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.component.fields.entries.length,
                  itemBuilder: (context, index) {
                    final field = widget.component.fields.entries.elementAt(
                        index);
                    return field.value.getField(
                        field.key, widget.debug, widget.medias,
                        widget.component.fields);
                  },
                ),
              ),

            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit ${widget.component.name}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var pair in widget.component.fields.entries)
                pair.value.getField(pair.key, widget.debug, widget.medias,
                    widget.component.fields),
            ],
          ),
        ),
      );
    }


  }
}
