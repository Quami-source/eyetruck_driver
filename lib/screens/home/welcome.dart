import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String? userName;
  bool? isVerified;
  String? _currentPlace;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();
    getStoredItems();
    _getCurrentLocation();
    _getLocationChanges();
  }

  Future<void> getStoredItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('username');
      isVerified = prefs.getBool('verified');
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
      } else {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            // Permissions are denied, next time you could try
            // requesting permissions again (this is also where
            // Android's shouldShowRequestPermissionRationale
            // returned true. According to Android guidelines
            // your App should show an explanatory UI now.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Center(
                  child: Text(
                      "Location permission is required for the app to run smoothly"),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return Future.error('Location permissions are denied');
          }
        } else {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          debugPrint(position.toString());

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          debugPrint(placemarks[0].name);

          setState(() {
            _currentPlace = placemarks[0].name;
          });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _getLocationChanges() {
    Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                //timeLimit: Duration(seconds: 3),
                distanceFilter: 10,
                accuracy: LocationAccuracy.bestForNavigation))
        .listen((Position position) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      debugPrint('New position: ${placemarks[0].name.toString()}');
      debugPrint('Street name: ${placemarks[0].street}');

      setState(() {
        _currentPlace = placemarks[0].street;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 223, 222, 222),
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(20, 20))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              'https://images.unsplash.com/photo-1522529599102-193c0d76b5b6?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              userName != null
                                  ? Text(
                                      'Hi $userName',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                      textAlign: TextAlign.start,
                                    )
                                  : const Text(
                                      'Hi user',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                              Row(
                                children: [
                                  isVerified == true
                                      ? const Icon(
                                          Icons.verified,
                                          color:
                                              Color.fromARGB(255, 73, 145, 76),
                                        )
                                      : const Icon(
                                          Icons.verified,
                                          color: Color.fromARGB(
                                              255, 160, 160, 160),
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  isVerified == true
                                      ? const Text(
                                          'Verified',
                                        )
                                      : const Text(
                                          'Unverified',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 139, 139, 139)),
                                        )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 206, 206, 206),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.blue,
                            ),
                          ),
                          Column(
                            children: [
                              const Text(
                                'Your location',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              _currentPlace != null
                                  ? Text('$_currentPlace')
                                  : const Text('loading...')
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
