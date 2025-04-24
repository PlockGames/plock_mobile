import 'package:flutter/material.dart';
import 'package:plock_mobile/services/api.dart';
import 'package:plock_mobile/services/auth_service.dart';
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

      final response = await Api.getUserProfile();
      if (response['success']) {
        final Map<String, dynamic> jsonData = json.decode(response['data']);

        if (jsonData['status'] == 'success' ) {
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
        print("Erreur lors de la récupération du profil utilisateur: ${response['message']}");
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }
  void _editField(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    bool isPassword = title == "Mot de passe";

    showDialog(
      context: context,
      builder: (_) {
        bool obscurePassword = true; // Déplacé ici pour garder l'état local

        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Modifier $title',
              style: const TextStyle(color: Colors.white),
            ),
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
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Sélectionner une date",
                    hintStyle: TextStyle(color: Colors.white60),
                    suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF47F8FF)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFFa13a)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF47F8FF), width: 2),
                    ),
                  ),
                ),
              ),
            )
                : TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              obscureText: isPassword ? obscurePassword : false,
              decoration: InputDecoration(
                hintText: title,
                hintStyle: const TextStyle(color: Colors.white60),
                suffixIcon: isPassword
                    ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF47F8FF),
                  ),
                  onPressed: () {
                    setDialogState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
                    : null,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFa13a)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF47F8FF), width: 2),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Annuler',
                  style: TextStyle(color: Color(0xFF47F8FF)), 
                ),
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
                    final response = await Api.updateUserProfile(
                      username: updateData['username'],
                      email: updateData['email'],
                      password: updateData['password'],
                      phoneNumber: updateData['phoneNumber'],
                      birthDate: updateData['birthDate'],
                    );

                    if (response['success']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$title mis à jour avec succès')));
                      _fetchUserProfile();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur: ${response['message']}')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur: $e')));
                  }

                  Navigator.pop(context);
                },
                child: const Text(
                  'Enregistrer',
                  style: TextStyle(color: Color(0xFFFA6317)), 
                ),
              ),
            ],
          ),
        );
      },
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

  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                  child: profileImage == null ? const Icon(Icons.person, size: 50, color: Color(0xFF47F8FF)) : null,
                ),
              ),
              const SizedBox(height: 20),

              _buildEditableField("Nom d'utilisateur", username, (value) => username = value),
              _buildEditableField("Email", email, (value) => email = value),
              _buildEditableField("Mot de passe", "********", (value) => password = value),

              _buildEditableField("Téléphone", phone, (value) => phone = value),
              _buildEditableField("Date de naissance", dateOfBirth, (value) => dateOfBirth = value),
              
              const SizedBox(height: 40),
              
              // Bouton de déconnexion en bas de la page
              ElevatedButton.icon(
                onPressed: () async {
                  await authService.logout();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Se déconnecter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6317),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String title, String value, Function(String) onSave) {
    return ListTile(
      title: Text(
        title, 
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )
      ),
      subtitle: Text(
        value.isNotEmpty ? value : "Non défini",
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.edit,
          color: Color(0xFFFFa13a),
        ),
        onPressed: () => _editField(title, value, onSave),
      ),
    );
  }
}
