import 'package:flutter/material.dart';
import 'altatbeqea.dart';
import 'engineering_college.dart';

void main() => runApp(MyApp());
/*
this class is just to navigate between the pages  
*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
