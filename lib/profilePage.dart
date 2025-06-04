import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();

    _showLoadingThenLoadProfile();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _showLoadingThenLoadProfile() async {
    await Future.delayed(Duration(milliseconds: 1500));
    await loadProfileFromPrefs();
  }

  Future<void> loadProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      firstNameController.text = prefs.getString('first_name') ?? '';
      lastNameController.text = prefs.getString('last_name') ?? '';
      emailController.text = prefs.getString('user_email') ?? '';
      phoneController.text = prefs.getString('user_phone') ?? '';
      addressController.text = prefs.getString('user_address') ?? '';
      _isLoading = false;
    });
  }

  Future<void> saveProfileToPrefs() async {
    setState(() {
      _isSaving = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', firstNameController.text.trim());
    await prefs.setString('last_name', lastNameController.text.trim());
    await prefs.setString('user_email', emailController.text.trim());
    await prefs.setString('user_phone', phoneController.text.trim());
    await prefs.setString('user_address', addressController.text.trim());

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profile saved successfully!')));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget buildEditableField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF2196F3)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF333333),
          fontWeight: FontWeight.w600,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF2196F3),
            strokeWidth: 4,
          ),
        ),
      );

    return Scaffold(
      backgroundColor: Color(0xFFFEF7FF),
      appBar: AppBar(
        title: Text('My Profile', style: GoogleFonts.cairo(fontSize: 22,fontWeight: FontWeight.bold,color: Color(0xFF2196F3))),
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3',
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                  SizedBox(height: 20),

                  buildEditableField('First Name', firstNameController),
                  buildEditableField('Last Name', lastNameController),
                  buildEditableField(
                    'Email',
                    emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  buildEditableField(
                    'Phone',
                    phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  buildEditableField('Address', addressController),

                  SizedBox(height: 20),

                  _isSaving
                      ? CircularProgressIndicator(color: Color(0xFF2196F3))
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                saveProfileToPrefs();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2196F3),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'Save',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                  SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
