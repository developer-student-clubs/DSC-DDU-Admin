import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddNotification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddNotificationState();
  }
}

class AddNotificationState extends State<AddNotification> {
  File _image;

  final formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool showImageError = false;

  String title;
  String body;
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        showImageError = false;
      });
    }

    Future<String> uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }

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
                          decoration: new InputDecoration(
                              hintText: 'Enter Title Here..',
                              labelText: 'Title'),
                          onSaved: (String value) {
                            this.title = value;
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Title cannot be empty'
                                : null;
                          },
                        ), //eventName
                        TextFormField(
                          decoration: new InputDecoration(
                              hintText: 'Enter Body Here..', labelText: 'Body'),
                          onSaved: (String value) {
                            this.body = value;
                          },
                          validator: (value) {
                            return value.isEmpty
                                ? 'Total seats cannot be empty'
                                : null;
                          },
                        ),
                        TextFormField(
                          decoration: new InputDecoration(
                              hintText: 'enter Image Url or Upload Image..',
                              labelText: 'ImageUrl'),
                          onSaved: (String value) {
                            this.imageUrl = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'or',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        Card(
                          child: (_image != null)
                              ? Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  'assets/new_image.png',
                                  fit: BoxFit.fill,
                                ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          color: Theme.of(context).primaryColor,
                          splashColor: Theme.of(context).accentColor,
                          disabledTextColor: Colors.black,
                          disabledColor: Colors.grey,
                          child: Text(
                            'Upload Image',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                        Visibility(
                          child: Text(
                            '* Upload image',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          visible: showImageError,
                        ),
                        Padding(padding: EdgeInsets.all(15.0)),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          splashColor: Colors.red,
                          onPressed: () {
                            ProgressDialog pr = new ProgressDialog(context,
                                type: ProgressDialogType.Normal,
                                isDismissible: false,
                                showLogs: false);
                            pr.style(message: "Please Wait....");
                            pr.show();
                            if (formkey.currentState.validate()) {
                              formkey.currentState.save();
                              if (_image != null) {
                                uploadPic(context).then((value) {
                                  imageUrl = value;
                                  if (formkey.currentState.validate()) {
                                    Firestore.instance
                                        .collection('notifications')
                                        .document()
                                        .setData({
                                      'body': body,
                                      'title': title,
                                      'imageUrl': value,
                                    });
                                    Navigator.of(context).pop(this);
                                  }
                                });
                              } else {
                                if (formkey.currentState.validate()) {
                                  Firestore.instance
                                      .collection('notifications')
                                      .document()
                                      .setData({
                                    'body': body,
                                    'title': title,
                                    'imageUrl': this.imageUrl,
                                  });
                                  Navigator.of(context).pop(this);
                                }
                              }
                            } else {
                              _autoValidate = true;
                            }
                            pr.dismiss();
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
