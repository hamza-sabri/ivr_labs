import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';


/*
this class is to open the PDF files to read and interact 
*/


class PDF_Viewer extends StatefulWidget {
  String urlpath, appBarTitle;
  PDF_Viewer({
    Key key,
    this.urlpath,
    this.appBarTitle,
  }) : super(key: key);
  @override
  _PDF_ViewerState createState() => _PDF_ViewerState();
}

class _PDF_ViewerState extends State<PDF_Viewer> {
  bool pdfGetted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.appBarTitle),
      ),
      body: _myBody(),
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
}
