import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Données brutes
    final String email = "example@mail.com";
    final String username = "exampleUser";
    final String phoneNumber = "123-456-7890";
    final String firstName = "John";
    final String lastName = "Doe";
    final String birthDate = "01/01/1990";

    return Padding(
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
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}