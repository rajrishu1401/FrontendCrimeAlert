import 'package:crime_alert/screens/adharInputScreen.dart';
import 'package:crime_alert/screens/idInputScreen.dart';
import 'package:flutter/material.dart';
import 'package:crime_alert/screens/citizenSignUpScreen.dart';
import 'package:crime_alert/screens/authoritySignUpScreen.dart';


class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() {
    return _UserTypeScreenState();
  }
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  bool? _isCitizen; // Ensure this line is correctly placed

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(
          'Details',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('What are you?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCitizen = true;
                });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: _isCitizen == true
                        ? colorScheme.primary
                        : colorScheme.secondary,
                    width: 2,
                  ),
                ),
                color: _isCitizen == true
                    ? colorScheme.primaryContainer
                    : colorScheme.surface,
                elevation: 8,
                shadowColor: colorScheme.primary.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: colorScheme.primary.withOpacity(0.8),
                        backgroundImage: const AssetImage('assets/images/person.webp'),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'You are a citizen',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCitizen = false;
                });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: _isCitizen == false
                        ? colorScheme.primary
                        : colorScheme.secondary,
                    width: 2,
                  ),
                ),
                color: _isCitizen == false
                    ? colorScheme.primaryContainer
                    : colorScheme.surface,
                elevation: 8,
                shadowColor: colorScheme.primary.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: colorScheme.primary.withOpacity(0.8),
                        backgroundImage: const AssetImage('assets/images/police.webp'),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'You are from authority',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(onPressed: (){
              if(_isCitizen!=null) _isCitizen!?Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const AdharInputScreen())):Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const IdInputScreen()));
            }, child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Next',style: Theme.of(context).textTheme.bodyLarge,),
                  const Icon(Icons.navigate_next)
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
