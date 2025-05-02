import 'package:flutter/material.dart';
import 'package:crime_alert/widgets/buttonWidget.dart'; // Import the button widget
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';


class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key,required this.aadhaar,required this.name,required this.dob,required this.phoneNo,required this.state,required this.city, required this.latitude,
    required this.longitude,});
  final String state;
  final String city;
  final String aadhaar;
  final String name;
  final String dob;
  final String phoneNo;
  final double latitude;
  final double longitude;

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPressed = false; // For simulating hover effect on mobile

  Future<void> sendEmergencyAlert() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // 📍 Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      String fullAddress = 'Unknown location';
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        fullAddress = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }

      final url = Uri.parse('http://10.0.2.2:9090/emergency');

      final payload = {
        'name': widget.name,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'citizenId': widget.aadhaar,
        'description': 'Emergency.',
        'location': fullAddress,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🚨 Emergency alert sent successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send emergency alert: $e")),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        )),
        child: child,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
            
                // 🚨 Emergency Button (Circular) with Press Effect
                Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() => _isPressed = true); // Button turns darker red when pressed
                    },
                    onTapUp: (_) async {
                      setState(() => _isPressed = false);
                      await sendEmergencyAlert(); // Now it uses fresh location
                    },

                    onTapCancel: () {
                      setState(() => _isPressed = false); // Restore color if tap is canceled
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isPressed ? Colors.red.shade800 : colorScheme.error, // Darker when pressed
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(50), // Bigger button
                      child: Column(
                        children: [
                          const Icon(Icons.warning, color: Colors.white, size: 90),
                          Text(
                            "Emergency",
                            style: TextStyle(
                              color: colorScheme.onError,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            
                const SizedBox(height: 50), // Spacing
            
                // 📌 Buttons
                CustomButton(
                  icon: Icons.report,
                  text: "Report a Crime",
                  color: colorScheme.primaryContainer,
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                CustomButton(
                  icon: Icons.notifications,
                  text: "Live Alerts",
                  color: colorScheme.secondaryContainer,
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                CustomButton(
                  icon: Icons.phone,
                  text: "Call Emergency",
                  color: colorScheme.tertiaryContainer ?? colorScheme.surfaceVariant,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
