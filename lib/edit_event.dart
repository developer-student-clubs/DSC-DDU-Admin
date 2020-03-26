import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class EditEvent extends StatefulWidget {
  Event event;

  EditEvent(Event event) {
    this.event = event;
  }

  @override
  State<StatefulWidget> createState() {
    return EditEventState();
  }
}

class EditEventState extends State<EditEvent> {
  //File _image;

  final formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool showImageError = false;
  final dateformat = DateFormat("dd MMMM yyyy");
  final timeformat = DateFormat.jm();
  String _startTime;
  String _endTime = "onwards";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        color: Colors.grey[300],
        child: Center(
          child: new Card(
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              child: Form(
                key: formkey,
                autovalidate: _autoValidate,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: widget.event.eventName,
                          decoration: new InputDecoration(
                              hintText: 'event name here..',
                              labelText: 'Event Name'),
                          onSaved: (String value) {
                            widget.event.eventName = value;
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Event name cannot be empty'
                                : null;
                          },
                        ), //eventName
                        DateTimeField(
                          initialValue: DateTime.parse(
                              _formatDateString(widget.event.date)),
                          format: dateformat,
                          decoration: new InputDecoration(labelText: 'Date'),
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(2018),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2050));
                          },
                          onSaved: (DateTime value) {
                            widget.event.date = dateformat.format(value);
                          },
                          validator: (value) {
                            final now = DateTime.now();
                            if (value == null) {
                              return 'Date cannot be empty';
                            } else if (value.compareTo(new DateTime(
                                    now.year, now.month, now.day)) <
                                0) {
                              return 'Date cannot be less than today';
                            } else {
                              return null;
                            }
                          },
                        ), //date
                        DateTimeField(
                          initialValue:
                              _getTime(_getStartTime(widget.event.timings)),
                          format: timeformat,
                          decoration:
                              new InputDecoration(labelText: 'Start Time'),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.convert(time);
                          },
                          onSaved: (DateTime value) {
                            this._startTime = timeformat.format(value);
                          },
                          validator: (value) {
                            return (value == null)
                                ? 'Start time cannot be empty'
                                : null;
                          },
                        ), //start time
                        DateTimeField(
                          initialValue:
                              _getTime(_getEndTime(widget.event.timings)),
                          format: timeformat,
                          decoration:
                              new InputDecoration(labelText: 'End Time'),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.convert(time);
                          },
                          onSaved: (DateTime value) {
                            if (value != null) {
                              this._endTime = timeformat.format(value);
                            }
                          },
                        ), //end time
                        TextFormField(
                          initialValue: widget.event.venue,
                          decoration: new InputDecoration(
                              hintText: 'venue here..', labelText: 'Venue'),
                          onSaved: (String value) {
                            widget.event.venue = value;
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Venue cannot be empty'
                                : null;
                          },
                        ), //venue
                        TextFormField(
                          initialValue: widget.event.description,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: new InputDecoration(
                              hintText: 'description of the event here...',
                              labelText: 'Description'),
                          onSaved: (String value) {
                            widget.event.description = value;
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Description cannot be empty'
                                : null;
                          },
                        ), //description
                        TextFormField(
                          initialValue:
                              widget.event.totalSeats.toString(), // '0'
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              hintText: 'total seats here...',
                              labelText: 'Total Seats'),
                          onSaved: (String value) {
                            widget.event.totalSeats = int.parse(value);
                          },
                          onChanged: (String value) {
                            print(int.parse(value));
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Total seats cannot be empty'
                                : null;
                          },
                        ), //totalSeats
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          initialValue: widget.event.extraInfo, //"N.A.",
                          decoration: new InputDecoration(
                              hintText: 'extra information here..',
                              labelText: 'Extra Information'),
                          onSaved: (String value) {
                            widget.event.extraInfo = value;
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Field cannot be empty'
                                : null;
                          },
                        ), //extraInfo
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          initialValue: widget.event.what_to_bring, //"N.A.",
                          decoration: new InputDecoration(
                              hintText: 'things to bring here..',
                              labelText: 'Things to bring'),
                          onSaved: (String value) {
                            widget.event.what_to_bring = value;
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Things to bring cannot be empty'
                                : null;
                          },
                        ), //what_to_bring
                        TextFormField(
                          initialValue: widget.event.branch, //"Any",
                          decoration: new InputDecoration(
                              hintText: 'branch here..', labelText: 'Branch'),
                          onSaved: (String value) {
                            widget.event.branch = value;
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Branch cannot be empty'
                                : null;
                          },
                        ), //branch
                        TextFormField(
                          initialValue: widget.event.semester, // "Any",
                          decoration: new InputDecoration(
                              hintText: 'semester here..',
                              labelText: 'Semester'),
                          onSaved: (String value) {
                            widget.event.semester = value;
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Semester cannot be empty'
                                : null;
                          },
                        ), //semester //eventName
                        Padding(padding: EdgeInsets.all(15.0)),
                        RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.red,
                          onPressed: () {
                            if (formkey.currentState.validate()) {
                              formkey.currentState.save();
                              widget.event.timings = (_endTime == "onwards")
                                  ? _startTime + " " + _endTime
                                  : _startTime + " to " + _endTime;

                              final DocumentReference postRef = Firestore
                                  .instance
                                  .document('events/' + widget.event.id);
                              Firestore.instance
                                  .runTransaction((Transaction tx) async {
                                DocumentSnapshot postSnapshot =
                                    await tx.get(postRef);
                                if (postSnapshot.exists) {
                                  await tx.update(postRef, <String, dynamic>{
                                    'branch': widget.event.branch,
                                    'currentAvailable': widget.event.totalSeats,
                                    'date': widget.event.date,
                                    'description': widget.event.description,
                                    'eventName': widget.event.eventName,
                                    'extraInfo': widget.event.extraInfo,
                                    'postedOn': DateTime.now(),
                                    'semester': widget.event.semester,
                                    'timings': widget.event.timings,
                                    'totalSeats': widget.event.totalSeats,
                                    'venue': widget.event.venue,
                                    'what_to_bring': widget.event.what_to_bring,
                                  });
                                }
                              });
                              Navigator.of(context).pop(this);
                            } else {
                              _autoValidate = true;
                            }
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  String _formatDateString(String date) {
    int firstSpace = date.indexOf(" ");
    int lastSpace = date.lastIndexOf(" ");
    String day = date.substring(0, firstSpace);
    String month = date.substring(firstSpace + 1, lastSpace);
    String year = date.substring(lastSpace + 1, date.length);
    switch (month) {
      case ("January"):
        month = "01";
        break;
      case ("February"):
        month = "02";
        break;
      case ("March"):
        month = "03";
        break;
      case ("April"):
        month = "04";
        break;
      case ("May"):
        month = "05";
        break;
      case ("June"):
        month = "06";
        break;
      case ("July"):
        month = "07";
        break;
      case ("August"):
        month = "08";
        break;
      case ("September"):
        month = "09";
        break;
      case ("October"):
        month = "10";
        break;
      case ("November"):
        month = "11";
        break;
      case ("December"):
        month = "12";
        break;
    }
    return year + "-" + month + "-" + day;
  }

  String _getStartTime(String timing) {
    int i;
    String startTime;
    if (timing.indexOf("onwards") >= 0) {
      i = timing.indexOf(" onwards");
    } else {
      i = timing.indexOf(" to ");
    }
    startTime = timing.substring(0, i);
    return startTime;
  }

  String _getEndTime(String timing) {
    if (timing.indexOf("onwards") >= 0) {
      return "onwards";
    }
    int i = timing.indexOf(" to ");
    String endTime = timing.substring(i + 4, timing.length);
    return endTime;
  }

  DateTime _getTime(String time) {
    if (time == "onwards") {
      return null;
    }
    int i = time.indexOf(":");
    int j = time.indexOf(" ");
    int hour = int.parse(time.substring(0, i));
    String minute = time.substring(i + 1, j);
    String z = time.substring(j + 1, time.length);
    if (z.compareTo("PM") == 0) {
      hour = hour + 12;
    } else {
      if (hour == 12) {
        hour = 0;
      }
    }
    String hourString = hour.toString();
    if (hour < 10) {
      hourString = "0" + hour.toString();
    }
    String timeString = "2020-01-01 " + hourString + ":" + minute + ":00";
    return DateTimeField.convert(
        TimeOfDay.fromDateTime(DateTime.parse(timeString)));
  }
}
