import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Données brutes pour l'affichage
    final String email = "example@mail.com";
    final String username = "exampleUser";
    final String phoneNumber = "123-456-7890";
    final String firstName = "John";
    final String lastName = "Doe";
    final String birthDate = "01/01/1990";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileField("Nom", lastName),
            _buildProfileField("Prénom", firstName),
            _buildProfileField("Nom d'utilisateur", username),
            _buildProfileField("Email", email),
            _buildProfileField("Numéro de téléphone", phoneNumber),
            _buildProfileField("Date de naissance", birthDate),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Retour à la page `PlayPage`
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Retour"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
