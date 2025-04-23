import 'package:flutter/material.dart';
import 'package:plock_mobile/services/api.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = "";
  String password = "********";
  String phone = "";
  String dateOfBirth = "";
  String username = "";
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      print("Fetching user profile...");

      final response = await ApiService.getUserProfile();
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final userData = jsonData['data'];
          print("------");
          setState(() {
            email = userData['email'] ?? "";
            phone = userData['phoneNumber'] ?? "";
            username = userData['username'] ?? "";
            // Formater la date de naissance si elle existe
            dateOfBirth = userData['birthDate'];
          });

          print("Profil utilisateur chargé avec succès");
        }
      } else {
        // Gestion des erreurs
        print(
            "Erreur lors de la récupération du profil utilisateur: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }

  void _editField(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    bool isPassword = title == "Mot de passe";

    showDialog(
      context: context,
      builder: (_) {
        bool obscurePassword = true; // Déplacé ici pour garder l'état local

        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text('Modifier $title'),
            content: title == "Date de naissance"
                ? InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.day.toString().padLeft(2, '0')}/"
                            "${pickedDate.month.toString().padLeft(2, '0')}/"
                            "${pickedDate.year}";
                        setDialogState(() {
                          controller.text = formattedDate;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Sélectionner une date",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  )
                : TextFormField(
                    controller: controller,
                    obscureText: isPassword ? obscurePassword : false,
                    decoration: InputDecoration(
                      hintText: title,
                      suffixIcon: isPassword
                          ? IconButton(
                              icon: Icon(obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setDialogState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            )
                          : null,
                    ),
                  ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () async {
                  onSave(controller.text);

                  // Définition des données à mettre à jour
                  Map<String, String?> updateData = {};

                  switch (title) {
                    case "Nom d'utilisateur":
                      updateData['username'] = controller.text;
                      break;
                    case "Email":
                      updateData['email'] = controller.text;
                      break;
                    case "Mot de passe":
                      updateData['password'] = controller.text;
                      break;
                    case "Téléphone":
                      updateData['phoneNumber'] = controller.text;
                      break;
                    case "Date de naissance":
                      if (controller.text.isNotEmpty) {
                        final parts = controller.text.split('/');
                        if (parts.length == 3) {
                          updateData['birthDate'] =
                              "${parts[2]}-${parts[1]}-${parts[0]}";
                        }
                      }
                      break;
                  }

                  // Mise à jour via l'API
                  try {
                    final response = await ApiService.updateUserProfile(
                      username: updateData['username'],
                      email: updateData['email'],
                      password: updateData['password'],
                      phoneNumber: updateData['phoneNumber'],
                      birthDate: updateData['birthDate'],
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('$title mis à jour avec succès')));
                      _fetchUserProfile();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Erreur: ${response.statusCode}')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Erreur: $e')));
                  }

                  Navigator.pop(context);
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
                  backgroundImage:
                      profileImage != null ? FileImage(profileImage!) : null,
                  child: profileImage == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildEditableField(
                  "Nom d'utilisateur", username, (value) => username = value),
              _buildEditableField("Email", email, (value) => email = value),
              _buildEditableField(
                  "Mot de passe", "********", (value) => password = value),
              _buildEditableField("Téléphone", phone, (value) => phone = value),
              _buildEditableField("Date de naissance", dateOfBirth,
                  (value) => dateOfBirth = value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
      String title, String value, Function(String) onSave) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value.isNotEmpty
          ? value
          : "Non défini"), // Default to "Non défini" if the value is empty
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editField(title, value, onSave),
      ),
    );
  }
}
