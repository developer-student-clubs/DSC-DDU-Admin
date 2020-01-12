import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget
{
  Event event;

  EditEvent(Event event) {
    this.event = event;
  }
  @override
  State<StatefulWidget> createState() {
    return EditEventState();
  }
}

class EditEventState extends State<EditEvent>
{
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:new Container(
        color: Colors.grey[300],
        child: Center(
          child:new Card(
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              child: Form(
                  key: formkey,
                  child:Padding(
                    padding: EdgeInsets.all(15.0),
                    child: ListView(
                      children: <Widget>[
                        new TextFormField(
                          initialValue: widget.event.title,
                          decoration: new InputDecoration(
                              labelText: 'Title'
                          ),
                          onSaved: (String value) {
                            debugPrint(value);
                            widget.event.title = value;
                          }
                        ),
                        new TextFormField(
                          initialValue: widget.event.description,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: new InputDecoration(
                              labelText: 'Description'
                          ),
                          onSaved: (String value) {
                            widget.event.description = value;
                          }
                        ),
                        new Padding(padding: EdgeInsets.all(15.0)),
                        new RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.red,
                          onPressed: () {
                            formkey.currentState.save();
                            final DocumentReference postRef = Firestore.instance.document('events/' + widget.event.id);
                            Firestore.instance.runTransaction((Transaction tx) async {
                              DocumentSnapshot postSnapshot = await tx.get(postRef);
                              if (postSnapshot.exists) {
                                await tx.update(postRef, <String, dynamic>{'title': widget.event.title, 'description': widget.event.description});
                              }
                            });
                            Navigator.of(context).pop(this);
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      ],
                    ),
                  )

              )
          ),
        ),
      ),
    );
  }
}