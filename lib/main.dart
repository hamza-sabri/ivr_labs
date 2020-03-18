import 'package:flutter/material.dart';
import 'package:ivr_labs/data_collection.dart';
import 'package:ivr_labs/database_helper.dart';
import 'package:ivr_labs/builder.dart';

void main() => runApp(MyApp());

/*
this class is just to lunch the app 
and to handel which page goes first
*/
class MyApp extends StatelessWidget {
  final DataCollection dataCollection = DataCollection();
  
  @override
  Widget build(BuildContext context) {
  
  final DataBaseHelper _helper = new DataBaseHelper(dataCollection);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _homePage(_helper),
    );
  }

  //returns a future builder after opening the hive box and retrive the university name from it
  Widget _homePage(DataBaseHelper _helper) {
    return FutureBuilder(
      future: _helper.universityHanddler(),
      builder: (context, snapShots) {
        if (snapShots.connectionState == ConnectionState.waiting) {
          return _helper.hiveHandler('الجامعات');
        }
        if (snapShots.hasError) {
          return _helper.hiveHandler('لا يوجد اتصال بالانترنت');
        }
        return _mainPage(snapShots);
      },
    );
  }

  //calling MyBuilder class with the right attriputes
  Widget _mainPage(var snapShots) {
    return MyBuilder(
      university: snapShots.data.university,
      from: 'univ',
      title: snapShots.data.title,
      replacment: (snapShots.data.university != 'univ'),
      dataCollection: dataCollection,
    );
  }
}
