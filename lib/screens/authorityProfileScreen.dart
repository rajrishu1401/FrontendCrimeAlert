import 'package:flutter/material.dart';

class AuthorityProfileScreen extends StatefulWidget{
  const AuthorityProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthorityProfileScreenState();
  }

}

class _AuthorityProfileScreenState extends State<AuthorityProfileScreen>{
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text('Home Page',style:Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: colorScheme.onPrimary,),
        ),
      ),
      body: const Center(
        child: Text('nothing to show now'),
      ),
    );
  }

}