import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ivr_labs/user_page.dart';
import 'package:ivr_labs/var.dart';

class DialogCreator {
  String college, labName, url;
  var resContext;
  DialogCreator({this.resContext}) {
    StaticVars.expListToPush = [];
    _creatDialog(resContext);
  }

  _creatDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return _customAlertDialog(context);
      },
    );
  }

  Widget _customAlertDialog(context) {
    return AlertDialog(
      title: Text('updating page'),
      content: _dialogBody(),
      actions: <Widget>[
        SizedBox(
          width:
              260, //make it dependent on the width of the context and make this class extends stattlessWidget
          child: ListTile(
            leading: _buttonCreator(context, 'advices'),
            trailing: _buttonCreator(context, 'done'),
          ),
        )
      ],
    );
  }

  Widget _dialogBody() {
    return Container(
      height: 180,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _textBuilder('*college name', 'c'),
            _textBuilder('*lab name', 'l'),
            _textBuilder('photo of the lab', 'url'),
          ],
        ),
      ),
    );
  }

  Widget _textBuilder(msg, temp) {
    return TextField(
      autocorrect: true,
      autofocus: true,
      decoration: InputDecoration(labelText: msg),
      onChanged: (result) {
        if (temp == 'c') {
          this.college = result;
        } else if (temp == 'l') {
          this.labName = result;
        } else {
          this.url = result;
        }
      },
    );
  }

  Widget _buttonCreator(context, String msg) {
    return RaisedButton(
      child: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _openUserPage(context);
      },
    );
  }

  void _openUserPage(context) {
    if (validation()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserPage(college: college, labName: labName, imageURL: url),
        ),
      );
    }
  }

  bool validation() {
    if (college != null && labName != null) {
      college = college.trim();
      if (college == 'التطبيقية' || college == 'الهندسة') {
        if (!labName.contains('مختبر')) {
          String temp = ' مختبر ' + labName;
          labName = temp;
        }
        _toastMaker('start adding ...');
        return true;
      }
      _toastMaker('الكليات المسموحة تطبيقية او هندسة');
    }
    _toastMaker('قم بإدخال اسم الكلية و المختبر اوﻻ');

    return false;
  }

  void _toastMaker(String msg) {
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
