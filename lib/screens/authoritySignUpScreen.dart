import 'dart:async';
import 'dart:io';
import 'package:crime_alert/screens/authorityTabScreen.dart';
import 'package:crime_alert/screens/userTypeScreen.dart';
import 'package:flutter/material.dart';
import 'package:crime_alert/screens/loginScreen.dart';
import 'package:crime_alert/widgets/imagePickerWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthoritySignUpScreen extends StatefulWidget{
  const AuthoritySignUpScreen({super.key,required this.id,required this.name,required this.dob,required this.phoneNo});
  final String id;
  final String name;
  final String dob;
  final String phoneNo;
  @override
  State<AuthoritySignUpScreen> createState() => _AuthoritySignUpScreenState();
}

class _AuthoritySignUpScreenState extends State<AuthoritySignUpScreen>{
  final _form = GlobalKey<FormState>();
  var _enteredPassword = '';
  var _userName = '';
  File? selectedImage;
  DateTime? _selectedDate;
  bool _userNameError = false;
  String _userNameErrorText = '';
  final TextEditingController _userNameController = TextEditingController();
  Future<(bool, String)> registerAuthority({
    required String name,
    required String userId,
    required String password,
    required String id,
    required String dob,
    required String phoneNo
  }) async {
    const url = 'http://10.0.2.2:8080/api/register';

    final body = jsonEncode({
      "name": name,
      "userId": userId,
      "password": password,
      "idNo": id,
      "role": "Police",
      "dob" : dob,
      "phoneNo": phoneNo
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return (true, decoded['message'] as String);
      } else {
        return (false, decoded['message'] as String);
      }
    } catch (e) {
      return (false, "Network error: $e");
    }
  }

  // Language selection state
  String _selectedLanguage = 'English'; // Default language is English
  final List<String> _languages = ['English', 'Hindi'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Opacity(
                opacity: 0.2, // Adjust the opacity for better visibility of form elements
                child: Image.asset(
                  'assets/images/signUp.webp', // Replace with your image asset path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Positioned language dropdown button at top right
            Positioned(
              top: 20,
              right: 20,
              child: DropdownButton<String>(
                value: _selectedLanguage,
                icon: const Icon(Icons.language, color: Colors.white),
                dropdownColor: Colors.black87,
                style: const TextStyle(color: Colors.white),
                items: _languages.map<DropdownMenuItem<String>>((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
              ),
            ),
            // Form content
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _form,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        UserImagePickerWidget(transferImage: (image) {
                          selectedImage = image;
                        }),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          initialValue: widget.name,
                          readOnly: true,
                          decoration: const InputDecoration(
                            label: Text('Name (from Id)'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: widget.dob,
                          readOnly: true,
                          decoration: const InputDecoration(
                            label: Text('DOB (from Id)'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _userNameController,
                          enableSuggestions: false,
                          decoration: InputDecoration(
                            label: const Text('User Name'),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _userNameError ? Colors.red : Colors.blue,
                                width: 2,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _userNameError ? Colors.red : Colors.grey,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            errorText: _userNameError ? _userNameErrorText : null,
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length <= 4) {
                              return 'Please enter more than 4 characters';
                            }
                            return null;
                          },
                          onChanged: (_) {
                            if (_userNameError) {
                              setState(() {
                                _userNameError = false;
                                _userNameErrorText = '';
                              });
                            }
                          },
                          onSaved: (value) {
                            _userName = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Set Password'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length <= 6) {
                              return 'Password should be at least 6 characters long';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {
                            final isValid = _form.currentState!.validate();
                            if (!isValid) return;

                            _form.currentState!.save();

                            final (success, message) = await registerAuthority(
                              name: widget.name,
                              userId: _userName,
                              password: _enteredPassword,
                              id: widget.id,
                              dob: widget.dob,
                              phoneNo: widget.phoneNo,
                            );

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("✅ $message")),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AuthorityTabScreen(),
                                ),
                              );
                            } else {
                              if (message.toLowerCase().contains("user") || message.toLowerCase().contains("username")) {
                                setState(() {
                                  _userNameError = true;
                                  _userNameErrorText = message;
                                });
                              }

                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Registration Failed"),
                                  content: Text(message),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text("OK"),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Next',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const Icon(Icons.navigate_next),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Already have an account',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}