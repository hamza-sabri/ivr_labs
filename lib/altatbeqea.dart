import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/pdf_reader.dart';
import 'engineering_college.dart';
import 'lab_builder.dart';

class AltatbeqeaCollege extends StatelessWidget {
  List<Paths> pathes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('كلية التطبيقية'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EngeneeringCollege()));
              },
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          )
        ],
        centerTitle: true,
      ),
      body: LabBuilder(
        college: 'التطبيقية',
      ),
    );
  }
}
