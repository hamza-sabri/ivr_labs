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

  String dumMap(String labID){
  if(labID == 'كلية العلوم')return 'college_of_science';
  if(labID == 'كلية الهندسة و التكنلوجيا')return 'college_of_engineering';
  if(labID == 'مختبر اتصالات تماثلية')return 'lab_of_communication';
  if(labID == 'مختبر الكترونيات القدرة')return 'lab_of_electronics';
  if(labID == 'مختبر ديجيتال')return 'lab_of_digital';
  if(labID == 'مختبر سيركت 1')return 'lab_sircut_1';
  if(labID == 'مختبر فيزياء 1')return 'lab_of_physics_1';
  if(labID == 'مختبر فيزياء 2')return 'lab_of_physics_2';
  return labID;
}

String realID(String labID){
  
  if(labID == 'college_of_science')return 'كلية العلوم';
  if(labID == 'college_of_engineering')return 'كلية الهندسة و التكنلوجيا';
  if(labID == 'lab_of_communication')return 'مختبر اتصالات تماثلية';
  if(labID == 'lab_of_electronics')return 'مختبر الكترونيات القدرة';
  if(labID == 'lab_of_digital')return 'مختبر ديجيتال';
  if(labID == 'lab_sircut_1')return 'مختبر سيركت 1';
  if(labID == 'lab_of_physics_1')return 'مختبر فيزياء 1';
  if(labID == 'lab_of_physics_2')return 'مختبر فيزياء 2';
  return labID;
}

}
