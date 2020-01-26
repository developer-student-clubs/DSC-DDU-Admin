import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> _scan(String id) async {
  String scanedBarcode = await scanner.scan();
  barcode=scanedBarcode;

       Firestore.instance
        .collection('events')
        .document(id)
        .get()
        .then((DocumentSnapshot ds) {
           ds.collection('participants')
             .where("qrCodeString", isEqualTo: barcode)
    .snapshots()
    .listen((data) =>
        data.documents.forEach((doc){doc["attended"]=true;}));
        }
    });

}