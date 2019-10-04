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
*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _openLabBox();

    //you can change it
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
    gettingData();
    List temp = box.get('d');
    if (temp == null) {
      temp = [];
    }
    StaticVars.downloadedLabs = temp;
  }

  Future<void> gettingData() async {
    var pathsLists = await Hive.openBox('pathsLists');
    int length = pathsLists.values.length;
  }
}
