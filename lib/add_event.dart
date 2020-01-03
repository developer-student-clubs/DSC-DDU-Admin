import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/event.dart';
import 'package:dsc_event_adder/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEvent extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return AddEventState();
  }
}

class AddEventState extends State<AddEvent>
{
  Event event = new Event();
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
                            decoration: new InputDecoration(
                                hintText: 'Title here...',
                                labelText: 'Title'
                            ),
                            onSaved: (String value) {
                              debugPrint(value);
                              this.event.title = value;
                            }
                        ),
                        new TextFormField(
                            decoration: new InputDecoration(
                                hintText: 'description of the event here...',
                                labelText: 'Description'
                            ),
                            onSaved: (String value) {
                              this.event.description = value;
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
                            Firestore.instance.collection('events').document()
                                .setData({ 'title': event.title, 'description': event.description });
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