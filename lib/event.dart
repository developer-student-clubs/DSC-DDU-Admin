import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/edit_event.dart';

enum ConfirmAction { CANCEL, ACCEPT }

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
  DocumentReference reference;

  Event();

  Event.fromData(this.id,
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
      this.what_to_bring);

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
        currentAvailable = map['currentAvailable'],
        date = map['date'],
        description = map['description'],
        eventName = map['eventName'],
        extraInfo = map['extraInfo'],
        imageUrl = map['imageUrl'],
        postedOn = map['postedOn'],
        semester = map['semester'],
        timings = map['timings'],
        totalSeats = map['totalSeats'],
        venue = map['venue'],
        what_to_bring = map['what_to_bring'],
        id = reference.documentID;

  Event.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString({ DiagnosticLevel minLevel = DiagnosticLevel.debug }) {
    String fullString;
    assert(() {
      fullString = toDiagnosticsNode(style: DiagnosticsTreeStyle.singleLine).toString(minLevel: minLevel);
      return true;
    }());
    return fullString ?? toStringShort();
  }

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
        title: Text(widget.eventName),
        actions: <Widget>[
          _getDeleteButton()
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 225.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          widget.eventName,
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          widget.date,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          widget.description,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.grey[300],
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Seats",
                                style: TextStyle(
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(
                                width: 60,
                              ),
                              getPill(widget.currentAvailable.toString(), Colors.green[100]),
                              Text(' / ', style: TextStyle(fontSize: 20, color: Colors.grey),),
                              getPill(widget.totalSeats.toString(), Colors.blue[100]),
                            ],
                          )
                      ),
                      Container(
                        color: Colors.grey[300],
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Timing",
                                style: TextStyle(
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              getPill(widget.timings, Colors.yellow[100]),
                            ],
                          )
                      ),
                      Container(
                        color: Colors.grey[300],
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                      ),
                      getTextLabelAndValue("Venue", widget.venue),
                      getTextLabelAndValue("Branch", widget.branch),
                      getTextLabelAndValue("Semester", widget.semester),
                      getTextLabelAndValue("What to Bring", widget.what_to_bring),
                      getTextLabelAndValue("Extra", widget.extraInfo),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
            setState(() {

            });
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

  Widget getPill(String text, Color color){
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

  Widget getTextLabelAndValue(String label, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Text(
            label + ": ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20
            ),
          )
        ],
      ),
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