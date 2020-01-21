import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ivr_labs/paths.dart';

/*
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
  //the hash map of the faviarot labs 
  static HashMap<String, List<Paths>> labsMap;
  static bool isClicked = false;
  //this list is just to store the names of labs that have been opened
  static List downloadedLabs;
  static List<Paths> expListToPush;
  static List<String> documentsIDs;
  static List<DocumentSnapshot> searchingList;
  static List<DocumentSnapshot> streemList;
  static void add() {
    if (labsMap == null) {
      labsMap = new HashMap();
    }
    labsMap[currentLabName] = paths;
  }

  static void addToStreemList(DocumentSnapshot document) {
    if (streemList == null) {
      streemList = [];
      documentsIDs = [];
    }
    if (!documentsIDs.contains(document.documentID)) {
      streemList.add(document);
      documentsIDs.add(document.documentID);
    }
  }

  static bool contains(String lab) {
    return labsMap.containsKey(lab);
  }

  static List<Paths> myList(String lab) {
    return labsMap[lab];
  }
}
