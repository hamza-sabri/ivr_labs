import 'package:flutter/material.dart';
import 'package:ivr_labs/database_helper.dart';
import 'package:ivr_labs/builder.dart';

void main() => runApp(MyApp());

/*
this class is just to lunch the app 
and to handel which page goes first
*/
class MyApp extends StatelessWidget {
  final DataBaseHelper _helper = new DataBaseHelper();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _homePage(),
    );
  }

  //returns a future builder after opening the hive box and retrive the university name from it
  Widget _homePage() {
    return FutureBuilder(
      future: _helper.universityHanddler(),
      builder: (context, snapShots) {
        if (snapShots.connectionState == ConnectionState.waiting) {
          return _helper.hiveHandler('universities');
        }
        if (snapShots.hasError) {
          return _helper.hiveHandler('No Internet!!!');
        }
        return _mainPage(snapShots);
      },
    );
  }

  //calling MyBuilder class with the right attriputes
  Widget _mainPage(var snapShots) {
    return MyBuilder(
      university: snapShots.data,
      from: 'univ',
      title: snapShots.data == 'univ' ? 'universities' : snapShots.data,
    );
  }
}
