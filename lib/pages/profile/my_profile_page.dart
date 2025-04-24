import 'package:flutter/material.dart';
import 'package:plock_mobile/services/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/theme.dart'; // Importer le thème
import 'dart:io';
import 'dart:convert';
import 'package:plock_mobile/widgets/loading_logo_animation.dart'; // Importer le widget de chargement

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
  String? profilePicUrl;
  File? profileImage;
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.getUserProfile();
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          final userData = jsonData['data'];
          setState(() {
            email = userData['email'] ?? "";
            phone = userData['phoneNumber'] ?? "";
            username = userData['username'] ?? "";
            profilePicUrl =
                userData['pofilePic']; // Note the typo in API field name
            dateOfBirth = userData['birthDate'] ?? "";
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackbar("Failed to load profile data");
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar("Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar("Network error: $e");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: PlockTheme.errorColor, // Utiliser errorColor du thème
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: PlockTheme.primaryOrange, // Utiliser primaryOrange comme couleur de succès/accent
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _editField(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    bool isPassword = title == "Password";
    bool obscurePassword = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit $title',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                title == "Date of Birth"
                    ? InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: currentValue.isNotEmpty
                                ? _parseDate(currentValue)
                                : DateTime.now()
                                    .subtract(const Duration(days: 365 * 18)),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: PlockTheme.secondaryBlue, // Utiliser secondaryBlue
                                    onPrimary: Colors.black, // Texte sur bleu clair (noir pour contraste)
                                    surface: PlockTheme.backgroundLight, // Utiliser backgroundLight
                                    onSurface: PlockTheme.textPrimary, // Utiliser textPrimary
                                  ),
                                  dialogBackgroundColor: PlockTheme.backgroundLight, // Utiliser backgroundLight
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            String formattedDate = "${pickedDate.year}-"
                                "${pickedDate.month.toString().padLeft(2, '0')}-"
                                "${pickedDate.day.toString().padLeft(2, '0')}";
                            setModalState(() {
                              controller.text = formattedDate;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: PlockTheme.cardColor, // Utiliser cardColor
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  controller.text.isNotEmpty
                                      ? _formatDate(controller.text)
                                      : "Select date of birth",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: controller.text.isNotEmpty
                                        ? PlockTheme.textPrimary // Utiliser textPrimary
                                        : PlockTheme.textMuted, // Utiliser textMuted
                                  ),
                                ),
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      )
                    : TextField(
                        controller: controller,
                        obscureText: isPassword ? obscurePassword : false,
                        style: const TextStyle(fontSize: 16, color: PlockTheme.textPrimary), // Assurer la couleur du texte
                        decoration: InputDecoration(
                          hintText: "Enter your $title",
                          filled: true,
                          fillColor: PlockTheme.cardColor, // Utiliser cardColor
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: isPassword
                              ? IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setModalState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: PlockTheme.textSecondary, // Utiliser textSecondary
                      ),
                      child: const Text('CANCEL'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _updateField(title, controller.text, onSave);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: PlockTheme.textOnPrimaryOrange, // Utiliser textOnPrimaryOrange
                        backgroundColor: PlockTheme.primaryOrange, // Utiliser primaryOrange
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('SAVE'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime _parseDate(String dateStr) {
    try {
      // Try parsing ISO format (YYYY-MM-DD)
      return DateTime.parse(dateStr);
    } catch (e) {
      try {
        // Try parsing DD/MM/YYYY format
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      } catch (_) {}

      // Return default date if parsing fails
      return DateTime.now().subtract(const Duration(days: 365 * 18));
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return isoDate; // Return original if parsing fails
    }
  }

  Future<void> _updateField(
      String title, String value, Function(String) onSave) async {
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    // Définition des données à mettre à jour
    Map<String, String?> updateData = {};

    switch (title) {
      case "Username":
        updateData['username'] = value;
        break;
      case "Email":
        updateData['email'] = value;
        break;
      case "Password":
        updateData['password'] = value;
        break;
      case "Phone Number":
        updateData['phoneNumber'] = value;
        break;
      case "Date of Birth":
        updateData['birthDate'] = value;
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
        // Update the local state
        onSave(value);

        // Show success message
        _showSuccessSnackbar("$title updated successfully");

        // Refresh profile data
        await _fetchUserProfile();
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar("Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar("Error: $e");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _imagePickerButton(
                      context,
                      'Camera',
                      Icons.camera_alt,
                      () async {
                        Navigator.pop(context);
                        final XFile? photo =
                            await picker.pickImage(source: ImageSource.camera);
                        if (photo != null) {
                          setState(() {
                            profileImage = File(photo.path);
                          });
                          // TODO: Implement upload of profile image to server
                          _showSuccessSnackbar("Profile picture updated");
                        }
                      },
                    ),
                    _imagePickerButton(
                      context,
                      'Gallery',
                      Icons.photo_library,
                      () async {
                        Navigator.pop(context);
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            profileImage = File(image.path);
                          });
                          // TODO: Implement upload of profile image to server
                          _showSuccessSnackbar("Profile picture updated");
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imagePickerButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: PlockTheme.primaryOrange, // Utiliser primaryOrange
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: PlockTheme.textOnPrimaryOrange, // Utiliser textOnPrimaryOrange
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PlockTheme.backgroundDark, // Utiliser backgroundDark
      // AppBar retirée
      body: _isLoading
          ? const LoadingLogoAnimation() // Utiliser l'animation du logo
          : RefreshIndicator(
              onRefresh: _fetchUserProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    bottom:
                        100), // Added bottom padding to prevent overlap with nav bar
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      _buildProfileHeader(),
                      const SizedBox(height: 40),
                      _buildInfoCard(),
                      const SizedBox(height: 24), // Added extra bottom spacing
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Hero(
              tag: 'profile-image',
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PlockTheme.cardColor, // Utiliser cardColor
                  border: Border.all(
                    color: PlockTheme.primaryOrange, // Utiliser primaryOrange
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: PlockTheme.backgroundDark.withOpacity(0.5), // Ombre plus subtile
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  image: profileImage != null
                      ? DecorationImage(
                          image: FileImage(profileImage!),
                          fit: BoxFit.cover,
                        )
                      : profilePicUrl != null
                          ? DecorationImage(
                              image: NetworkImage(profilePicUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: (profileImage == null && profilePicUrl == null)
                    ? Center(
                        child: Text(
                          username.isNotEmpty ? username[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: PlockTheme.textPrimary, // Utiliser textPrimary
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: PlockTheme.primaryOrange, // Utiliser primaryOrange
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: PlockTheme.backgroundDark.withOpacity(0.5), // Ombre plus subtile
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: PlockTheme.textOnPrimaryOrange, // Utiliser textOnPrimaryOrange
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          username,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(
            fontSize: 16,
            color: PlockTheme.textMuted, // Utiliser textMuted
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: PlockTheme.backgroundLight, // Utiliser backgroundLight
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: PlockTheme.backgroundDark.withOpacity(0.3), // Ombre plus subtile
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileItem(
            title: "Username",
            value: username,
            icon: Icons.person,
            onTap: () =>
                _editField("Username", username, (value) => username = value),
          ),
          _buildDivider(),
          _buildProfileItem(
            title: "Email",
            value: email,
            icon: Icons.email,
            onTap: () => _editField("Email", email, (value) => email = value),
          ),
          _buildDivider(),
          _buildProfileItem(
            title: "Password",
            value: "••••••••",
            icon: Icons.lock,
            onTap: () =>
                _editField("Password", "", (value) => password = value),
          ),
          _buildDivider(),
          _buildProfileItem(
            title: "Phone Number",
            value: phone.isNotEmpty ? phone : "Not set",
            icon: Icons.phone,
            onTap: () =>
                _editField("Phone Number", phone, (value) => phone = value),
          ),
          _buildDivider(),
          _buildProfileItem(
            title: "Date of Birth",
            value:
                dateOfBirth.isNotEmpty ? _formatDate(dateOfBirth) : "Not set",
            icon: Icons.cake,
            onTap: () => _editField(
                "Date of Birth", dateOfBirth, (value) => dateOfBirth = value),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isValueSet = value.isNotEmpty && value != "Not set";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: PlockTheme.primaryOrange.withOpacity(0.2), // Utiliser primaryOrange
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: PlockTheme.primaryOrange, // Utiliser primaryOrange
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: PlockTheme.textMuted, // Utiliser textMuted
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isValueSet ? PlockTheme.textPrimary : PlockTheme.textMuted, // Utiliser textPrimary ou textMuted
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.edit,
              color: PlockTheme.primaryOrange, // Utiliser primaryOrange
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: PlockTheme.dividerColor, // Utiliser dividerColor
      height: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
