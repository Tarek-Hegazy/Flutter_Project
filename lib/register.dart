import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  DateTime? _selectedDate;
  String? _gender;
  File? _profileImage; 

  final Color backgroundColor = Color(0xFFE8F3F9); 
  final Color primaryColor = Color(0xFF005DAA); 
  final Color secondaryColor = Color(0xFF74B3CE);
  final Color inputFillColor = Colors.white;
  final Color textColor = Colors.black87;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() => _profileImage = File(pickedImage.path));
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Passwords do not match')));
        return;
      }

      if (_gender == null || _selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please complete all required fields')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final fullName = _fullNameController.text.trim().split(" ");
        final firstName = fullName.isNotEmpty ? fullName.first : "";
        final lastName = fullName.length > 1
            ? fullName.sublist(1).join(" ")
            : "";

        final uri = Uri.parse('https://ib.jamalmoallart.com/api/v2/register');
        final request = http.MultipartRequest('POST', uri);

        request.headers['Accept'] = 'application/json';

        request.fields['first_name'] = firstName;
        request.fields['last_name'] = lastName;
        request.fields['phone'] = _phoneController.text;
        request.fields['address'] = _addressController.text;
        request.fields['email'] = _emailController.text;
        request.fields['password'] = _passwordController.text;

        if (_profileImage != null) {
          request.files.add(
            await http.MultipartFile.fromPath('image', _profileImage!.path),
          );
        }

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final responseData = json.decode(responseBody);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful! Please login.')),
          );
          Navigator.pop(context);
        } else {
          final error = responseData['message'] ?? 'Registration failed.';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF2196F3),
        title: Text('Register', style: GoogleFonts.cairo(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    if (_profileImage != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_profileImage!),
                      ),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image, color: Color(0xFF2196F3)),
                      label: Text(
                        'Choose Profile Image (optional)',
                        style: TextStyle(color: Color(0xFF2196F3)),
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildTextField(_fullNameController, 'Full Name'),
                    _buildTextField(_emailController, 'Email'),
                    _buildTextField(_phoneController, 'Phone'),
                    _buildTextField(_addressController, 'Address'),
                    _buildTextField(
                      _passwordController,
                      'Password',
                      isPassword: true,
                    ),
                    _buildTextField(
                      _confirmPasswordController,
                      'Confirm Password',
                      isPassword: true,
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      title: Text(
                        _selectedDate == null
                            ? 'Select Birthdate'
                            : 'Birthdate: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: Icon(
                        Icons.calendar_today,
                        color: Color(0xFF2196F3),
                      ),
                      onTap: _pickDate,
                    ),
                    ListTile(
                      title: Text('Gender'),
                      subtitle: Row(
                        children: [
                          Radio<String>(
                            value: 'male',
                            groupValue: _gender,
                            activeColor: Color(0xFF2196F3),
                            onChanged: (val) => setState(() => _gender = val),
                          ),
                          Text('Male'),
                          Radio<String>(
                            value: 'female',
                            groupValue: _gender,
                            activeColor: primaryColor,
                            onChanged: (val) => setState(() => _gender = val),
                          ),
                          Text('Female'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2196F3),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _register,
                      child: Text(
                        'Register',
                        style: GoogleFonts.cairo(fontWeight:FontWeight.bold,fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
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
      ),
    );
  }
}
