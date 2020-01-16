import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/var.dart';
import 'body_builder.dart';

/*
this class is the link between what is happening 
in the back seen and what will the user see */
class MyBuilder extends StatefulWidget {
  final String university, from, college, title;
  final bool isLab;
  final TextEditingController controller = new TextEditingController();
  final bool replacment;

  MyBuilder({
    this.university,
    this.college,
    this.from,
    this.title,
    this.isLab,
    this.replacment,
  });

  @override
  _MyBuilderState createState() => _MyBuilderState();
}

class _MyBuilderState extends State<MyBuilder> {
  bool searching;
  int searchingLength ;
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

  Widget _customScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title != null ? widget.title : ''),
        centerTitle: true,
        actions: <Widget>[
          (widget.replacment != null && widget.replacment)
              ? _myInkWell()
              : Text(''),
        ],
      ),
      body: (widget.isLab == null) ? _pageBody() : _pageBodyWithSearch(),
    );
  }

  Widget _myInkWell() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: InkWell(
        child: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => new MyBuilder(
                university: 'univ',
                from: 'univ',
                title: 'universities',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pageBodyWithSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: FloatingSearchBar.builder(
        controller: widget.controller,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return (searching == null || !searching)
              ? _pageBody()
              : _searchingBody();
        },
        onChanged: (String value) {
          _changeHandler(value);
        },
        leading: Icon(Icons.search),
        decoration: InputDecoration.collapsed(
          hintText: "Search...",
        ),
      ),
    );
  }

  //just to call the BodyBuilder class
  Widget _pageBody() {
    return BodyBuilder(
      from: widget.from,
      university: widget.university,
      college: widget.college,
    );
  }

  //just to call the BodyBuilder class with the searching list
  Widget _searchingBody() {
    return BodyBuilder(
      streemList: StaticVars.searchingList,
      from: widget.from,
      university: widget.university,
      college: widget.college,
    );
  }

  void _changeHandler(String value) {
    StaticVars.searchingList = [];
    for (var doc in StaticVars.streemList) {
      if (doc.documentID.contains(value)) {
        StaticVars.searchingList.add(doc);
      }
    }

    setState(() {
      searching = value.length > 0;
      searchingLength = value.length;
    });
  }
}
