import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/epx_viewer.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';

class LabBuilder extends StatelessWidget {
  String college, labName;
  var context;
  LabBuilder({this.college, this.labName});
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _cardBuilder();
  }

  Widget _cardBuilder() {
    return StreamBuilder(
      stream: Firestore.instance.collection(college).snapshots(),
      builder: (context, snapShots) {
        if (snapShots.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }
        if (snapShots.hasError || snapShots.data == null) {
          print('error happened');
          return Center(child: Text('error massage'));
        }
        return ListView.builder(
          itemExtent: 80.0,
          itemCount: snapShots.data.documents.length,
          itemBuilder: (context, index) {
            return _listBuilder(snapShots.data.documents[index]);
          },
        );
      },
    );
  }

  Widget _listBuilder(document) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: ListTile(
          onTap: () {
            _navigator(document);
          },
          title: Text(
            ': المختبر',
            textAlign: TextAlign.end,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              document.documentID,
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ),
    );
  }

  void _navigator(document) {
    Future<QuerySnapshot> d = Firestore.instance
        .collection(college)
        .document(document.documentID)
        .collection('exp')
        .getDocuments();
    d.then((onValue) {
      if (Vars.currentLabName == null ||
          Vars.currentLabName != document.documentID) {
        Vars.paths = [];
        Vars.currentLabName = document.documentID;
      }
      _pathSetter(onValue.documents);
    });
  }

  void _pathSetter(List<DocumentSnapshot> documents) {
    if (Vars.paths.length == 0) {
      for (int i = 0; i < documents.length; i++) {
        Vars.paths.add(
          new Paths(
            exp_link: documents[i]['expLinke'],
            expName: documents[i]['expName'],
            expNumber: documents[i]['expNumber'],
            fab_maker: true,
            report_link: documents[i]['report_link'],
            video_link: documents[i]['video_link'],
          ),
        );
      }
    }
    if (Vars.paths.length > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Exp_viewer(
                    labName: Vars.currentLabName,
                    paths: Vars.paths,
                  )));
    }
  }
}
