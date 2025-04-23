import 'package:flutter/material.dart';

class CitizenProfileScreen extends StatefulWidget{
  const CitizenProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CitizenProfileScreenState();
  }

}

class _CitizenProfileScreenState extends State<CitizenProfileScreen>{
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