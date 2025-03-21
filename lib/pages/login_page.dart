import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final AuthService? authService;

  const LoginPage({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final _authService = authService ?? AuthService();

    // Function to validate inputs and trigger login
    void _validateAndLogin() async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String? errorMessage;

      // Check if email and password are provided
      if (email.isEmpty || password.isEmpty) {
        errorMessage = "Email and password are required.";
      }

      // Validate email format
      final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
      if (email.isNotEmpty && !emailRegex.hasMatch(email)) {
        errorMessage = "Invalid email format.";
      }

      if (errorMessage != null) {
        // Show validation error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        return;
      }

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logging in...")),
      );

      // Proceed with login using AuthService
      final result = await _authService.login(email, password);

      if (result['success']) {
        // Navigate to home page
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        // Show error message
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar() // Cacher le SnackBar "Logging in..." d'abord
          ..showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateAndLogin,
              child: const Text('Log In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
