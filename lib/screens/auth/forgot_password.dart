import 'dart:convert';

import 'package:eyetruck_driver/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:eyetruck_driver/constants/widgets/button.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey tabControllerKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  bool submitting = false;

  bool showPass = true;
  bool showConfirm = true;

  String? phone = '';
  final email = TextEditingController();
  final newPwd = TextEditingController();
  final confirmPwd = TextEditingController();

  PhoneNumber number = PhoneNumber(isoCode: 'GH');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot password",
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
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        labelStyle: TextStyle(fontSize: 14),
                        labelText: 'Email'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InternationalPhoneNumberInput(
                    hintText: 'Enter your phone number',
                    initialValue: number,
                    formatInput: true,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onInputChanged: (e) {
                      //debugPrint(e.phoneNumber);
                      phone = e.phoneNumber;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: newPwd,
                    obscureText: showPass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter your password',
                        labelStyle: const TextStyle(fontSize: 14),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            icon: Icon(showPass
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        labelText: 'Password'),
                  ),
                  TextFormField(
                    controller: confirmPwd,
                    obscureText: showConfirm,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (newPwd.text != confirmPwd.text) {
                        return "Passwords do not match";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter your password',
                        labelStyle: const TextStyle(fontSize: 14),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showConfirm = !showConfirm;
                              });
                            },
                            icon: Icon(showConfirm
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        labelText: 'Confirm password'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  submitting == true
                      ? const CircularProgressIndicator()
                      : Container(
                          margin: const EdgeInsets.only(top: 80),
                          child: primaryButton(
                              text: "Continue",
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await _submit(phone, email.text);
                                }
                              }),
                        )
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _submit(phoneNumber, email) async {
    if (phoneNumber.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Center(child: Text("Enter your phone number to continue")),
          width: MediaQuery.of(context).size.width * 0.8,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      //submit
      setState(() {
        submitting = true;
      });
      Map payload = {
        'email': email,
        'phone': phoneNumber,
        'password': confirmPwd.text
      };

      debugPrint(jsonEncode(payload));

      try {
        var res = await http.post(
          Uri.parse("$apiUrlV2/v2/forgot-password/driver"),
          body: jsonEncode(payload),
          headers: {'Content-Type': 'application/json'},
        );

        debugPrint(res.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Center(
              child: Text("Password change successful"),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        // var error = jsonEncode(e);
        // debugPrint(error);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text("$e"),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        setState(() {
          submitting = false;
        });
      }
    }
  }
}
