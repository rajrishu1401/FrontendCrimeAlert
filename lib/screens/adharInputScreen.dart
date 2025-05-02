import 'package:crime_alert/screens/adharVerificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class AdharInputScreen extends StatefulWidget {
  const AdharInputScreen({super.key,required this.state,required this.city, required this.latitude,
    required this.longitude,});
  final String state;
  final String city;
  final double latitude;
  final double longitude;

  @override
  State<AdharInputScreen> createState() => _AdharInputScreenState();
}

class _AdharInputScreenState extends State<AdharInputScreen> {
  TextEditingController countryController = TextEditingController();
  var aadhar='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/aadhar.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Aadhar Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to verify your aadhar!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                          onChanged: (value){
                            aadhar=value.toUpperCase();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[A-Z0-9]")), // Allows only uppercase letters & numbers
                            //UpperCaseTextFormatter(), // Custom formatter to auto-capitalize
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Aadhar",
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        //backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      if (aadhar.isEmpty || aadhar.length != 12) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter a valid 12-digit Aadhaar number")),
                        );
                        return;
                      }

                      final response = await http.post(
                        Uri.parse("http://10.0.2.2:9090/api/verify-aadhaar"),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode({"aadhaarNumber": aadhar}),
                      );

                      if (response.statusCode == 200) {
                        final decoded = jsonDecode(response.body);
                        final success = decoded['success'];
                        final message = decoded['message'];
                        final data = decoded['data'];

                        if (success == false && message == "Account already exists") {
                          // Aadhaar is valid but already registered
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Account Exists"),
                              content: Text("An account already exists for this Aadhaar number."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                          return;
                        } else if (success == true) {
                          // Aadhaar found and not registered — proceed to OTP
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdharVerificationScreen(
                                aadhaar: aadhar,
                                name: data['name'],
                                dob: data['dob'],
                                phoneNo: data['phoneNo'],
                                otp: data['otp'],
                                city: widget.city,
                                state: widget.state,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                              ),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Welcome, ${data['name']}")),
                          );
                        } else {
                          // Shouldn't happen normally, fallback
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Unexpected response from server")),
                          );
                        }
                      } else if (response.statusCode == 404) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Aadhaar not found")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Server error: ${response.body}")),
                        );
                        print(response.body);
                      }

                    },
                    child: Text("Send the code")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
