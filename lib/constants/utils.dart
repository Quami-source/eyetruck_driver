import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

String apiUrlV2 = "http://192.168.0.152:5000";

Future<dynamic> uploadDocs(File? file, String uid) async {
  try {
    final fileName = file!.path.split("/").last;
    final timeStamp = DateTime.now().microsecondsSinceEpoch;
    final storageRef = FirebaseStorage.instance.ref("/drivers");
    final uploadRef = storageRef.child("/docs/$uid/$timeStamp-$fileName");

    TaskSnapshot uploadTask = await uploadRef.putFile(file);
    String res = await uploadTask.ref.getDownloadURL();

    return res;
  } catch (e) {
    debugPrint(jsonEncode(e));
  }

  return null;
}
