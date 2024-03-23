import 'package:eyetruck_driver/screens/home/settings.dart';
import 'package:eyetruck_driver/screens/home/welcome.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  int currentIndex;

  Home({super.key, this.currentIndex = 0});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(widget.currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 136, 140, 145),
        selectedItemColor: const Color.fromARGB(255, 46, 134, 206),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
        currentIndex: widget.currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 46, 134, 206),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color.fromARGB(255, 46, 134, 206),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(currentIndex) {
    switch (currentIndex) {
      case 0:
        return const Welcome();
      case 1:
        return const Settings();
      default:
        return const Welcome();
    }
  }
}
