import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ivr_labs/paths.dart';

class DataCollection {
  String currentLabName;
  List<Paths> paths;
  List<Paths> labsList;
  //the hash map of the faviarot labs
  HashMap<String, List<Paths>> labsMap;
  bool isClicked = false;
  //this list is just to store the names of labs that have been opened
  List downloadedLabs;
  List<Paths> expListToPush;
  List<String> documentsIDs;
  List<DocumentSnapshot> searchingList;
  List<DocumentSnapshot> streemList;

  bool deletingFlag = false, later = false;
  void add() {
    if (labsMap == null) {
      labsMap = new HashMap();
    }
    labsMap[currentLabName] = paths;
  }

  void addToStreemList(DocumentSnapshot document) {
    if (streemList == null) {
      streemList = [];
      documentsIDs = [];
    }
    if (!documentsIDs.contains(document.documentID)) {
      streemList.add(document);
      documentsIDs.add(document.documentID);
    }
  }

  bool contains(String lab) {
    return labsMap.containsKey(lab);
  }

  List<Paths> myList(String lab) {
    return labsMap[lab];
  }
}
