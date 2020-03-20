import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/qr_scan.dart';



class Attendance extends StatelessWidget {
  String id;
  int registered;

  String name;
  Attendance(id,name,registered){
    this.id=id;
    this.registered=registered;
    this.name=name;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("events").document(id).collection("participants")
          .where('attended',isEqualTo:true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.cyan[50],
          ),
        );
//        registered=Firestore.instance.collection("events").document(id).collection("participants").snapshots().length;
        return _buildPage(context,id,registered,snapshot.data.documents.length,name);
      },
    );
  }


}
  Widget _buildPage(BuildContext context,id,registered,remaining,name) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Present" + ": ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        remaining.toString(),
                        style: TextStyle(
                            fontSize: 32
                        ),
                      )
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Text(
    "Registered" + ": ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        registered.toString(),
                        style: TextStyle(
                            fontSize: 32
                        ),
                      )
                    ],
                  ),


                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RaisedButton.icon(
                color: Colors.red,
                icon: Icon(Icons.center_focus_weak,color: Colors.white,), //`Icon` to display
            label: Text('Scan QR Code',style: TextStyle(color: Colors.white,fontSize: 20),), //`Text` to display
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                onPressed: ()async {
                  await scan(id);
                },
              ),

            ),
          ],
        ),
      );




}

