import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/validation.dart';
import 'package:ivr_labs/var.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'epx_viewer.dart';

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

/**
 * this class needs no documintation
 * every method is simple and explains it selfe from the name
 */
class _FaviarotCreatorState extends State<FaviarotCreator> {
  String labName;
  bool isDownloaded;
  List<Paths> paths;
  var box, labsList;
  GeneralMethods _generalMethods = new GeneralMethods();

  @override
  Widget build(BuildContext context) {
    _getSuper();
    return _downloadedLikeButton();
  }

//getting the hive box and what ever data needed from the statfulWidget
  _getSuper() {
    box = Hive.box('labs');
    labsList = Hive.box('pathsLists');
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
          if (!isDownloaded) {
            widget.loop = true;
            return _downloadHandler();
          } else {
            widget.loop = false;
            return _deleteFilesFromDB();
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

  Future<bool> _deleteFilesFromDB() async {
    _generalMethods.toastMaker('deleting');
    StaticVars.downloadedLabs.remove(labName);
    box.put('d', StaticVars.downloadedLabs);
    isDownloaded = !isDownloaded;
    widget.loop = false;
    Exp_viewer.deletingFlag = true;
    return isDownloaded;
  }

  Future<void> _startDownloading() async {
    _generalMethods.toastMaker('downloading');
    Exp_viewer.deletingFlag = false;
    for (int i = 0; i < paths.length; i++) {
      try {
        if (widget.loop) {
          await _downloadingFiles(paths[i].exp_link, 'exp', paths[i]);
          await _downloadingFiles(paths[i].report_link, 'report', paths[i]);
          if (widget.loop == false) {
            _generalMethods.toastMaker('downloading had been cut');
            break;
          }
        }
      } catch (e) {}
      _generalMethods.toastMaker('exp $i has been  downladed');
    }
    if (widget.loop) {
      _adder();
    }
  }

  void _adder() {
    _generalMethods.toastMaker('lab has been downloaded successfully');
    StaticVars.downloadedLabs.add(labName);
    StaticVars.currentLabName = labName;
    box.put('d', StaticVars.downloadedLabs);
    labsList.put(labName.hashCode, paths);
    StaticVars.add();
  }

  Future<bool> _downloadHandler() async {
    if (labName != null && !isDownloaded) {
      paths = StaticVars.paths;
      _startDownloading();
    }
    isDownloaded = !isDownloaded;
    return isDownloaded;
  }

  Future<void> _downloadingFiles(String url, String type, Paths path) async {
    if (url == null || path == null || url.length < 10) {
      return;
    }
    Dio dio = new Dio();
    String savedPath;
    try {
      var dir = await getApplicationDocumentsDirectory();
      savedPath = '${dir.path}/$labName${path.expName}$type.pdf';
      await dio.download(url, savedPath, onReceiveProgress: (rec, total) {});
      type == 'exp' ? path.exp_path = savedPath : path.report_path = savedPath;
    } catch (e) {}
  }
}
