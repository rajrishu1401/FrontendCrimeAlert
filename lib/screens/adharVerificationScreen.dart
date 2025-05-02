import 'package:crime_alert/screens/adharInputScreen.dart';
import 'package:crime_alert/screens/citizenSignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class AdharVerificationScreen extends StatefulWidget{
  const AdharVerificationScreen({super.key,required this.aadhaar,required this.name,required this.dob,required this.phoneNo,required this.otp,required this.state,required this.city, required this.latitude,
    required this.longitude,});
  final String state;
  final String city;
  final String aadhaar;
  final String name;
  final String dob;
  final String phoneNo;
  final String otp;
  final double latitude;
  final double longitude;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdharVerificationScreenState();
  }
}

class _AdharVerificationScreenState extends State<AdharVerificationScreen> {
  String enteredOtp = '';

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/OTP.png',
                width: 300,
                height: 300,
              ),
              SizedBox(height: 25),
              Text(
                "Enter OTP",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "We have sent an OTP to phone no registered with your aadhar!",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  enteredOtp = value;
                },
                onCompleted: (pin) {
                  enteredOtp = pin;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (enteredOtp == widget.otp) {
                      // ✅ OTP is correct — proceed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CitizenSignUpScreen(
                            aadhaar: widget.aadhaar,
                            name: widget.name,
                            dob: widget.dob,
                            phoneNo: widget.phoneNo,
                            state: widget.state,
                            city: widget.city,
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                          ),
                        ),
                      );
                    } else {
                      // ❌ OTP is incorrect — show error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Incorrect OTP. Please try again."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text("Verify"),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AdharInputScreen(state: widget.state,city: widget.city,latitude: widget.latitude,
                          longitude: widget.longitude,)),
                      );
                    },
                    child: Text("Edit Aadhar Number?"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
