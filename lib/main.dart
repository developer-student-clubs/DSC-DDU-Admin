import 'dart:io';

import 'package:dsc_event_adder/add_event.dart';
import 'package:dsc_event_adder/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dsc_event_adder/login_page.dart';
import 'package:dsc_event_adder/sign_in.dart';
import 'package:dsc_event_adder/eventList.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum ConfirmAction { CANCEL, ACCEPT }

GlobalKey<ScaffoldState> _mainSK;

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          primaryColor: Color.fromRGBO(66, 133, 244, 1),
          accentColor: Color.fromRGBO(219, 68, 55, 1),
          fontFamily: 'GoogleSans'),
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
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      alert: true,
      badge: true,
    ));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print("Ios Setting Regiatered");
    });
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _mainSK.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Press again to exit.",
          ),
        ),
      );
      showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button to close dialog
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exit App'),
            content: const Text('Are you sure you want exit?'),
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
                  exit(0);
                },
              )
            ],
          );
        },
      );
      return Future.value(false);
    }
    exit(0);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    _mainSK = new GlobalKey<ScaffoldState>();
    if (isSignedIn) {
      return WillPopScope(
        onWillPop: () {
          return onWillPop(context);
        },
        child: Scaffold(
          key: _mainSK,
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text('Event Manager'),
            ),
            actions: <Widget>[
              _getSendNotificationBtn(),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _getSignOutIcon(),
              ),
            ],
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
          floatingActionButton: canEdit
              ? new Builder(builder: (BuildContext context2) {
                  return new FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        if (canEdit) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return AddEvent();
                          }));
                        } else {
                          Scaffold.of(context2).showSnackBar(SnackBar(
                              content:
                                  Text("You don't have access to add events")));
                        }
                      });
                })
              : null,
          body: Column(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Container(
                    color: Colors.white,
                    child: EventList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
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
            barrierDismissible: false, // user must tap button to close dialog
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
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }), ModalRoute.withName('/'));
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

  Builder _getSendNotificationBtn() {
    return new Builder(builder: (BuildContext context) {
      return IconButton(
        icon: Icon(
          Icons.notifications,
        ),
        onPressed: () async {
          if (canNotify) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddNotification();
            }));
            print("Send Notifications");
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("You don't have access to send Notifications.")));
          }
        },
      );
    });
  }
}
