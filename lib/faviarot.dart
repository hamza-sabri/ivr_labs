import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/data_collection.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/validation.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class FaviarotCreator extends StatefulWidget {
  final String labName;
  final bool isDownloaded;
  final DataCollection dataCollection;
  FaviarotCreator({
    this.labName,
    this.isDownloaded,
    @required this.dataCollection,
  });
  @override
  _FaviarotCreatorState createState() => _FaviarotCreatorState();
}

/*
 * this class needs no documintation
 * every method is simple and explains it selfe from the name
 */
class _FaviarotCreatorState extends State<FaviarotCreator> {
  String labName;
  bool isDownloaded;
  List<Paths> paths;
  bool loop = true;
  var box, labsList;
  GeneralMethods _generalMethods;
  DataCollection localDataCollection;

  @override
  void initState() {
    super.initState();
    localDataCollection = widget.dataCollection;
  }

  @override
  Widget build(BuildContext context) {
    _generalMethods = GeneralMethods(
      dataCollection: localDataCollection,
    );
    _getSuper();
    return _downloadedLikeButton();
  }

//getting the hive box and what ever data needed from the statfulWidget
  _getSuper() {
    box = Hive.box('labs');
    labsList = Hive.box('pathsLists');
    labName = widget.labName;
    isDownloaded = widget.isDownloaded;
    paths = paths;
  }

  Widget _downloadedLikeButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
      child: LikeButton(
        isLiked: isDownloaded,
        onTap: (isDownloaded) {
          if (!isDownloaded) {
            loop = true;
            return _downloadHandler();
          } else {
            loop = false;
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
    localDataCollection.downloadedLabs.remove(labName);
    box.put('d', localDataCollection.downloadedLabs);
    isDownloaded = !isDownloaded;
    loop = false;
    localDataCollection.deletingFlag = true;
    return isDownloaded;
  }

  Future<bool> _downloadHandler() async {
    if (labName != null && !isDownloaded) {
      paths = localDataCollection.paths;
      _startDownloading();
    }
    isDownloaded = !isDownloaded;
    return isDownloaded;
  }

  Future<void> _startDownloading() async {
    _generalMethods.toastMaker('downloading');
    localDataCollection.deletingFlag = false;
    for (var path in paths) {
      try {
        if (loop) {
          await _downloadingFiles(path.expLink, 'exp', path);
          await _downloadingFiles(path.reportLink, 'report', path);
          if (loop == false) {
            _generalMethods.toastMaker('downloading had been cut');
            break;
          }
        }
      } catch (e) {}
      _generalMethods.toastMaker('exp ${path.expNumber} has been  downladed');
    }
    localDataCollection.isClicked = false;
    if (loop) {
      _adder();
    }
  }

  void _adder() {
    _generalMethods.toastMaker('lab has been downloaded successfully');
    localDataCollection.downloadedLabs.add(labName);
    localDataCollection.currentLabName = labName;
    box.put('d', localDataCollection.downloadedLabs);
    labsList.put(labName.hashCode, paths);
    localDataCollection.add();
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
      type == 'exp' ? path.expPath = savedPath : path.reportPath = savedPath;
    } catch (e) {}
  }
}
