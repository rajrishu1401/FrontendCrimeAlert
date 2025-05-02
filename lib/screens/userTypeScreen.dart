import 'package:crime_alert/screens/adharInputScreen.dart';
import 'package:crime_alert/screens/idInputScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  bool? _isCitizen;
  String _address = "Location not fetched yet";
  String? _city;
  String? _state;
  double? _latitude;
  double? _longitude;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Store city and state
        _city = place.locality;
        _state = place.administrativeArea;

        String address =
            '${place.name}, ${place.street}, $_city, $_state, ${place.country}';

        setState(() {
          _address = address;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Current Address: $address')),
        );
        _latitude = position.latitude;
        _longitude = position.longitude;
        print("City: $_city");
        print("State: $_state");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching address: $e')),
      );
    }
  }



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
                    color: _isCitizen == true ? colorScheme.primary : colorScheme.secondary,
                    width: 2,
                  ),
                ),
                color: _isCitizen == true ? colorScheme.primaryContainer : colorScheme.surface,
                elevation: 8,
                shadowColor: colorScheme.primary.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                    color: _isCitizen == false ? colorScheme.primary : colorScheme.secondary,
                    width: 2,
                  ),
                ),
                color: _isCitizen == false ? colorScheme.primaryContainer : colorScheme.surface,
                elevation: 8,
                shadowColor: colorScheme.primary.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
            const SizedBox(height: 30),

            /// 🚀 Get Location Button
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Location'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),

            const SizedBox(height: 10),

            /// 📍 Show fetched address
            Text(
              _address,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_isCitizen != null) {
                  if (_city != null && _state != null&& _latitude != null && _longitude != null) {
                    if (_isCitizen!) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AdharInputScreen(city: _city!, state: _state!,latitude: _latitude!,
                          longitude: _longitude!,)),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IdInputScreen(city: _city!, state: _state!,latitude: _latitude!,
                            longitude: _longitude!,),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fetch location before proceeding.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select your role.')),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next', style: Theme.of(context).textTheme.bodyLarge),
                    const Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
