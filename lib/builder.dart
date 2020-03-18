import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/data_collection.dart';
import 'body_builder.dart';

/*
this class is the link between what is happening 
in the back seen and what will the user see */
class MyBuilder extends StatefulWidget {
  final String university, from, college, title;
  final bool isLab;
  final TextEditingController controller = new TextEditingController();
  final bool replacment;
  final DataCollection dataCollection;
  MyBuilder({
    this.university,
    this.college,
    this.from,
    this.title,
    this.isLab,
    this.replacment,
    @required this.dataCollection,
  });

  @override
  _MyBuilderState createState() => _MyBuilderState();
}

class _MyBuilderState extends State<MyBuilder> {
  bool searching;
  int searchingLength;
  DataCollection localDataCollection;
  @override
  void initState() {
    super.initState();
    localDataCollection = widget.dataCollection;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _customScaffold(),
      onWillPop: () async {
        localDataCollection.isClicked = false;
        return true;
      },
    );
  }

  Widget _customScaffold() {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title != null ? widget.title : ''),
          centerTitle: true,
          leading: (widget.replacment != null && widget.replacment)
              ? _myInkWell()
              : _normalBack()),
      body: (widget.isLab == null) ? _pageBody() : _pageBodyWithSearch(),
    );
  }

  Widget _pageBodyWithSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: _myFloating(),
    );
  }

  Widget _myFloating() {
    return FloatingSearchBar.builder(
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
    );
  }

  //just to call the BodyBuilder class
  Widget _pageBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: BodyBuilder(
        from: widget.from,
        university: widget.university,
        college: widget.college,
        dataCollection: localDataCollection,
      ),
    );
  }

  //just to call the BodyBuilder class with the searching list
  Widget _searchingBody() {
    return BodyBuilder(
      streemList: localDataCollection.searchingList,
      from: widget.from,
      university: widget.university,
      college: widget.college,
      dataCollection: localDataCollection,
    );
  }

  void _changeHandler(String value) {
    localDataCollection.searchingList = [];
    for (var doc in localDataCollection.streemList) {
      if (doc['name'].contains(value)) {
        localDataCollection.searchingList.add(doc);
      }
    }

    setState(() {
      searching = value.length > 0;
      searchingLength = value.length;
    });
  }

  Widget _myInkWell() {
    if (widget.university == 'univ') return Text('');
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: InkWell(
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => new MyBuilder(
                dataCollection: localDataCollection,
                university: 'univ',
                from: 'univ',
                title: 'الجامعات',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _normalBack() {
    if (widget.university == 'univ') return Text('');
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: InkWell(
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onTap: () {
          localDataCollection.isClicked = false;
          Navigator.pop(context);
        },
      ),
    );
  }

}
