import 'package:eyetruck_driver/screens/auth/login.dart';
import 'package:eyetruck_driver/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String? token;

  @override
  void initState() {
    super.initState();

    _checkUser();
  }

  Future _checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyetruck - driver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: token != null ? Home() : const Login(),
    );
  }
}
