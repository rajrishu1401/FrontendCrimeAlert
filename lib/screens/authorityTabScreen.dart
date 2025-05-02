//import 'package:krishi_unnati/screens/ProductCategoryScreen.dart';
import 'package:crime_alert/screens/authorityHistoryScreen.dart';
import 'package:crime_alert/screens/authorityProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crime_alert/screens/authorityHomeScreen.dart';
//import 'package:krishi_unnati/screens/farmeProductScreen.dart';
import 'package:crime_alert/screens/authorityHistoryScreen.dart';
//import 'package:krishi_unnati/provider/farmersItems_provider.dart';
import 'package:crime_alert/widgets/drawer_widget.dart';

import '../services/notification_service.dart';

class AuthorityTabScreen extends ConsumerStatefulWidget {
  const AuthorityTabScreen({super.key,required this.id,required this.name,required this.dob,required this.phoneNo,required this.state,required this.city, required this.latitude,
    required this.longitude,});
  final String state;
  final String city;
  final String id;
  final String name;
  final String dob;
  final String phoneNo;
  final double latitude;
  final double longitude;

  @override
  ConsumerState<AuthorityTabScreen> createState() {
    return _AuthorityTabScreen();
  }
}

class _AuthorityTabScreen extends ConsumerState<AuthorityTabScreen> {
  @override
  void initState() {
    super.initState();
    NotificationService.setupFirebaseListeners(context); // 👈 This is all you need
  }
  void _drawerScreenChange(String screen){
    Navigator.pop(context);
    if(screen=='Profile'){
      Navigator.push(context, MaterialPageRoute(builder:(ctx)=>const AuthorityProfileScreen(),));
    }
    if(screen=='Help'){
      Navigator.push(context, MaterialPageRoute(builder:(ctx)=>const AuthorityProfileScreen(),));
    }
    if(screen=='History'){
      Navigator.push(context, MaterialPageRoute(builder:(ctx)=>const AuthorityProfileScreen(),));
    }
  }

  int selectedTabIndex = 0;
  void selectTab(int index) {
    setState(() {
      if (index == 0) {
        selectedTabIndex = 0;
      } else {
        selectedTabIndex=1;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget activeScreen = AuthorityHomeScreen(id: widget.id,
      name: widget.name,
      dob: widget.dob,
      phoneNo: widget.phoneNo,
      state: widget.state,
      city: widget.city,
      latitude: widget.latitude,
      longitude: widget.longitude,);
    String activeTitle = 'Home';
    Widget? floatingActionButton;
    if (selectedTabIndex == 1) {
      //final favoriteMeal=ref.watch(favoritesMealProvider);
      activeScreen = const AuthorityHistoryScreen();
      activeTitle = 'Reports';
      floatingActionButton=null;
    }
    return Scaffold(
      drawer: DrawerWidget(changeScreen: _drawerScreenChange,),
      appBar: AppBar(
        title: Text(activeTitle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectTab,
        currentIndex: selectedTabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Reports',
          )
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
