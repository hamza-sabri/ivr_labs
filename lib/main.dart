import 'package:flutter/material.dart';
import 'package:ivr_labs/database_helper.dart';
import 'altatbeqea.dart';
import 'engineering_college.dart';
void main() => runApp(MyApp());
/*
this class is just to navigate between the pages  
and set the needed initalisations for the Hive data base
*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataBaseHelper helper = new DataBaseHelper();
    helper.openLabBox();

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
}
