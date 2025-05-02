import 'package:crime_alert/screens/userTypeScreen.dart';
import 'package:flutter/material.dart';
import 'package:crime_alert/screens/citizenSignUpScreen.dart';
import 'package:crime_alert/screens/phoneVerification.dart';
import '../services/api_service.dart';
import 'package:crime_alert/screens/authorityTabScreen.dart';
import 'package:crime_alert/screens/citizenTabScreen.dart';
import 'package:crime_alert/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredPassword = '';
  var _userName = '';
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Hindi'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/bg.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Form
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _form,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: DropdownButton<String>(
                              value: _selectedLanguage,
                              icon: const Icon(Icons.language, color: Colors.white),
                              dropdownColor: Colors.black87,
                              style: const TextStyle(color: Colors.white),
                              items: _languages
                                  .map<DropdownMenuItem<String>>(
                                      (String language) {
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
                          Spacer(),
                          const SizedBox(height: 20),
                          Text(
                            'Crime Alert',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 60),
                          TextFormField(
                            enableSuggestions: false,
                            decoration: const InputDecoration(
                              label: Text('User Name'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
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
                            onSaved: (value) {
                              _userName = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Password'),
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

                                print("values: $_userName $_enteredPassword");

                                try {
                                  final result = await ApiService.login(_userName, _enteredPassword);
                                  String role = result['data']['role'] ?? 'unknown';

                                  final settings = await FirebaseMessaging.instance.requestPermission();
                                  print("🔒 Notification permission status: ${settings.authorizationStatus}");
                                  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
                                    await NotificationService.init(context: context);
                                    String? token = await FirebaseMessaging.instance.getToken();
                                    if (token == null) {
                                      throw Exception("Failed to retrieve FCM token. Login restricted.");
                                    }
                                    await ApiService.sendFcmToken(userId: _userName, token: token);
                                  } else {
                                    throw Exception("Notification permission not granted. Login restricted.");
                                  }


                                  String? token = await FirebaseMessaging.instance.getToken();

                                  if (token == null) {
                                    throw Exception("Failed to retrieve FCM token. Login restricted.");
                                  }

                                  try {
                                    await ApiService.sendFcmToken(userId: _userName, token: token);
                                  } catch (e) {
                                    throw Exception("Failed to update FCM token on server. Login restricted.");
                                  }

                                  // Navigate based on role
                                  if (role == 'Citizen') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => CitizenTabScreen(aadhaar: result['data']['idNo'],
                                        name: result['data']['name'],
                                        dob: result['data']['dob'],
                                        phoneNo: result['data']['phoneNo'],
                                        state: result['data']['state'],
                                        city: result['data']['city'],
                                        latitude: result['data']['latitude'],
                                        longitude: result['data']['longitude'],)),
                                    );
                                  } else if (role != 'Admin' && role != 'unknown') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => AuthorityTabScreen(id: result['data']['idNo'],
                                        name: result['data']['name'],
                                        dob: result['data']['dob'],
                                        phoneNo: result['data']['phoneNo'],
                                        state: result['data']['state'],
                                        city: result['data']['city'],
                                        latitude: result['data']['latitude'],
                                        longitude: result['data']['longitude'],)),
                                    );
                                  } else {
                                    throw Exception("Unknown role. Cannot navigate.");
                                  }

                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Login Failed"),
                                      content: Text(e.toString().replaceFirst('Exception: ', '')),
                                      actions: [
                                        TextButton(
                                          child: const Text("OK"),
                                          onPressed: () => Navigator.pop(context),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Log in',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgotten Password?',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const PhoneVerificationScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.phone_android),
                                  label: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text('Login by Number'),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () {

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const UserTypeScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Create new account',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
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
