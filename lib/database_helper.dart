import 'dart:collection';
import 'package:hive/hive.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';
import 'package:path_provider/path_provider.dart';


class DataBaseHelper {

  Future<void> openLabBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init('${dir.path}/hive');
    Hive.registerAdapter(PathsAdapter(), 0);
    var box = await Hive.openBox('labs');

    List temp = box.get('d');
    if (temp == null) {
      temp = [];
    }
    StaticVars.downloadedLabs = temp;
    _gettingData();
  }

  //geting all the paths needed to lunch any lab
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