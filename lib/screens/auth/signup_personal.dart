import 'package:eyetruck_driver/constants/colors.dart';
import 'package:flutter/material.dart';

class SignUpPersonal extends StatefulWidget {
  const SignUpPersonal({super.key});

  @override
  State<SignUpPersonal> createState() => _SignUpPersonalState();
}

class _SignUpPersonalState extends State<SignUpPersonal> {
  GlobalKey tabControllerKey = GlobalKey();
  int currentTab = 1;

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
                  height: 350,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Enter Bio Information",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: const Text('Text'),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: const Text('Text'),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: const Text('Text'),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Enter Bio Information",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: const Text('Text'),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: const Text('Text'),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: const Text('Text'),
                                  ),
                                  const SizedBox(height: 20),
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
