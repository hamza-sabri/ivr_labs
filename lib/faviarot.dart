import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/var.dart';
import 'package:ivr_labs/var.dart' as prefix0;
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// FaviarotCreator
class FaviarotCreator extends StatefulWidget {
  String labName;
  bool isDownloaded;
  bool loop = true;
  List<Paths> paths;
  //--------------------------------------------------------------
  FaviarotCreator({
    this.labName,
    this.isDownloaded,
  });
  @override
  _FaviarotCreatorState createState() => _FaviarotCreatorState();
}

class _FaviarotCreatorState extends State<FaviarotCreator> {
  String labName;
  bool isDownloaded;
  List<Paths> paths;
  var box;
  @override
  Widget build(BuildContext context) {
    box = Hive.box('labs');
    _getSuper();
    return _downloadedLikeButton();
  }

  _getSuper() {
    labName = widget.labName;
    isDownloaded = widget.isDownloaded;
    paths = widget.paths;
  }

  Widget _downloadedLikeButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
      child: LikeButton(
        isLiked: isDownloaded,
        onTap: (isDownloaded) {
          if (isDownloaded == false) {
            widget.loop = true;
            return _downloadHandler();
          } else {
            widget.loop = false;
            return _deletFilesFromDB();
          }
        },
        likeBuilder: (isLiked) {
          return Icon(
            Icons.favorite,
            color: isLiked ? Colors.pinkAccent : Colors.white,
          );
        },
      ),
    );
  }

  Future<bool> _deletFilesFromDB() async {
    _toastMaker('deleating');
    StaticVars.downloadedLabs.remove(labName);
    box.put('d', StaticVars.downloadedLabs);

    isDownloaded = !isDownloaded;
    widget.loop = false;
    return isDownloaded;
  }

  void _getPaths() {
    paths = StaticVars.paths;
  }

  Future<void> _startDownloading() async {
    _toastMaker('downloading');
    for (int i = 0; i < paths.length; i++) {
      if (widget.loop) {
        await _downloadingFiles(paths[i].exp_link, 'exp', paths[i]);
        await _downloadingFiles(paths[i].report_link, 'report', paths[i]);
        if (widget.loop == false) {
          _toastMaker('downloading had been cut');
          break;
        }
      }
      _toastMaker('exp $i has been  downladed');
    }
    //-----------------------------------------------------------------
    if (widget.loop) {
      _toastMaker('lab has been downloaded sucscfully');
      StaticVars.downloadedLabs.add(labName);
      StaticVars.currentLabName = labName;
      box.put('d', StaticVars.downloadedLabs);
      StaticVars.add();
      //show a toast says that the download is done
    } else {
      //show a toast says that the download stoped
    }
  }

  Future<bool> _downloadHandler() async {
    if (labName != null && !isDownloaded) {
      _getPaths();
      _startDownloading();
    }
    isDownloaded = !isDownloaded;
    return isDownloaded;
  }

//this method is to download the pdf files and add them to the paths object
  Future<void> _downloadingFiles(String url, String type, Paths path) async {
    if (url == null || path == null) {
      return;
    }
    Dio dio = new Dio();
    String savedPath;
    try {
      var dir = await getApplicationDocumentsDirectory();
      savedPath = '${dir.path}/$labName${path.expName}$type.pdf';
      await dio.download(url, savedPath, onReceiveProgress: (rec, total) {});
      type == 'exp' ? path.exp_path = savedPath : path.report_path = savedPath;
    } catch (e) {
      print('my error is ${e.toString()}');
    }
  }

  void _toastMaker(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}