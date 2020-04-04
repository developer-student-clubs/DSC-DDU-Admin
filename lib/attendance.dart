import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_event_adder/qr_scan.dart';
import 'package:dsc_event_adder/attendeeList.dart';
import 'package:dsc_event_adder/login_page.dart';

class Attendance extends StatelessWidget {
  final String id;
  final int registered;
  final String name;

  Attendance.fromData(
    this.id,
    this.name,
    this.registered,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("events")
          .document(id)
          .collection("participants")
          .where('attended', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
                title: Text(name),
                elevation: 0,
              ),
              body: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.cyan[50],
                    ),
                  ),
                ),
              ));
        return _buildPage(
            context, id, registered, snapshot.data.documents.length, name);
      },
    );
  }

  Widget _buildPage(BuildContext context, id, registered, remaining, name) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(name),
        elevation: 0,
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _getCountBox("Present", remaining),
                          Padding(
                            padding: const EdgeInsets.only(top: 64.0),
                            child: Container(
                              color: Colors.grey[300],
                              width: 2,
                              height: 80,
                            ),
                          ),
                          _getCountBox("Remaining", registered),
                        ],
                      ),
                      _getButtons(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCountBox(String heading, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
      child: Column(
        children: <Widget>[
          Text(
            heading.toUpperCase(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 64,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getButtons(BuildContext context) {
    return (MediaQuery.of(context).orientation == Orientation.portrait)
        ? Column(
            children: <Widget>[
              SizedBox(
                height: 160,
              ),
              _getScanButton(),
              SizedBox(
                height: 16,
              ),
              _getListButton(),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _getScanButton(),
                SizedBox(
                  width: 32,
                ),
                _getListButton(),
              ],
            ),
          );
  }

  Widget _getScanButton() {
    if (canScan) {
      return Builder(
        builder: (BuildContext context) {
          return RaisedButton.icon(
            color: Theme.of(context).accentColor,
            icon: Icon(
              Icons.center_focus_weak,
              color: Colors.white,
            ), //`Icon` to display
            label: Text(
              'Scan QR Code',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ), //`Text` to display
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onPressed: () async {
              if (canScan) {
                await scan(id, context);
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "You don't have access to scan.",
                  ),
                ));
              }
            },
          );
        },
      );
    }
    return Builder(builder: (BuildContext context) {
      return Container();
    });
  }

  Widget _getListButton() {
    if (canGetList) {
      return Builder(
        builder: (BuildContext context) {
          return RaisedButton.icon(
            color: Theme.of(context).accentColor,
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ), //`Icon` to display
            label: Text(
              'Get List',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ), //`Text` to display
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onPressed: () {
              if (canGetList) {
                getAttendeeList(context, id, name);
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "You don't have access to get list.",
                  ),
                ));
              }
            },
          );
        },
      );
    }
    return Builder(builder: (BuildContext context) {
      return Container();
    });
  }
}
