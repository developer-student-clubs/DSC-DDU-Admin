import 'package:dsc_event_adder/add_event.dart';
import 'package:dsc_event_adder/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dsc_event_adder/login_page.dart';
import 'package:dsc_event_adder/sign_in.dart';
import 'package:dsc_event_adder/eventList.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum ConfirmAction { CANCEL, ACCEPT }

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blue[300],
          accentColor: Colors.red,
          fontFamily: 'Montserrat'),
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
  final String serverToken =
      'AAAAChH_RPM:APA91bGn9HQgQEDYB1idXmULCldISArID8OtFNu8hGEVQUB0ApBu3SD507eKHSACgkiXx5glhLK-55Q8UJggqAceMM2VnRmgT6Jk9xt05yVKXzte2FEOtalTCR0eRpMOjSjsIYu3-Tr7';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
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

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text('Event Manager'),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _getSendNotificationBtn(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _getSignOutIcon(),
            ),
          ],
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        floatingActionButton: new Builder(builder: (BuildContext context2) {
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
                      content: Text("You don't have access to add events")));
                }
              });
        }),
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
