import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';

class GeneralMethods {
  bool validation() {
    Paths temp;
    if (StaticVars.expListToPush.length == 0) {
      return false;
    }
    for (int i = 0; i < StaticVars.expListToPush.length; i++) {
      temp = StaticVars.expListToPush[i];
      if (temp == null ||
          temp.expName == null ||
          temp.expName.length == 0 ||
          temp.exp_link == null ||
          temp.exp_link.length < 5) {
        return false;
      }
    }
    return true;
  }

  void toastMaker(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
