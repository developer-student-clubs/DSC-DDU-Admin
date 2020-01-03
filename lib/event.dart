import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_event.dart';

class Event extends StatelessWidget{

  String title;
  //final String image;
  String description;
  DocumentReference reference;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
                ),
              ),
            ),
            Text(
              this.description,
              style: TextStyle(
                fontSize: 18.0,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return AddEvent();
              }
          ));
        },
      ),
    );
  }

  Event() { }

  Event.fromData(this.title, this.description);

  Event.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['description'] != null),
        title = map['title'],
        description = map['description'];

  Event.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}