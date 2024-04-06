import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  String userName = '--------';
  String email = '--------';
  String phone = '--------';
  String? userImg;

  @override
  void initState() {
    super.initState();
    getStoredItems();
  }

  Future<void> getStoredItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('username') ?? '--------';
      userImg = prefs.getString('uimg');
      email = prefs.getString('email') ?? '--------';
      phone = prefs.getString('phone') ?? '--------';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Center(
                child: ClipOval(
                    child: Image.network(
                  userImg ??
                      'https://imgs.search.brave.com/O18zPZEThw9BlU3mHtFOxeExt5rw1vSHwJgrtg9uNVA/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAxLzI0LzY1LzY5/LzM2MF9GXzEyNDY1/Njk2OV94M3k4WVZ6/dnJxRlp5djNZTFdO/bzZQSmFDODhTWXhx/TS5qcGc',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Image.asset(
                        'assets/images/avatar.jpg',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    }
                  },
                )),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 219, 219, 219)))),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text("Name"), Text(userName)],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 219, 219, 219)))),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text("Email"), Text(email)],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 219, 219, 219)))),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text("Phone"), Text(phone)],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
