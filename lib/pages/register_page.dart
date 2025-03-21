import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  final AuthService? authService;

  const RegisterPage({super.key, this.authService});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final usernameController = TextEditingController();
  late final AuthService authService;

  bool _isLoading = false;
  String _debugInfo = '';

  final firstNameKey = const Key('firstNameField');
  final lastNameKey = const Key('lastNameField');
  final emailKey = const Key('emailField');
  final passwordKey = const Key('passwordField');
  final phoneKey = const Key('phoneField');
  final dateOfBirthKey = const Key('dateOfBirthField');
  final usernameKey = const Key('usernameField');

  @override
  void initState() {
    super.initState();
    authService = widget.authService ?? AuthService();
  }

  void _updateDebugInfo(String info) {
    setState(() {
      _debugInfo += "\n$info";
      print("DEBUG: $info"); // Affiche aussi dans la console
    });
  }

  Future<void> _registerUser(
      Map<String, String> signupData,
      Map<String, String> completeData,
      ) async {
    try {
      setState(() => _isLoading = true);
      _updateDebugInfo("Étape 1: Démarrage inscription avec: $signupData");

      // Étape 1: Inscription partielle
      final signupResult = await authService.signup(signupData);

      _updateDebugInfo("Résultat étape 1: ${signupResult.toString()}");

      if (signupResult['success']) {
        _updateDebugInfo("Étape 2: Démarrage avec data: $completeData");

        // Étape 2: Compléter l'inscription
        final completeResult = await authService.completeSignup(completeData);

        _updateDebugInfo("Résultat étape 2: ${completeResult.toString()}");

        if (completeResult['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration completed successfully!"),
              duration: Duration(seconds: 2),
            ),
          );

          _updateDebugInfo("Navigation vers /home après inscription réussie");

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
                  (Route<dynamic> route) => false  // Supprime toutes les routes précédentes
          );

        } else {
          _updateDebugInfo("Échec étape 2: ${completeResult['message']}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(completeResult['message']),
            ),
          );
        }
      } else {
        _updateDebugInfo("Échec étape 1: ${signupResult['message']}");

        // Si l'erreur indique que les identifiants sont déjà pris
        if (signupResult['message'].toString().toLowerCase().contains('taken') ||
            signupResult['message'].toString().toLowerCase().contains('exists')) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${signupResult['message']} Vous pouvez essayer de vous connecter."),
              action: SnackBarAction(
                label: 'Se connecter',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(signupResult['message'])),
          );
        }
      }
    } catch (e) {
      _updateDebugInfo("Exception globale: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _validateAndRegister() {
    _updateDebugInfo("--- Nouvelle tentative d'inscription ---");

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();
    final dateOfBirth = dateOfBirthController.text.trim();
    final username = usernameController.text.trim();

    _updateDebugInfo("Données saisies - nom: $firstName, prénom: $lastName, email: $email, username: $username");

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        dateOfBirth.isEmpty ||
        username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All mandatory fields must be filled.")),
      );
      return;
    }

    final emailRegex =
    RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email format.")),
      );
      return;
    }

    final signupData = <String, String>{
      'email': email,
      'password': password,
      'username': username,
      'birthDate': dateOfBirth,
    };

    final completeData = <String, String>{
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phone.isNotEmpty ? phone : ' ',
      'birthDate': dateOfBirth,
    };

    _registerUser(signupData, completeData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Champs pour le débogage
                  if (_debugInfo.isNotEmpty)
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_debugInfo, style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),

                  // Champs du formulaire
                  TextField(
                    key: firstNameKey,
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    key: lastNameKey,
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    key: usernameKey,
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: dateOfBirthKey,
                          controller: dateOfBirthController,
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth (YYYY-MM-DD)',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            final year = pickedDate.year.toString().padLeft(4, '0');
                            final month =
                            pickedDate.month.toString().padLeft(2, '0');
                            final day = pickedDate.day.toString().padLeft(2, '0');
                            dateOfBirthController.text = "$year-$month-$day";
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    key: emailKey,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    key: phoneKey,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (Optional)',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    key: passwordKey,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _validateAndRegister,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Already have an account? Log in'),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
