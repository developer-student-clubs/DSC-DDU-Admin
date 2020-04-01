import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/event.dart';
import 'package:flutter/rendering.dart';

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('events')
          .orderBy('postedOn', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.cyan[50],
            ),
          );
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    snapshot.sort((a, b) => b.data["postedOn"].compareTo(a.data["postedOn"]));
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final event = Event.fromSnapshot(data);
    return Padding(
        key: ValueKey(event.eventName),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
        child: GestureDetector(
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            Event e = new Event.fromData(
                event.id,
                event.branch,
                event.currentAvailable,
                event.date,
                event.description,
                event.eventName,
                event.extraInfo,
                event.imageUrl,
                event.postedOn,
                event.semester,
                event.timings,
                event.totalSeats,
                event.venue,
                event.whatToBring,
                event.totalSeats - event.currentAvailable);
            return e;
          })),
          child: Card(
            color: Colors.grey[50],
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3),
                        topRight: Radius.circular(3)),
                    child: Container(
                      height: 150.0,
                      width: MediaQuery.of(context).size.width - 32,
                      child: Image.network(
                        event.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          event.eventName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(event.date)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
