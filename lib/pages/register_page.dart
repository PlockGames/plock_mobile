import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plock_mobile/theme.dart';
import '../services/auth_service.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final AuthService? authService;

  const RegisterPage({super.key, this.authService});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final usernameController = TextEditingController();

  // Form keys for validation
  final _formKey = GlobalKey<FormState>();

  // UI state
  bool _isLoading = false;
  bool _obscurePassword = true;
  DateTime? _selectedDate;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  AuthService get authService => widget.authService ?? AuthService();

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  // Pick date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.dark(
          primary: PlockTheme.secondaryBlue, // Utiliser secondaryBlue comme accent
          onPrimary: Colors.black, // Texte sur bleu clair (noir pour contraste)
          surface: PlockTheme.cardColor,
          onSurface: PlockTheme.textPrimary,
            ),
            dialogBackgroundColor: PlockTheme.backgroundLight,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        final year = picked.year.toString().padLeft(4, '0');
        final month = picked.month.toString().padLeft(2, '0');
        final day = picked.day.toString().padLeft(2, '0');
        dateOfBirthController.text = "$year-$month-$day";
      });
    }
  }

  // Submit form and register user
  Future<void> _validateAndRegister() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Show loading indicator
    setState(() => _isLoading = true);

    final signupData = <String, String>{
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'username': usernameController.text.trim(),
      'birthDate': dateOfBirthController.text.trim(),
    };

    final completeData = <String, String>{
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'phoneNumber': phoneController.text.trim().isNotEmpty
          ? phoneController.text.trim()
          : ' ',
      'birthDate': dateOfBirthController.text.trim(),
    };

    try {
      // Étape 1: Inscription partielle
      final signupResult = await authService.signup(signupData);

      if (signupResult['success']) {
        // Étape 2: Compléter l'inscription
        final completeResult = await authService.completeSignup(completeData);

        if (completeResult['success']) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Registration completed successfully!"),
                backgroundColor: PlockTheme.primaryOrange, // Utiliser primaryOrange comme accent
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                duration: const Duration(seconds: 2),
              ),
            );
          }

          // Navigate to home
          if (mounted) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', (route) => false);
          }
        } else {
          // Show error message for step 2
          if (mounted) {
            _showErrorSnackbar(completeResult['message']);
          }
        }
      } else {
        // Handle existing account
        if (mounted) {
          if (signupResult['message']
                  .toString()
                  .toLowerCase()
                  .contains('taken') ||
              signupResult['message']
                  .toString()
                  .toLowerCase()
                  .contains('exists')) {
            _showAlreadyExistsDialog(signupResult['message']);
          } else {
            // Show other error
            _showErrorSnackbar(signupResult['message']);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar("Registration failed: $e");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: PlockTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Show dialog for existing account
  void _showAlreadyExistsDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Already Exists'),
        content: Text('$message\nWould you like to log in instead?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('LOG IN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlockTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PlockTheme.backgroundDark,
                  PlockTheme.primaryBlue.withOpacity(0.5), // Utiliser la couleur du thème
                ],
              ),
            ),
          ),

          // Form
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Join Plock',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create, play, and share games with the community',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Username field
                      _buildFormField(
                        controller: usernameController,
                        label: 'Username',
                        hint: 'Choose a unique username',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username is required';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Name fields - side by side
                      Row(
                        children: [
                          // First name
                          Expanded(
                            child: _buildFormField(
                              controller: firstNameController,
                              label: 'First Name',
                              hint: 'Enter first name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'First name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Last name
                          Expanded(
                            child: _buildFormField(
                              controller: lastNameController,
                              label: 'Last Name',
                              hint: 'Enter last name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Last name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      _buildFormField(
                        controller: emailController,
                        label: 'Email',
                        hint: 'Enter your email address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }

                          final emailRegex = RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date of birth field
                      _buildDateField(
                        controller: dateOfBirthController,
                        label: 'Date of Birth',
                        hint: 'YYYY-MM-DD',
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Date of birth is required';
                          }
                          // Basic date format validation
                          final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                          if (!dateRegex.hasMatch(value)) {
                            return 'Use format: YYYY-MM-DD';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone field (optional)
                      _buildFormField(
                        controller: phoneController,
                        label: 'Phone Number (Optional)',
                        hint: 'Enter your phone number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        // No validator as this field is optional
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Create a secure password',
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.white70),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: TextStyle(color: PlockTheme.errorColor),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Register button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _validateAndRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PlockTheme.primaryOrange, // Utiliser primaryOrange
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor:
                                PlockTheme.primaryOrange.withOpacity(0.5), // Utiliser primaryOrange
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'CREATE ACCOUNT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login link
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    color: PlockTheme.primaryOrange, // Utiliser primaryOrange
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Standard form field builder
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: TextStyle(color: PlockTheme.errorColor),
      ),
    );
  }

  // Date field with picker
  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: TextStyle(color: PlockTheme.errorColor),
      ),
    );
  }
}
