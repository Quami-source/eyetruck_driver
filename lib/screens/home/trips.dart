import 'dart:convert';

import 'package:eyetruck_driver/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyTrips extends StatefulWidget {
  const MyTrips({super.key});

  @override
  State<MyTrips> createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  late Future<List<dynamic>> driverTrips = Future.value([]);
  String? uid;

  @override
  void initState() {
    super.initState();

    _getStoredID();
    _getTrips(uid);
  }

  Future<void> _getStoredID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My trips",
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
        body: FutureBuilder<List<dynamic>>(
            future: driverTrips,
            builder: (context, snapshot) {
              return RefreshIndicator(
                  onRefresh: _pullRefresh, child: _listView(snapshot));
            }));
  }

  Widget _listView(AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasError) {
      return const Center(
        child: Text("We encountered an error. Pull down to refresh"),
      );
    } else {
      if (snapshot.data.length <= 0) {
        return Center(
          child: Column(
            children: [
              Image.asset('assets/images/empty_box.png'),
              const Text(
                'Your trip data will show here. Pull down to refresh',
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      } else {
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            var trip = snapshot.data[index];

            return ListTile(
                title: Text(trip['toAddress']),
                subtitle: Text(trip['dateCreated']),
                trailing: Text(
                  trip['tripStatus'],
                  style: const TextStyle(color: Colors.blue),
                ),
                shape: const Border(
                    bottom: BorderSide(
                        width: 1, color: Color.fromARGB(255, 216, 216, 216))));
          },
        );
      }
    }
  }

  Future<void> _getTrips(String? id) async {
    if (id != null) {
      try {
        var res = await http.post(
          Uri.parse("$apiUrlV2/v2/driver/trips"),
          body: jsonEncode({"driver_id": id}),
          headers: {'Content-Type': 'application/json'},
        );

        //debugPrint(res.body);
        var data = jsonDecode(res.body);
        debugPrint(data.toString());
        var payload = data['payload']['items'];

        setState(() {
          driverTrips = Future.value(payload);
        });
      } catch (e) {
        debugPrint(jsonEncode(e));
      }
    }
  }

  Future<void> _pullRefresh() async {
    if (uid != null) {
      try {
        var res = await http.post(
          Uri.parse("$apiUrlV2/v2/driver/trips"),
          body: jsonEncode({"driver_id": uid}),
          headers: {'Content-Type': 'application/json'},
        );

        //debugPrint(res.body);

        var data = jsonDecode(res.body);

        var payload = data['payload']['items'];

        setState(() {
          driverTrips = Future.value(payload);
        });
      } catch (e) {
        debugPrint(jsonEncode(e));
      }
    }
  }
}
