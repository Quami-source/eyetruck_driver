import 'package:eyetruck_driver/constants/widgets/button.dart';
import 'package:eyetruck_driver/screens/auth/signup_personal.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  child: const TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter your email', labelText: 'Email'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 24),
                  child: const TextField(
                    decoration: InputDecoration(
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
                      child: primaryButton(text: "Login", onPressed: () {}),
                    )),
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
