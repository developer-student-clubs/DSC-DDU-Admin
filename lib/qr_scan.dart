import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

Future<void> scan(String id, BuildContext context) async {
  String barcode;
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
        .getDocuments().then((data) {
      if (data.documents.length > 0){
          data.documents[0].reference.updateData({
            'attended': true,
          });
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                barcode,
              ),
            )
          );
      } else{
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Not Registered",
            ),
          )
        );
      }
    });
  }
}

