import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ivr_labs/data_collection.dart';
import 'package:ivr_labs/paths.dart';
import 'package:ivr_labs/validation.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class FaviarotCreator extends StatefulWidget {
  final String labID;
  final bool isDownloaded;
  final DataCollection dataCollection;
  FaviarotCreator({
    this.labID,
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
  String labID;
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
    labID = widget.labID;
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
    _generalMethods.toastMaker('جاري حذف المختبر');
    localDataCollection.downloadedLabs.remove(labID);
    box.put('d', localDataCollection.downloadedLabs);
    isDownloaded = !isDownloaded;
    loop = false;
    localDataCollection.deletingFlag = true;
    return isDownloaded;
  }

  Future<bool> _downloadHandler() async {
    if (labID != null && !isDownloaded) {
      paths = localDataCollection.paths;
      _startDownloading();
    }
    isDownloaded = !isDownloaded;
    return isDownloaded;
  }

  Future<void> _startDownloading() async {
    _generalMethods.toastMaker('جاري التحميل');
    localDataCollection.deletingFlag = false;
    for (var path in paths) {
      try {
      // to prevent opening a new lab while downloading
      localDataCollection.isClicked = true;
        if (loop) {
          await _downloadingFiles(path.expLink, 'exp', path);
          await _downloadingFiles(path.reportLink, 'report', path);
          if (loop == false) {
            _generalMethods.toastMaker('تم قطع التحميل');
            break;
          }
        }
      } catch (e) {}
      _generalMethods.toastMaker('تم تحميل التجربة رقم (${path.expNumber})');

    }
     //to enable opening labs after downloading
      localDataCollection.isClicked = false;
    if (loop) {
      _adder();
    }
  }

  void _adder() {
    final namesBox = Hive.box('names');
    String name = namesBox.get(localDataCollection.dumMap(labID));
    _generalMethods.toastMaker('تم تحميل \"$name\" بنجاح');
    localDataCollection.downloadedLabs.add(labID);
    localDataCollection.currentLabName = labID;
    box.put('d', localDataCollection.downloadedLabs);
    labsList.put(labID.hashCode, paths);
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
      savedPath = '${dir.path}/$labID${path.expName}$type.pdf';
      await dio.download(url, savedPath, onReceiveProgress: (rec, total) {});
      type == 'exp' ? path.expPath = savedPath : path.reportPath = savedPath;
    
    } catch (e) {}
  }
}
