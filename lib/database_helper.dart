import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  
  DataBaseHelper() {
    _labHandler();
  }
  //to handel the student goes to which university
  Future<String> universityHanddler() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init('${dir.path}/hive');
    Box universityBox = await Hive.openBox('universityName');
    String temp = universityBox.get('university_name');
    if (temp == null || temp == '') {
      universityBox.put('university_name', 'univ');
    }
    return universityBox.get('university_name');
  }

  //when we are waiting hive to lunch and retrive data we call this method with any title we want
  Widget hiveHandler(String title) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: LinearProgressIndicator(),
    );
  }

  //opening the box for where the labs are stored and get a list of all the downloaded labs
  Future<void> _labHandler() async {
    try{
    WidgetsFlutterBinding.ensureInitialized();
    var dir = await getApplicationDocumentsDirectory();
    Hive.init('${dir.path}/hive');
    Hive.registerAdapter(PathsAdapter(), 0);}
    catch(e){
    }
    var box = await Hive.openBox('labs');

    List temp = box.get('d');
    if (temp == null) {
      temp = [];
    }
    StaticVars.downloadedLabs = temp;
    _gettingData();
  }

  //geting all the paths needed to lunch any lab if it's downloaded
  Future<void> _gettingData() async {
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
