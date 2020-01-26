import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

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
  File _image;

  final formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool showImageError = false;
  final dateformat = DateFormat("dd MMMM yyyy");
  final timeformat = DateFormat.jm();
  String _startTime;
  String _endTime;

  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        showImageError = false;
      });
    }

    Future<String> uploadPic(BuildContext context) async{
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }

    return new Scaffold(
      body:new Container(
        color: Colors.grey[300],
        child: Center(
          child:new Card(
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              child: Form(
                  key: formkey,
                  autovalidate: _autoValidate,
                  child:Padding(
                    padding: EdgeInsets.all(15.0),
                    child: SingleChildScrollView (
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: new InputDecoration(
                                hintText: 'event name here..',
                                labelText: 'Event Name'
                            ),
                            onSaved: (String value) {
                              this.event.eventName = value;
                            },
                            validator: (value) {
                              return value.isEmpty ? 'Event name cannot be empty' : null;
                            },
                          ), //eventName
                          DateTimeField(
                            format: dateformat,
                            decoration: new InputDecoration(
                                labelText: 'Date'
                            ),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2020),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2050)
                              );
                            },
                            onSaved: (DateTime value) {
                              this.event.date = dateformat.format(value);
                            },
                            validator: (value) {
                              final now = DateTime.now();
                              if (value == null) {
                                return 'Date cannot be empty';
                              } else if (value.compareTo(new DateTime(now.year, now.month, now.day)) < 0) {
                                return 'Date cannot be less than today';
                              } else {
                                return null;
                              }
                            },
                          ), //date
                          DateTimeField(
                            format: timeformat,
                            decoration: new InputDecoration(
                                labelText: 'Start Time'
                            ),
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                            onSaved: (DateTime value) {
                              this._startTime = timeformat.format(value);
                            },
                            validator: (value) {
                              return (value == null) ? 'Start time cannot be empty' : null;
                            },
                          ), //start time
                          DateTimeField(
                            format: timeformat,
                            decoration: new InputDecoration(
                                labelText: 'End Time'
                            ),
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                            onSaved: (DateTime value) {
                              this._endTime = timeformat.format(value);
                            },
                            validator: (value) {
                              return (value == null) ? 'End time cannot be empty' : null;
                            },
                          ), //end time
                          TextFormField(
                            decoration: new InputDecoration(
                                hintText: 'venue here..',
                                labelText: 'Venue'
                            ),
                            onSaved: (String value) {
                              this.event.venue = value;
                            },
                            validator: (value) {
                              return value.isEmpty ? 'Venue cannot be empty' : null;
                            },
                          ), //venue
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: new InputDecoration(
                                hintText: 'description of the event here...',
                                labelText: 'Description'
                            ),
                            onSaved: (String value) {
                              this.event.description = value;
                            },
                            validator: (value) {
                              return value.isEmpty ? 'Description cannot be empty' : null;
                            },
                          ), //description
                          TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: '0',
                            decoration: new InputDecoration(
                                hintText: 'total seats here...',
                                labelText: 'Total Seats'
                            ),
                            onSaved: (String value) {
                              this.event.totalSeats = int.parse(value);
                            },
                            validator: (value) {
                              return value.isEmpty ? 'Total seats cannot be empty' : null;
                            },
                          ), //totalSeats
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: "N.A.",
                            decoration: new InputDecoration(
                                hintText: 'extra information here..',
                                labelText: 'Extra Information'
                            ),
                            onSaved: (String value) {
                              this.event.extraInfo = value;
                            },
                            validator: (value) {
                              return value.isEmpty ? 'Field cannot be empty' : null;
                            },
                          ), //extraInfo
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: "N.A.",
                            decoration: new InputDecoration(
                                hintText: 'things to bring here..',
                                labelText: 'Things to bring'
                            ),
                            onSaved: (String value) {
                              this.event.what_to_bring = value;
                            },
                            validator: (value) {
                              return value.isEmpty ? 'Things to bring cannot be empty' : null;
                            },
                          ), //what_to_bring
                          TextFormField(
                            initialValue: "Any",
                            decoration: new InputDecoration(
                                hintText: 'branch here..',
                                labelText: 'Branch'
                            ),
                            onSaved: (String value) {
                              this.event.branch = value;
                            },
                            validator: (value) {
                              return value.isEmpty ? 'Branch cannot be empty' : null;
                            },
                          ), //branch
                          TextFormField(
                            initialValue: "Any",
                            decoration: new InputDecoration(
                                hintText: 'semester here..',
                                labelText: 'Semester'
                            ),
                            onSaved: (String value) {
                              this.event.semester = value;
                            },
                            validator: (value) {
                              return value.isEmpty ? 'Semester cannot be empty' : null;
                            },
                          ), //semester //eventName
                          Card(
                            child: (_image != null) ? Image.file(
                              _image,
                              fit: BoxFit.fill,
                            ):Image.network(
                              "https://winaero.com/blog/wp-content/uploads/2019/11/Photos-new-icon.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              'Upload Image',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () { getImage(); },
                          ),
                          Visibility(
                            child: Text(
                              '* Upload image',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            visible: showImageError,
                          ),
                          Padding(padding: EdgeInsets.all(15.0)),
                          RaisedButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.red,
                            onPressed: () {
                              if(formkey.currentState.validate()) {
                                formkey.currentState.save();
                                if(_image != null) {
                                  event.timings = _startTime + " to " + _endTime;
                                  uploadPic(context).then((value){
                                    if (formkey.currentState.validate()){
                                      Firestore.instance.collection('events').document()
                                          .setData({ 'branch': event.branch,
                                        'currentAvailable': 0,
                                        'date': event.date,
                                        'description': event.description,
                                        'eventName': event.eventName,
                                        'extraInfo': event.extraInfo,
                                        'imageUrl': value,
                                        'postedOn': DateTime.now(),
                                        'semester': event.semester,
                                        'timings': event.timings,
                                        'totalSeats': event.totalSeats,
                                        'venue': event.venue,
                                        'what_to_bring': event.what_to_bring,
                                      });
                                      Navigator.of(context).pop(this);
                                    }
                                  });
                                }
                                else {
                                  setState(() {
                                    _image == null ? showImageError = true : showImageError = false;
                                  });
                                }
                              } else {
                                _autoValidate = true;
                              }
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ) //submit
                        ],
                      ),
                    ),
                  ),
              )
          ),
        ),
      ),
    );
  }
}