import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> scan(String id, BuildContext context) async {
 
  bool success;
// var participantsRef=Firestore.instance.collection("events").document(id).collection("participants");
// participantsRef.add({"attended":false,"qrCodeString":"parth"});
//  participantsRef.add({"attended":false,"qrCodeString":"parth1"});
//  participantsRef.add({"attended":false,"qrCodeString":"parth2"});

  while(true){
   await scanner.scan().then((barcode) async{
      success=false;
       await Firestore.instance.collection("events").document(id).collection("participants")
        .where('qrCodeString',isEqualTo: barcode).limit(1)
        .getDocuments().then((data) {
      if (data.documents.length > 0){
          data.documents[0].reference.updateData({
            'attended': true,
          });   
          success=true;
      } 
    });

    if(success){
       Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                barcode,
              ),
            )
          );
    }
    else{
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Not Registered",
            ),
          )
        );
      }
  

   });
   
  // participantsRef.where('qrCodeString'==barcode).getDocuments().then((QuerySnapshot snapshot) {
  //    snapshot.documents.forEach((f) => {
  //    });
  //  });
  }
}

