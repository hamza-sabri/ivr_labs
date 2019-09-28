import 'dart:collection';

import 'package:ivr_labs/paths.dart';

/*
this class is just to make the list of pathes and the current lab am in 
accsesable  from any other class by making them static  
*/
class StaticVars {
  static String currentLabName;
  static List<Paths> paths;
  static HashMap<String, List<Paths>> labsMap;
  static bool isClicked = false;
  static List downloadedLabs;
  static void add() {
    if (labsMap == null) {
      labsMap = new HashMap();
    }
    labsMap[currentLabName] = paths;
  }

  static bool contains(String lab) {
    return labsMap.containsKey(lab);
  }

  static List<Paths> myList(String lab) {
    return labsMap[lab];
  }
}
