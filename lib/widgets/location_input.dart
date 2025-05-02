import 'package:flutter/material.dart';
import 'package:location/location.dart';

class AddLocation extends StatefulWidget{
  const AddLocation({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddLocationState();
  }

}

class _AddLocationState extends State<AddLocation>{
  Location? selectedLocation;
  bool isLocationSelected=false;
  void _currentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isLocationSelected=true;
    });
    locationData = await location.getLocation();
    setState(() {
      isLocationSelected=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget content=Text('no location selected',style:Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: Theme.of(context).colorScheme.onBackground,
    ));
    if(isLocationSelected){
      content=const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
          child: Center(
            child: content,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(onPressed:_currentLocation, icon: const Icon(Icons.location_on),label:const Text('Get Current Location')),
            TextButton.icon(onPressed:(){}, icon: const Icon(Icons.map_outlined),label:const Text('Select on Map')),
          ],
        )
      ],
    );
  }

}
