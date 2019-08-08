import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'package:ivr_labs/var.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Exp_viewer extends StatelessWidget {
  List<DocumentSnapshot> documentsOfExperiments;
  String labName;
  List<Paths> paths;
  Exp_viewer({
    this.paths,
    this.labName,
    this.documentsOfExperiments,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(labName),
        centerTitle: true,
      ),
      body: PDF_File_Reader(
        paths: paths,
      ),
    );
  }
}

class MyLiqued extends StatefulWidget {
  List<DocumentSnapshot> documentsOfExperiments;
  List<Paths> paths;
  MyLiqued({this.documentsOfExperiments, this.paths});
  @override
  _MyLiquedState createState() => _MyLiquedState();
}

class _MyLiquedState extends State<MyLiqued> {
  Widget list;
  ListView myList;
  @override
  Widget build(BuildContext context) {
    _listBuilder();
    return LiquidPullToRefresh(
      onRefresh: () {
        setState(
          () {
            _onRefreshed();
            _listBuilder();
          },
        );
      },
      child: myList,
    );
  }

  void _listBuilder() {
    list = PDF_File_Reader(
      paths: widget.paths,
    );
    myList = new ListView(
      children: <Widget>[list],
    );
  }

  Future<void> _onRefreshed() async {
    Vars.paths = [];
    int loop = widget.documentsOfExperiments.length;
    if (Vars.paths.length == 0) {
      for (int i = 0; i < loop; i++) {
        Vars.paths.add(
          new Paths(
            exp_link: await widget.documentsOfExperiments[i]['expLinke'],
            expName: await widget.documentsOfExperiments[i]['expName'],
            expNumber: await widget.documentsOfExperiments[i]['expNumber'],
            fab_maker: true,
            report_link: await widget.documentsOfExperiments[i]['report_link'],
            video_link: await widget.documentsOfExperiments[i]['video_link'],
          ),
        );
      }
    }
  }
}
