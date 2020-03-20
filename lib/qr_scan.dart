import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:math';
Future<void> scan(String id) async {
  String barcode;

bool success;
//var participantsRef=Firestore.instance.collection("events").document(id).collection("participants");
//participantsRef.add({"attended":false,"qrCodeString":"parth"});
//  participantsRef.add({"attended":false,"qrCodeString":"parth1"});
//  participantsRef.add({"attended":false,"qrCodeString":"parth2"});

while(true){
  barcode = await scanner.scan();
// participantsRef.where('qrCodeString'==barcode).getDocuments().then((QuerySnapshot snapshot) {
//    snapshot.documents.forEach((f) => {
//    });
//  });
  await Firestore.instance.collection("events").document(id).collection("participants")
      .where('qrCodeString',isEqualTo: barcode).limit(1)
      .getDocuments().then((data){
    if (data.documents.length > 0){
        data.documents[0].reference.updateData({
          'attended': true,
        });
        Fluttertoast.showToast(
            msg: barcode,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
      Fluttertoast.showToast(
          msg: "Not Registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    });



}
}

