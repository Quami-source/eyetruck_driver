import 'dart:io';

import 'package:eyetruck_driver/constants/colors.dart';
import 'package:eyetruck_driver/constants/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpPersonal extends StatefulWidget {
  const SignUpPersonal({super.key});

  @override
  State<SignUpPersonal> createState() => _SignUpPersonalState();
}

class _SignUpPersonalState extends State<SignUpPersonal> {
  GlobalKey tabControllerKey = GlobalKey();
  int currentTab = 0;

  //personal
  String? _selectedGender;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController pwdConfirm = TextEditingController();

  PhoneNumber number = PhoneNumber(isoCode: 'GH');

  //documents
  TextEditingController lisence = TextEditingController();
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
      body: SingleChildScrollView(
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
                                TextField(
                                  controller: firstName,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter your first name',
                                      labelText: 'First name',
                                      labelStyle: TextStyle(fontSize: 14)),
                                ),
                                TextField(
                                  controller: lastName,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter your last name',
                                      labelStyle: TextStyle(fontSize: 14),
                                      labelText: 'Last name'),
                                ),
                                TextField(
                                  controller: email,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter your email',
                                      labelStyle: TextStyle(fontSize: 14),
                                      labelText: 'Email'),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  widthFactor:
                                      MediaQuery.of(context).size.width,
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Gender',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text('Male'),
                                        value: 'M',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedGender = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile(
                                        title: const Text('Female'),
                                        value: 'F',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedGender = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
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
                                TextField(
                                  controller: pwd,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter your password',
                                      labelStyle: TextStyle(fontSize: 14),
                                      labelText: 'Password'),
                                ),
                                TextField(
                                  controller: pwdConfirm,
                                  obscureText: true,
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
                                  TextField(
                                    controller: lisence,
                                    decoration: const InputDecoration(
                                        hintText: "Driver's lisence number",
                                        labelText: 'Enter your license number',
                                        labelStyle: TextStyle(fontSize: 14)),
                                  ),
                                  TextField(
                                    onTap: () {
                                      _selectDate();
                                    },
                                    controller: issuedAt,
                                    decoration: const InputDecoration(
                                        labelText: 'Issued date',
                                        prefixIcon: Icon(Icons.calendar_today),
                                        labelStyle: TextStyle(fontSize: 14)),
                                  ),
                                  TextField(
                                    onTap: () {
                                      _selectExpDate();
                                    },
                                    controller: expiredAt,
                                    decoration: const InputDecoration(
                                        labelText: 'Expiry date',
                                        prefixIcon: Icon(Icons.calendar_today),
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
                                    child: primaryButton(
                                        text: "Submit", onPressed: () {}),
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
}
