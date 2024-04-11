import 'package:eyetruck_driver/screens/auth/login.dart';
import 'package:eyetruck_driver/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: getToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Image.asset('assets/images/splash.png');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String? token = snapshot.data;
                if (token != null) {
                  return Home();
                } else {
                  return const Login();
                }
              }
            }),
      ),
    );
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
