import 'package:flutter/material.dart';
import 'package:crime_alert/widgets/buttonWidget.dart'; // Import the button widget

class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPressed = false; // For simulating hover effect on mobile

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
                    onTapUp: (_) {
                      setState(() => _isPressed = false); // Restore color when released
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
