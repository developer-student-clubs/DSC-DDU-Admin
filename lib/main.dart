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
      theme: ThemeData(
        primaryColor: Colors.blue[300],
        accentColor: Colors.red,
        fontFamily: 'Montserrat'
      ),
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
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text(
              'Event Manager'
            ),
          ),
          actions: <Widget>[Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _getSignOutIcon(),
          )],
          automaticallyImplyLeading: false,
          elevation: 0,
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                child: Container(
                  color: Colors.white,
                  child: EventList(),
                ),
              ),
            ),
          ],
        ),
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
