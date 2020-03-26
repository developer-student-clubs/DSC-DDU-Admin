import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:default_path_provider/default_path_provider.dart';

void getAttendeeList(BuildContext context, String id, String name) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Creating file..."
      ),
    )
  );
  Firestore.instance.collection("events").document(id).collection("participants")
        .getDocuments().then((data) async {
    List<DocumentSnapshot> ds = data.documents;
    List<List<dynamic>> rows = List<List<dynamic>>();
    rows.add(["First Name","Last Name","College ID","Branch","Semester","Email ID","Phone Number","Attended"]);
    String email;
    print(ds.length);
    for (int i = 0; i <ds.length; i++) {
      List<dynamic> row = List();
      row.add(ds[i].data["firstName"]);
      row.add(ds[i].data["lastName"]);
      row.add(ds[i].data["collegeID"]);
      row.add(ds[i].data["branch"]);
      row.add(ds[i].data["sem"]);
      email = ds[i].data["qrCodeString"].toString();
      email = email.substring(0, email.length - 17);
      row.add(email);
      row.add(ds[i].data["phoneNumber"].toString());
      row.add(ds[i].data["attended"]);
      rows.add(row);
    }

    // await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    // bool checkPermission=await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    // if(checkPermission) {R
        String dir = (await DefaultPathProvider.getDownloadDirectoryPath)+ "/";
        String file = "$dir";
        File f = new File(file + name.replaceAll(' ','') + ".csv",);
        String csv = const ListToCsvConverter().convert(rows);
        //String header = "First Name,Last Name,College ID,Branch,Semester,Email ID,Phone Number,Attended\n";
        //await f.writeAsString(header);
        await f.writeAsString(csv).then((value) async{
          print(f.path);
           await OpenFile.open(f.path,type:"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        });
        
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       name + ".csv created at " + file
        //     ),
        //   )
        // );
//    }
  });
}