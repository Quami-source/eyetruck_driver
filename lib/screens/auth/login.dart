import 'dart:convert';

import 'package:eyetruck_driver/constants/utils.dart';
import 'package:eyetruck_driver/constants/widgets/button.dart';
import 'package:eyetruck_driver/screens/auth/signup_personal.dart';
import 'package:eyetruck_driver/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoginLoading = false;

  Future _login(email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (email.isEmpty || password.isEmpty) {
      // Display error message if email or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(child: Text("Enter Email and Password")),
          width: MediaQuery.of(context).size.width * 0.9,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    setState(() {
      isLoginLoading = true;
    });

    try {
      var res = await http.post(
        Uri.parse("$apiUrlV2/v2/login/driver"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint(res.body);

      var data = jsonDecode(res.body);

      debugPrint(data['payload']['token']);

      var details = data['payload']['details'];

      await prefs.setString('token', data['payload']['token']);
      await prefs.setString('username', details['first_name']);
      await prefs.setString('email', details['email']);
      // await prefs.setString('phone', details['phone']);

      await prefs.setBool('verified', details['verified']);
      await prefs.setString('uid', details['_id']);
      await prefs.setString('uimg', details['imgUrl']);

      setState(() {
        isLoginLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(
            child: Text("Login Successful"),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        isLoginLoading = false;
      });
      var error = jsonEncode(e);
      debugPrint(error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(
            child: Text("Login failed. Try again later"),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ),
                const Text(
                  'Login to continue',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 80),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: 'Enter your email', labelText: 'Email'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 24),
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                        hintText: 'Enter your password', labelText: 'Password'),
                    obscureText: true,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      const AlertDialog(
                        content: Text("I was clicked"),
                        actions: [],
                      );
                    },
                    child: const Text(
                      "Forgot password",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 46, 134, 206)),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 24),
                    child: Center(
                        child: isLoginLoading == false
                            ? primaryButton(
                                text: "Login",
                                onPressed: () async {
                                  await _login(emailController.text,
                                      passwordController.text);
                                })
                            : const CircularProgressIndicator())),
                const Center(
                  child: Text(
                    'or',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: TextButton(
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 46, 134, 206)),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPersonal()));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
