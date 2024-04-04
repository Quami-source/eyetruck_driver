import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String? userName;
  bool? isVerified;
  String? _currentPlace;
  Position? _currentPosition;
  late Timer _timer;
  String? userImg;
  String? uid;

  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    getStoredItems();
    _startLocationUpdates();
    // _getCurrentLocation();
    // _getLocationChanges();
    //_sendLocationDate(_currentPlace);
    //_getIoConnection();

    socket = IO.io('http://192.168.0.152:8080',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket!.on("connect", (data) => debugPrint('Mobile is connect to socket'));
  }

  Future<void> getStoredItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('username');
      isVerified = prefs.getBool('verified');
      userImg = prefs.getString('uimg');
      uid = prefs.getString('uid');
    });
  }

  void _startLocationUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
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
            _currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation,
            );

            if (_currentPosition != null) {
              debugPrint('New position: ${_currentPosition!.toString()}');
              debugPrint('Latitude: ${_currentPosition!.latitude}');
              debugPrint('Longitude: ${_currentPosition!.longitude}');

              // Reverse geocoding
              List<Placemark> placemarks = await placemarkFromCoordinates(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              );

              setState(() {
                _currentPlace =
                    placemarks.isNotEmpty ? placemarks[0].street : null;
              });

              // Send location data to server
              _sendLocationData();
            }
          }
        }
      } catch (e) {
        debugPrint('Error getting location: $e');
      }
    });
  }

  void _sendLocationData() {
    if (_currentPosition != null) {
      Map<String, dynamic> jsonData = {
        'id': uid,
        'name': userName,
        'place': _currentPlace,
        'lat': _currentPosition!.latitude,
        'lng': _currentPosition!.longitude,
        'spd': _currentPosition!.speed,
        'hdg': _currentPosition!.heading
      };

      String jsonString = json.encode(jsonData);
      debugPrint(jsonString);
      socket!.emit('testLocation', jsonString);
    }
  }

  @override
  void dispose() {
    // Cancel timer when disposing the widget
    _timer.cancel();
    super.dispose();
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
                            userImg ??
                                'https://imgs.search.brave.com/O18zPZEThw9BlU3mHtFOxeExt5rw1vSHwJgrtg9uNVA/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAxLzI0LzY1LzY5/LzM2MF9GXzEyNDY1/Njk2OV94M3k4WVZ6/dnJxRlp5djNZTFdO/bzZQSmFDODhTWXhx/TS5qcGc',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Image.asset(
                                  'assets/images/avatar.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          )),
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
            ),
          ],
        ),
      )),
    );
  }
}
