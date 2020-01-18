import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/event.dart';

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final event = Event.fromSnapshot(data);
    return Padding(
      key: ValueKey(event.eventName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),/*
        child: Column(
          children: <Widget>[
            Image.network(
              event.imageUrl,
              height: 150,
              fit: BoxFit.contain,
            ),
          ],
        )*/
        child: ListTile(
          contentPadding: EdgeInsets.all(4),
          title: Container(
            height: 150.0,
            child: Image.network(
              event.imageUrl,
              fit: BoxFit.fitWidth,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              event.eventName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            Event e = new Event.fromData(event.id, event.branch, event.currentAvailable, event.date, event.description, event.eventName, event.extraInfo, event.imageUrl, event.postedOn, event.semester, event.timings, event.totalSeats, event.venue, event.what_to_bring);
            return e;
          }))
        ),
      ),
    );
  }
}