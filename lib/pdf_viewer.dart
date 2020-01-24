import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share/share.dart';

/*
this class is to open the PDF files to read and interact 
*/

class PDFViewer extends StatefulWidget {
  final String urlpath, appBarTitle, reportLink;
  PDFViewer({
    this.urlpath,
    this.appBarTitle,
    this.reportLink,
  });
  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  bool pdfGetted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          share();
        },
        child: Icon(Icons.share),
      ),
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

  void share() {
    final RenderBox box = context.findRenderObject();
    Share.share(widget.reportLink,
        subject: 'report of the \"${widget.appBarTitle}\" experiment',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
