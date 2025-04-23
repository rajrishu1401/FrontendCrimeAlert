import 'package:flutter/material.dart';

class AuthorityHomeScreen extends StatefulWidget {
  const AuthorityHomeScreen({super.key});

  @override
  State<AuthorityHomeScreen> createState() => _AuthorityHomeScreenState();
}

class _AuthorityHomeScreenState extends State<AuthorityHomeScreen> with SingleTickerProviderStateMixin {
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
          child: Column(
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
