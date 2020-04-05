import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

Future<void> scan(String id, BuildContext context) async {
  bool success;
  while (true) {
    await scanner.scan().then((barcode) async {
      success = false;
      await Firestore.instance
          .collection("events")
          .document(id)
          .collection("participants")
          .where('qrCodeString', isEqualTo: barcode)
          .limit(1)
          .getDocuments()
          .then((data) {
        if (data.documents.length > 0) {
          data.documents[0].reference.updateData({
            'attended': true,
          });
          success = true;

          Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            barcode,
          ),
        ));
        }
      });

      if (!success) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            "Not Registered",
          ),
        ));
      }
    });
  }
}
