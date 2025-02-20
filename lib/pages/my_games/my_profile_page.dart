import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = "John";
  String lastName = "Doe";
  String email = "johndoe@example.com";
  String password = "********";
  String phone = "1234567890";
  String dateOfBirth = "01/01/2000";
  String username = "johndoe";
  File? profileImage;

  void _editField(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Modifier $title'),
        content: TextFormField(
          controller: controller,
          obscureText: title == "Mot de passe",
          decoration: InputDecoration(hintText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                onSave(controller.text);
              });
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Colors.grey[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                  child: profileImage == null ? const Icon(Icons.person, size: 50) : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildEditableField("Prénom", firstName, (value) => firstName = value),
              _buildEditableField("Nom", lastName, (value) => lastName = value),
              _buildEditableField("Nom d'utilisateur", username, (value) => username = value),
              _buildEditableField("Email", email, (value) => email = value),
              _buildEditableField("Mot de passe", password, (value) => password = value),
              _buildEditableField("Téléphone", phone, (value) => phone = value),
              _buildEditableField("Date de naissance", dateOfBirth, (value) => dateOfBirth = value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String title, String value, Function(String) onSave) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editField(title, value, onSave),
      ),
    );
  }
}
