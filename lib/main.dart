import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/var.dart';
import 'package:path_provider/path_provider.dart';
import 'altatbeqea.dart';
import 'engineering_college.dart';
import 'package:ivr_labs/paths.dart';

void main() => runApp(MyApp());

/*
this class is just to navigate between the pages  
and set the needed initalisations for the Hive data base

*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _openLabBox();

    //add a controler somehow
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageView(
        children: <Widget>[
          AltatbeqeaCollege(),
          EngeneeringCollege(),
        ],
      ),
    );
  }

  Future<void> _openLabBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init('${dir.path}/hive');
    Hive.registerAdapter(PathsAdapter(), 0);
    var box = await Hive.openBox('labs');

    List temp = box.get('d');
    if (temp == null) {
      temp = [];
    }
    StaticVars.downloadedLabs = temp;
    gettingData();
  }

  //geting all the paths needed to lunch any lab
  Future<void> gettingData() async {
    StaticVars.labsMap = new HashMap();
    var pathsLists = await Hive.openBox('pathsLists');
    int length = StaticVars.downloadedLabs.length;
    var temp;
    for (int i = 0; i < length; i++) {
      temp = pathsLists.get(StaticVars.downloadedLabs[i].hashCode);
      if (temp != null) {
        List<Paths> temp2 = temp.cast<Paths>();
        StaticVars.labsMap[StaticVars.downloadedLabs[i]] = temp2;
      }
    }
  }
}
