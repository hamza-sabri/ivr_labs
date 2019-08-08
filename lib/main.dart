import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'altatbeqea.dart';
import 'engineering_college.dart';
import 'epx_viewer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  List<Paths> pathes = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: 

      PageView(
        children: <Widget>[
          AltatbeqeaCollege(),
          EngeneeringCollege(),
        ],
      ),
    );
  }
}
