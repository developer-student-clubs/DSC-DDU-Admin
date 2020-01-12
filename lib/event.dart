import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/edit_event.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class Event extends StatefulWidget {

  String id;
  String title;
  //final String image;
  String description;
  DocumentReference reference;

  Event();

  Event.fromData(this.id, this.title, this.description);

  Event.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['description'] != null),
        title = map['title'],
        description = map['description'],
        id = reference.documentID;

  Event.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  State<StatefulWidget> createState() {
    return EventState();
  }
}

class EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          _getDeleteButton()
        ],
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
              widget.description,
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
                return EditEvent(widget);
              }
          )).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  IconButton _getDeleteButton() {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        showDialog<ConfirmAction>(
            context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Event'),
              content: const Text('Are you sure you want to delete this event?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmAction.CANCEL);
                  },
                ),
                FlatButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Firestore.instance.document('events/' + widget.id).delete();
                    Navigator.of(context).pop(ConfirmAction.ACCEPT);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
/*
class Event extends StatelessWidget{

  String id;
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
                return EditEvent(this);
              }
          )).then((value) {
            Navigator.pop(context);
          });
        },
      ),
    );
  }

  Event();

  Event.fromData(this.id, this.title, this.description);

  Event.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['description'] != null),
        title = map['title'],
        description = map['description'],
        id = reference.documentID;

  Event.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
 */