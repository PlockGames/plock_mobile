import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();

    // Contrôleur pour afficher la date sélectionnée dans le champ
    final dateOfBirthController = TextEditingController();
    void _validateAndRegister() {
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String phone = phoneController.text.trim();
      String dateOfBirth = dateOfBirthController.text.trim();

      // Validation des erreurs
      String? errorMessage;

      // Vérifier que tous les champs obligatoires sont remplis
      if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || dateOfBirth.isEmpty) {
        errorMessage = "All mandatory fields must be filled.";
      }

      // Vérification du format de l'adresse e-mail
      final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
      if (!emailRegex.hasMatch(email)) {
        errorMessage = "Invalid email format.";
      }

      // Vérification du format de la date de naissance
      final dateRegex = RegExp(r"^\d{4}-\d{2}-\d{2}$"); // Format YYYY-MM-DD
      if (!dateRegex.hasMatch(dateOfBirth)) {
        errorMessage = "Invalid date format. Use YYYY-MM-DD.";
      } else {
        // Vérifier si la date est valide
        try {
          DateTime.parse(dateOfBirth); // Lève une exception si invalide
        } catch (e) {
          errorMessage = "Invalid date.";
        }
      }

      // Afficher une erreur ou procéder à l'inscription
      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } else {
        // Procéder à l'inscription (logique à implémenter)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),
        );
        Navigator.pop(context); // Retour à la page précédente
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  // Affiche le date picker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  // Si une date est sélectionnée, mettre à jour le contrôleur
                  if (pickedDate != null) {
                    dateOfBirthController.text =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: dateOfBirthController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (Optional)',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateAndRegister,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
