import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/validation.dart';
import 'package:ivr_labs/var.dart';

class UserPage extends StatefulWidget {
  String college, labName, imageURL;
  int index = 0;
  TextStyle style = new TextStyle(
    color: Colors.white,
  );
  UserPage({
    this.college,
    this.labName,
    this.imageURL,
  });
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  GeneralMethods _generalMethods;
  String expName, expNumber, expLink, reportLink, videoLink;
  List<TextEditingController> controllers = [];
  var context;
  @override
  Widget build(BuildContext context) {
    _addControlers();
    _generalMethods = new GeneralMethods();
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.labName),
        centerTitle: true,
      ),
      body: _myBody(),
    );
  }

  void _addControlers() {
    for (int i = 0; i < 5; i++) {
      controllers.add(TextEditingController());
    }
  }

  Widget _myBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _myImage(),
          _textBuilder('* exp name :', 0),
          _textBuilder(' exp number :', 1),
          _textBuilder('* exp link :', 2),
          _textBuilder('report link :', 3),
          _textBuilder('video link :', 4),
          _myRow(),

          // _myContainer(),
          //add tow buttons and connect this page with the firebase
          //search for how to make the cursore move to the next cell after finsishing
        ],
      ),
    );
  }

  Widget _myRow() {
    return Container(
      width: double.infinity,
      height: 140,
      alignment: Alignment.bottomCenter,
      child: Row(
        children: <Widget>[
          _previousButton(),
          _saveButton(),
          _nextButton(),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Text(
            'save',
            style: widget.style,
          ),
          color: Colors.blue,
          onPressed: () {
            _generalMethods.toastMaker(_generalMethods.validation().toString());
            if (_generalMethods.validation()) {
              _generalMethods.toastMaker('validated');
              _pushToFirebase();
              StaticVars.expListToPush = [];
            }
          },
        ),
      ),
    );
  }

  Widget _previousButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text('previous', style: widget.style),
        color: Colors.blue,
        onPressed: () {
          widget.index--;
          if (widget.index < 0) {
            widget.index = 0;
          }
          showDataAt();
        },
      ),
    );
  }

  void showDataAt() {
    if (widget.index >= StaticVars.expListToPush.length) {
      return;
    }
    setState(
      () {
        controllers[0].text = StaticVars.expListToPush[widget.index].expName;
        controllers[1].text = StaticVars.expListToPush[widget.index].expNumber;
        controllers[2].text = StaticVars.expListToPush[widget.index].exp_link;
        controllers[3].text =
            StaticVars.expListToPush[widget.index].report_link;
        controllers[4].text = StaticVars.expListToPush[widget.index].video_link;
      },
    );
  }

  Widget _nextButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text(
          'next',
          style: widget.style,
        ),
        color: Colors.blue,
        onPressed: () {
          setState(() {
            widget.index++;
            showDataAt();
            StaticVars.expListToPush.add(new Paths(
              expName: expName,
              exp_link: expLink,
              expNumber: expNumber,
              report_link: reportLink,
              video_link: videoLink,
            ));
            for (int i = 0; i < 5; i++) {
              controllers[i].text = '';
            }
            print(StaticVars.expListToPush);
          });
        },
      ),
    );
  }

  Widget _myImage() {
    bool canDownloaded =
        (widget.imageURL != null && widget.imageURL.length > 10);
    return Center(
      child: canDownloaded
          ? FadeInImage.assetNetwork(
              image: widget.imageURL,
              placeholder: 'lib/photos/lamb_loading.gif',
              width: 180,
              height: 180,
            )
          : Image.asset(
              'lib/photos/lab_image.jpg',
              scale: 10,
              width: 180,
              height: 180,
            ),
    );
  }

  Widget _textBuilder(msg, order) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
      child: TextField(
        controller: controllers[order],
        autofocus: true,
        decoration: InputDecoration(labelText: msg),
        onChanged: (result) {
          _storingResult(result, order);
        },
      ),
    );
  }

  void _storingResult(result, order) {
    switch (order) {
      case 0:
        expName = result;
        break;
      case 1:
        expNumber = result;
        break;
      case 2:
        expLink = result;
        break;
      case 3:
        reportLink = result;
        break;
      case 4:
        videoLink = result;
        break;
    }
  }

//adding to the firebase starts from here ----------------------------------------------------------------------------------------
  void _pushToFirebase() {
    _addingImage();
    int length = StaticVars.expListToPush.length;
    String docID;
    var temp;
    for (int i = 0; i < length; i++) {
      temp = StaticVars.expListToPush[i];
      docID = _getId(temp.expNumber);
      docID == null ? _pushWithNull(temp) : _pushWithOutNull(temp, docID);
    }
    // _toastMaker('saving done');
  }

  void _addingImage() async {
    await Firestore.instance
        .collection(widget.college)
        .document(widget.labName)
        .setData({'image': widget.imageURL});
  }

  void _pushWithOutNull(temp, docID) async {
    if (temp.video_link == null) {
      await Firestore.instance
          .collection(widget.college)
          .document(widget.labName)
          .collection('exp')
          .document(docID)
          .setData({
        'expLink': temp.exp_link,
        'expName': temp.expName,
        'expNumber': temp.expNumber,
        'report_link': temp.report_link,
      });
    } else {
      await Firestore.instance
          .collection(widget.college)
          .document(widget.labName)
          .collection('exp')
          .document(docID)
          .setData({
        'expLink': temp.exp_link,
        'expName': temp.expName,
        'expNumber': temp.expNumber,
        'report_link': temp.report_link,
        'video_link': temp.video_link,
      });
    }
  }

  void _pushWithNull(Paths temp) async {
    if (temp.video_link == null) {
      await Firestore.instance
          .collection(widget.college)
          .document(widget.labName)
          .collection('exp')
          .document()
          .setData({
        'expLink': temp.exp_link,
        'expName': temp.expName,
        'expNumber': temp.expNumber,
        'report_link': temp.report_link,
      });
    } else {
      await Firestore.instance
          .collection(widget.college)
          .document(widget.labName)
          .collection('exp')
          .document()
          .setData({
        'expLink': temp.exp_link,
        'expName': temp.expName,
        'expNumber': temp.expNumber,
        'report_link': temp.report_link,
        'video_link': temp.video_link,
      });
    }
  }

  String _getId(number) {
    switch (number) {
      case '1':
        return 'a';

        break;
      case '2':
        return 'aa';

        break;
      case '3':
        return 'aaa';

        break;
      case '4':
        return 'aaaa';

        break;
      case '5':
        return 'aaaaa';

        break;
      case '6':
        return 'aaaaaa';

        break;
      case '7':
        return 'aaaaaaa';

        break;
      case '8':
        return 'aaaaaaaa';

        break;
      case '9':
        return 'aaaaaaaaa';

        break;
      case '10':
        return 'b';

        break;
      case '11':
        return 'bb';

        break;
      case '12':
        return 'bbb';

        break;
      case '13':
        return 'bbbb';

        break;
      case '14':
        return 'bbbbb';

        break;
      case '15':
        return 'bbbbb';

        break;
      default:
        return null;
    }
  }
}
