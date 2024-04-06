import 'package:eyetruck_driver/screens/auth/login.dart';
import 'package:eyetruck_driver/screens/settings/personal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                // NOTE: remove this later ...
                SharedPreferences.getInstance().then((prefs) {
                  prefs.clear();
                });
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 221, 221, 221)))),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Personal()));
                },
                child: const Row(
                  children: [
                    Icon(Icons.person, color: Color.fromARGB(255, 53, 52, 52)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Personal",
                      style: TextStyle(
                          fontSize: 16, color: Color.fromARGB(255, 53, 52, 52)),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 221, 221, 221)))),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Personal()));
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.privacy_tip,
                      color: Color.fromARGB(255, 53, 52, 52),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Privacy policy",
                      style: TextStyle(
                          fontSize: 16, color: Color.fromARGB(255, 53, 52, 52)),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 221, 221, 221)))),
              child: TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Color.fromARGB(255, 53, 52, 52),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "App info",
                      style: TextStyle(
                          fontSize: 16, color: Color.fromARGB(255, 53, 52, 52)),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 221, 221, 221)))),
              child: TextButton(
                onPressed: () {
                  confirmLogout();
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Color.fromARGB(255, 53, 52, 52),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Log out",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 221, 101, 93)),
                    )
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
