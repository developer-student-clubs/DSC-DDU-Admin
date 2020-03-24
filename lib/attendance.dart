import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/qr_scan.dart';
import 'package:dsc_event_adder/attendeeList.dart';

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
        if (!snapshot.hasData) return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text(name),
            elevation: 0,
          ),
          body: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.cyan[50],
                ),
              ),
            ),
          )
        );
//        registered=Firestore.instance.collection("events").document(id).collection("participants").snapshots().length;
        return _buildPage(context,id,registered,snapshot.data.documents.length,name);
      },
    );
  }
}

Widget _buildPage(BuildContext context,id,registered,remaining,name) {
  return Scaffold(
    backgroundColor: Theme.of(context).primaryColor,
    appBar: AppBar(
      title: Text(name),
      elevation: 0,
    ),
    body: MainPage(id,registered,remaining,name),
  );
}

class MainPage extends StatelessWidget{
  String id;
  int registered;
  int remaining;
  String name;

  MainPage(id,registered,remaining,name){
    this.id = id;
    this.registered = registered;
    this.remaining = remaining;
    this.name = name;
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Present" + ": ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        remaining.toString(),
                        style: TextStyle(
                            fontSize: 24,
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
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        registered.toString(),
                        style: TextStyle(
                            fontSize: 24,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 64.0,
            ),
            RaisedButton.icon(
              color: Colors.red,
              icon: Icon(
                Icons.center_focus_weak,
                color: Colors.white,
              ), //`Icon` to display
              label: Text(
                'Scan QR Code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ), //`Text` to display
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
              ),
              onPressed: () async {
                await scan(id, context);
              },
            ),
            SizedBox(
              height: 64.0,
            ),
            RaisedButton.icon(
              color: Colors.red,
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ), //`Icon` to display
              label: Text(
                'Get List',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ), //`Text` to display
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
              ),
              onPressed: () {
                getAttendeeList(context, id, name);
              },
            ),
          ],
        ),
      ),
    );
  }

}