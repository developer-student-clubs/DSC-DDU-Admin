import 'package:dsc_event_adder/attendance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/edit_event.dart';
import 'package:expandable/expandable.dart';
import 'package:dsc_event_adder/login_page.dart';

enum ConfirmAction { CANCEL, ACCEPT }

final GlobalKey<ScaffoldState> _eventSK = new GlobalKey<ScaffoldState>();

class Event extends StatefulWidget {
  String id;
  String branch;
  int currentAvailable;
  String date;
  String description;
  String eventName;
  String extraInfo;
  String imageUrl;
  Timestamp postedOn;
  String semester;
  String timings;
  int totalSeats;
  String venue;
  String what_to_bring;
  int registered;
  DocumentReference reference;

  Event();

  Event.fromData(
      this.id,
      this.branch,
      this.currentAvailable,
      this.date,
      this.description,
      this.eventName,
      this.extraInfo,
      this.imageUrl,
      this.postedOn,
      this.semester,
      this.timings,
      this.totalSeats,
      this.venue,
      this.what_to_bring,
      this.registered);

  Event.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['branch'] != null),
        assert(map['currentAvailable'] != null),
        assert(map['date'] != null),
        assert(map['description'] != null),
        assert(map['eventName'] != null),
        assert(map['extraInfo'] != null),
        assert(map['imageUrl'] != null),
        assert(map['postedOn'] != null),
        assert(map['semester'] != null),
        assert(map['timings'] != null),
        assert(map['totalSeats'] != null),
        assert(map['venue'] != null),
        assert(map['what_to_bring'] != null),
        branch = map['branch'],
        currentAvailable = map['currentAvailable'].toInt(),
        date = map['date'],
        description = map['description'],
        eventName = map['eventName'],
        extraInfo = map['extraInfo'],
        imageUrl = map['imageUrl'],
        postedOn = map['postedOn'],
        semester = map['semester'],
        timings = map['timings'],
        totalSeats = int.parse(map['totalSeats'].toString()),
        venue = map['venue'],
        what_to_bring = map['what_to_bring'],
        id = reference.documentID;

  Event.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    String fullString;
    assert(() {
      fullString = toDiagnosticsNode(style: DiagnosticsTreeStyle.singleLine)
          .toString(minLevel: minLevel);
      return true;
    }());
    return fullString ?? toStringShort();
  }

  @override
  State<StatefulWidget> createState() {
    return EventState();
  }
}

enum ActionButton { edit, delete }

class EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _eventSK,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(widget.eventName),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (ActionButton result) {
              setState(() {
                if (result == ActionButton.edit) {
                  _doEdit();
                } else {
                  _doDelete();
                }
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ActionButton>>[
              const PopupMenuItem<ActionButton>(
                value: ActionButton.edit,
                child: Text('Edit'),
              ),
              const PopupMenuItem<ActionButton>(
                value: ActionButton.delete,
                child: Text('Delete'),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 225.0,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              child: Image.network(
                                widget.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Text(
                                                  widget.eventName,
                                                  style: TextStyle(
                                                    fontSize: 24.0,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                widget.date,
                                              ),
                                            ]),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: RaisedButton.icon(
                                                color: Colors.red,
                                                icon: Icon(
                                                  Icons.list,
                                                  color: Colors.white,
                                                ), //`Icon` to display
                                                label: Text(
                                                  'Attendance',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ), //`Text` to display
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return Attendance(
                                                          widget.id,
                                                          widget.eventName,
                                                          widget.registered);
                                                    }),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ]),
                                _getExpandable(
                                    "Description", widget.description),
                                _getLine(),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Seats",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          width: 65,
                                        ),
                                        getPill(
                                            widget.currentAvailable.toString(),
                                            Colors.green[100]),
                                        Text(
                                          ' / ',
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.grey),
                                        ),
                                        getPill(widget.totalSeats.toString(),
                                            Colors.blue[100]),
                                      ],
                                    )),
                                _getLine(),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Timing",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        getPill(
                                            widget.timings, Colors.yellow[100]),
                                      ],
                                    )),
                                _getLine(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: <Widget>[
                                      getTextLabelAndValue(
                                          "Venue", widget.venue),
                                      getTextLabelAndValue(
                                          "Branch", widget.branch),
                                      getTextLabelAndValue(
                                          "Semester", widget.semester),
                                    ],
                                  ),
                                ),
                                _getExpandable(
                                    "What to Bring", widget.what_to_bring),
                                _getExpandable("Extra", widget.extraInfo),
                                SizedBox(
                                  height: 70,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _getFloatingButton(),
    );
  }

  FloatingActionButton _getFloatingButton() {
    if (widget.currentAvailable > 0) {
      return FloatingActionButton(
        child: Icon(
          Icons.stop,
        ),
        onPressed: () {
          if (canLive) {
            showDialog<ConfirmAction>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Stop Event'),
                    content: const Text(
                        'Are you sure you want to make this event stop?'),
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
                          final DocumentReference postRef = Firestore.instance
                              .document('events/' + widget.id);
                          Firestore.instance
                              .runTransaction((Transaction tx) async {
                            DocumentSnapshot postSnapshot =
                                await tx.get(postRef);
                            if (postSnapshot.exists) {
                              await tx.update(postRef,
                                  <String, dynamic>{'currentAvailable': 0});
                            }
                            Navigator.of(context).pop(ConfirmAction.ACCEPT);
                            setState(() {
                              widget.currentAvailable = 0;
                            });
                          });
                        },
                      )
                    ],
                  );
                });
          } else {
            _eventSK.currentState.showSnackBar(SnackBar(
                content: Text("You don't have access to stop an event.")));
          }
        },
      );
    } else {
      return FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          if (canLive) {
            showDialog<ConfirmAction>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Live Event'),
                    content: const Text(
                        'Are you sure you want to make this event live?'),
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
                          final DocumentReference postRef = Firestore.instance
                              .document('events/' + widget.id);
                          Firestore.instance
                              .runTransaction((Transaction tx) async {
                            DocumentSnapshot postSnapshot =
                                await tx.get(postRef);
                            if (postSnapshot.exists) {
                              await tx.update(postRef, <String, dynamic>{
                                'currentAvailable': widget.totalSeats
                              });
                            }

                            Navigator.of(context).pop(ConfirmAction.ACCEPT);
                            setState(() {
                              widget.currentAvailable = widget.totalSeats;
                            });
                          });
                        },
                      )
                    ],
                  );
                });
          } else {
            _eventSK.currentState.showSnackBar(SnackBar(
              content: Text("You don't have access to live an event."),
            ));
          }
        },
      );
    }
  }

  void _doEdit() {
    if (canEdit) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return EditEvent(widget);
      })).then((value) {
        setState(() {});
      });
    } else {
      _eventSK.currentState.showSnackBar(
          SnackBar(content: Text("You don't have access to edit an event.")));
    }
  }

  void _doDelete() {
    if (canEdit) {
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
    } else {
      _eventSK.currentState.showSnackBar(
          SnackBar(content: Text("You don't have access to delete an event.")));
    }
  }

  Widget getPill(String text, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
        ),
      ),
    );
  }

  Widget getTextLabelAndValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Text(
            label + ": ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _getExpandable(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ExpandablePanel(
        header: Text(title),
        collapsed: Text(
          text,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[500]),
        ),
        expanded: Text(
          text,
          softWrap: true,
        ),
        theme: ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center),
      ),
    );
  }

  Widget _getLine() {
    return Container(
      color: Colors.grey[300],
      width: MediaQuery.of(context).size.width,
      height: 1,
    );
  }
}
