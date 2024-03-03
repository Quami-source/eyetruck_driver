import 'package:eyetruck_driver/constants/colors.dart';
import 'package:eyetruck_driver/constants/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpPersonal extends StatefulWidget {
  const SignUpPersonal({super.key});

  @override
  State<SignUpPersonal> createState() => _SignUpPersonalState();
}

class _SignUpPersonalState extends State<SignUpPersonal> {
  GlobalKey tabControllerKey = GlobalKey();
  int currentTab = 1;

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
  TextEditingController partnerCode = TextEditingController();
  TextEditingController lisence = TextEditingController();
  TextEditingController issuedAt = TextEditingController();
  TextEditingController expiredAt = TextEditingController();

  TextEditingController imgFront = TextEditingController();
  TextEditingController imgBack = TextEditingController();

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
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
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
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: partnerCode,
                                    decoration: const InputDecoration(
                                        hintText: 'Partner code',
                                        labelText:
                                            'Enter your associated partners code',
                                        labelStyle: TextStyle(fontSize: 14)),
                                  ),
                                  TextField(
                                    controller: partnerCode,
                                    decoration: const InputDecoration(
                                        hintText: "Driver's lisence number",
                                        labelText: 'Enter your license number',
                                        labelStyle: TextStyle(fontSize: 14)),
                                  ),
                                  DatePickerDialog(
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()),
                                  Container(
                                    margin: const EdgeInsets.only(top: 80),
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
}
