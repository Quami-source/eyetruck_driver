import 'dart:convert';
import 'dart:io';

import 'package:eyetruck_driver/constants/colors.dart';
import 'package:eyetruck_driver/constants/utils.dart';
import 'package:eyetruck_driver/constants/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eyetruck_driver/screens/home/home.dart';

class SignUpPersonal extends StatefulWidget {
  const SignUpPersonal({super.key});

  @override
  State<SignUpPersonal> createState() => _SignUpPersonalState();
}

class _SignUpPersonalState extends State<SignUpPersonal> {
  GlobalKey tabControllerKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  int currentTab = 0;

  bool submitting = false;

  //personal
  late String firstName = '';
  late String lastName = '';
  late String email = '';
  TextEditingController phone = TextEditingController();
  late String pwd = '';
  late String pwdConfirm = '';

  PhoneNumber number = PhoneNumber(isoCode: 'GH');

  //documents
  late String lisence = '';
  TextEditingController issuedAt = TextEditingController();
  TextEditingController expiredAt = TextEditingController();

  File? imgFront;
  File? imgBack;

  TextEditingController lisenceDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign up",
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
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: DefaultTabController(
                      animationDuration: const Duration(milliseconds: 500),
                      length: 2,
                      key: tabControllerKey,
                      initialIndex: currentTab,
                      child: Column(
                        children: [
                          TabBar(
                            onTap: (value) {
                              setState(() {
                                currentTab = value;
                              });
                            },
                            isScrollable: true,
                            labelColor: primaryBlue,
                            indicatorColor: primaryBlue,
                            unselectedLabelColor: Colors.grey,
                            dividerColor: Colors.white,
                            tabAlignment: TabAlignment.start,
                            tabs: const [
                              Tab(text: "Personal info"),
                              Tab(text: "Documents"),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: TabBarView(children: [
                              Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      firstName = value;
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Enter your first name',
                                        labelText: 'First name',
                                        labelStyle: TextStyle(fontSize: 14)),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your other names';
                                      }
                                      lastName = value;
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Enter your last name',
                                        labelStyle: TextStyle(fontSize: 14),
                                        labelText: 'Last name'),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      email = value;
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Enter your email',
                                        labelStyle: TextStyle(fontSize: 14),
                                        labelText: 'Email'),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InternationalPhoneNumberInput(
                                    textFieldController: phone,
                                    hintText: 'Enter your phone number',
                                    initialValue: number,
                                    formatInput: true,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    onInputChanged: (e) {},
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      pwd = value;
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Enter your password',
                                        labelStyle: TextStyle(fontSize: 14),
                                        labelText: 'Password'),
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      pwdConfirm = value;
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Enter your password',
                                        labelStyle: TextStyle(fontSize: 14),
                                        labelText: 'Confirm password'),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 80),
                                    child: primaryButton(
                                        text: "Continue",
                                        onPressed: () {
                                          setState(() {
                                            currentTab = 1;
                                          });
                                        }),
                                  )
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your license number';
                                        }
                                        lisence = value;
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Driver's license number",
                                          labelText:
                                              'Enter your license number',
                                          labelStyle: TextStyle(fontSize: 14)),
                                    ),
                                    TextField(
                                      onTap: () {
                                        _selectDate();
                                      },
                                      controller: issuedAt,
                                      decoration: const InputDecoration(
                                          labelText: 'Issued date',
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
                                          labelStyle: TextStyle(fontSize: 14)),
                                    ),
                                    TextField(
                                      onTap: () {
                                        _selectExpDate();
                                      },
                                      controller: expiredAt,
                                      decoration: const InputDecoration(
                                          labelText: 'Expiry date',
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
                                          labelStyle: TextStyle(fontSize: 14)),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Text('Front license image'),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 209, 209, 209),
                                            borderRadius: BorderRadius.all(
                                                Radius.elliptical(20, 20))),
                                        child: TextButton(
                                            onPressed: () {
                                              _selectFrontImage();
                                            },
                                            child: imgFront != null
                                                ? const Text(
                                                    'Change selection',
                                                    style: TextStyle(
                                                        color: Colors.black45),
                                                  )
                                                : const Text(
                                                    'Select image',
                                                    style: TextStyle(
                                                        color: Colors.black45),
                                                  )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    imgFront != null
                                        ? Container(
                                            height: 200,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.elliptical(20, 20))),
                                            child: Image.file(
                                              imgFront!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Text('No front image selected'),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    const Text('Back license image'),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 209, 209, 209),
                                            borderRadius: BorderRadius.all(
                                                Radius.elliptical(20, 20))),
                                        child: TextButton(
                                            onPressed: () {
                                              _selectBackImage();
                                            },
                                            child: imgBack != null
                                                ? const Text(
                                                    'Change selection',
                                                    style: TextStyle(
                                                        color: Colors.black45),
                                                  )
                                                : const Text(
                                                    'Select image',
                                                    style: TextStyle(
                                                        color: Colors.black45),
                                                  )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    imgBack != null
                                        ? Container(
                                            height: 200,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.elliptical(20, 20))),
                                            child: Image.file(
                                              imgBack!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Text('No back image selected'),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 50, bottom: 30),
                                      child: submitting == true
                                          ? const CircularProgressIndicator()
                                          : primaryButton(
                                              text: "Submit",
                                              onPressed: () async {
                                                var payload = jsonEncode({
                                                  'email': email,
                                                  'password': pwdConfirm,
                                                  'phone': phone,
                                                  'first_name': firstName,
                                                  'last_name': lastName,
                                                  'license_id': lisence,
                                                  'expired_at': expiredAt,
                                                  'issued_at': issuedAt
                                                });

                                                debugPrint(payload);
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  if (pwdConfirm == pwd) {
                                                    if (imgBack != null &&
                                                        imgFront != null) {
                                                      // String userId = "uid1001";

                                                      // dynamic data =
                                                      //     await uploadDocs(
                                                      //         imgFront, userId);

                                                      // debugPrint(data);
                                                      setState(() {
                                                        submitting = true;
                                                      });

                                                      try {
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();

                                                        var res =
                                                            await http.post(
                                                          Uri.parse(
                                                              "$apiUrlV2/v2/register/driver"),
                                                          body: payload,
                                                          headers: {
                                                            'Content-Type':
                                                                'application/json'
                                                          },
                                                        );

                                                        debugPrint(res.body);

                                                        // var data = jsonDecode(
                                                        //     res.body);

                                                        // debugPrint(
                                                        //     data['payload']
                                                        //         ['token']);

                                                        // var details =
                                                        //     data['payload']
                                                        //         ['details'];

                                                        // await prefs.setString(
                                                        //     'token',
                                                        //     data['payload']
                                                        //         ['token']);
                                                        // await prefs.setString(
                                                        //     'username',
                                                        //     details[
                                                        //         'first_name']);
                                                        // await prefs.setString(
                                                        //     'email',
                                                        //     details['email']);
                                                        // await prefs.setString('phone', details['phone']);

                                                        // await prefs.setBool(
                                                        //     'verified',
                                                        //     details[
                                                        //         'verified']);
                                                        // await prefs.setString(
                                                        //     'uid',
                                                        //     details['_id']);
                                                        // await prefs.setString(
                                                        //     'uimg',
                                                        //     details['imgUrl']);

                                                        setState(() {
                                                          submitting = false;
                                                        });

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content:
                                                                const Center(
                                                              child: Text(
                                                                  "Login Successful"),
                                                            ),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.9,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                          ),
                                                        );

                                                        // Navigator
                                                        //     .pushAndRemoveUntil(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //     builder:
                                                        //         (context) =>
                                                        //             Home(),
                                                        //   ),
                                                        //   (route) => false,
                                                        // );
                                                      } catch (e) {
                                                        var error =
                                                            jsonEncode(e);
                                                        debugPrint(error);

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Center(
                                                              child: Text(
                                                                  "Registration failed. Try again later. $e"),
                                                            ),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.9,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                          ),
                                                        );

                                                        setState(() {
                                                          submitting = false;
                                                        });
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: const Center(
                                                            child: Text(
                                                                "Please select front and back images of your license"),
                                                          ),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: const Center(
                                                          child: Text(
                                                              "Passwords do not match"),
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      ),
                                                    );
                                                  }
                                                }
                                              }),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        issuedAt.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectExpDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        expiredAt.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectFrontImage() async {
    final frontImg = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (frontImg == null) return;

    setState(() {
      imgFront = File(frontImg.path);
    });
  }

  Future<void> _selectBackImage() async {
    final backImg = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (backImg == null) return;

    setState(() {
      imgBack = File(backImg.path);
    });
  }

  Future<void> _submit() async {
    if (imgBack != null && imgFront != null) {
      String userId = "uid1001";
      dynamic frontImgStatus = await uploadDocs(imgFront, userId);
      debugPrint(frontImgStatus.toString());

      if (frontImgStatus == null) {
        debugPrint("Upload failed");
      } else {
        debugPrint(frontImgStatus);
      }
    }
  }
}
