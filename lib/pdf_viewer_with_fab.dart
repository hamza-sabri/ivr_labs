import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ivr_labs/pdf_viewer.dart';

/*
this class returns a card when clicked opens the page PDF_Viewer
*/
class PDF_Viewer_FAB extends StatefulWidget {
  String urlpath, appBarTitle, reportFilePath;

  //-----------------------------------------------------------------------------------------------------------------------------------------
  PDF_Viewer_FAB({
    Key key,
    this.urlpath,
    this.appBarTitle,
    this.reportFilePath,
  }) : super(key: key);
  @override
  _PDF_ViewerState createState() => _PDF_ViewerState();
}

class _PDF_ViewerState extends State<PDF_Viewer_FAB> {
  bool pdfGetted = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.appBarTitle),
        ),
        body: _myBody(),
        floatingActionButton: _myFAB(),
      ),
      onWillPop: () async {
        //do your thing here to make the love botton statfull
        return true;
      },
    );
  }

  //this method creats the fab for the expirments
  Widget _myFAB() {
    return FloatingActionButton(
      backgroundColor: Colors.amberAccent,
      child: Image.asset(
        'lib/photos/report.png',
        scale: 14,
      ),
      onPressed: () {
        _navigator();
      },
    );
  }

  //put the pdf reader on it's position
  Widget _myBody() {
    return Stack(
      children: <Widget>[
        _myPDFView(),
        !pdfGetted
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Offstage(),
      ],
    );
  }

  //opens the PDFView for urlPath in the super class
  Widget _myPDFView() {
    return PDFView(
      filePath: widget.urlpath,
      autoSpacing: true,
      swipeHorizontal: true,
      enableSwipe: true,
      pageSnap: true,
      onPageChanged: (currentPage, totalPages) {
        setState(() {
          pdfGetted = true;
        });
      },
    );
  }

  //this method navigates PDF_Viewer class
  void _navigator() {
    if (widget.reportFilePath == null) {
      return;
    }
    Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (context) => PDF_Viewer(
          urlpath: widget.reportFilePath,
          appBarTitle: widget.appBarTitle,
        ),
      ),
    );
  }
}
