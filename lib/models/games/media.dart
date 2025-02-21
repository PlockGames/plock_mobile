import 'package:image_picker/image_picker.dart';

class Media {
  final int id;
  String name;
  XFile? file;

  Media({
    required this.id,
    required this.name,
    this.file,
  });

  Media instance() {
    return Media(
      id: id,
      name: name,
      file: file,
    );
  }
}