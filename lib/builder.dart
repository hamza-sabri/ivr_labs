import 'package:flutter/material.dart';
import 'package:ivr_labs/var.dart';
import 'body_builder.dart';

/*
this class is the link between what is happening 
in the back seen and what will the user see */
class MyBuilder extends StatelessWidget {
  final String university, from, college, title;
  MyBuilder({this.university, this.college, this.from, this.title});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _customScaffold(),
      onWillPop: () async {
        StaticVars.isClicked = false;
        return true;
      },
    );
  }

  //returning a scuffold with appBar
  Widget _customScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(title != null ? title : ''),
        centerTitle: true,
      ),
      body: _pageBody(),
    );
  }

  //calling the labBuilder class and start building the componant that will line in this page
  Widget _pageBody() {
    return BodyBuilder(
      from: from,
      university: university,
      college: college,
    );
  }
}
