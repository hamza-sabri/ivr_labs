import 'dart:collection';
import 'package:ivr_labs/paths.dart';

/**
 * this class is my biggest mistake in this project
 * or in any of my projects 
 * it must be deleted later on 
 * 
 * to simplify what this class is for its just a way 
 * oof making some attriputes accsseple from any point 
 * in the project the same values will be shared no matter
 * where you ask them to be
 * 
 * 
 * to solve this think of the inhereted widget it should do the same 
 * learn it then solve this shit
 */
class StaticVars {
  static String currentLabName;
  static List<Paths> paths;
  static List<Paths> labsList;
  static HashMap<String, List<Paths>> labsMap;
  static bool isClicked = false;
  static List downloadedLabs;
  static List<Paths> expListToPush;
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
