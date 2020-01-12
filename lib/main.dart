// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
import 'package:dsc_event_adder/add_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dsc_event_adder/login_page.dart';
import 'package:dsc_event_adder/sign_in.dart';
import 'package:dsc_event_adder/eventList.dart';

enum ConfirmAction { CANCEL, ACCEPT }

void main() {
  runApp(
    MaterialApp(
      title: 'Event Manager',
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    if(isSignedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Event Manager'),
          actions: <Widget>[_getSignOutIcon()],
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return AddEvent();
              }
            ));
          },
        ),
        body: EventList(),
      );
    }
    else {
      return LoginPage();
    }
  }

  IconButton _getSignOutIcon() {
    if (isSignedIn) {
      return IconButton(
        icon: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        onPressed: () {
          if (!isSignedIn) {
            return true;
          }
          return showDialog<ConfirmAction>(
            context: context,
            barrierDismissible: false, // user must tap button for close dialog!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sign Out'),
                content: const Text('Are you sure you want to Sign Out?'),
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
                      signOutGoogle();
                      Navigator.of(context).pop(ConfirmAction.ACCEPT);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              }),
                          ModalRoute.withName('/')
                      );
                    },
                  )
                ],
              );
            },
          );
        },
      );
    }
    return IconButton(
      icon: Icon(
        Icons.exit_to_app,
        color: Colors.blue,
      ),
      onPressed: () {},
    );
  }
}
