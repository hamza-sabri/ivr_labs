import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ivr_labs/pdf_viewer.dart';

/*
this class returns a card when clicked opens the page PDF_Viewer
*/
class PDFViewerWithFAB extends StatefulWidget {
  final String urlpath, appBarTitle, reportFilePath, reportLink;

  //-----------------------------------------------------------------------------------------------------------------------------------------
  PDFViewerWithFAB({
    this.urlpath,
    this.appBarTitle,
    this.reportFilePath,
    this.reportLink,
  });
  @override
  _PDFViewerWithFABState createState() => _PDFViewerWithFABState();
}

class _PDFViewerWithFABState extends State<PDFViewerWithFAB> {
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
        builder: (context) => PDFViewer(
          urlpath: widget.reportFilePath,
          appBarTitle: widget.appBarTitle,
          reportLink: widget.reportLink,
        ),
      ),
    );
  }
}
