/*
this class is the core of the data 
when extracted from the firebase it will be stored in 
a list of objects from this class 
so the structure of the data is formed the same as this class sugestes 
*/
import 'package:hive/hive.dart';
part 'paths.g.dart';
@HiveType()
class Paths {
  @HiveField(0)
  String expName;
  @HiveField(1)
  String expNumber;
  @HiveField(2)
  String exp_link;
  @HiveField(3)
  String report_link;
  @HiveField(4)
  String video_link;
  @HiveField(5)
  String exp_path;
  @HiveField(6)
  String report_path;

  Paths({
    this.expName,
    this.expNumber,
    this.exp_link,
    this.report_link,
    this.video_link,
  });

  String toString() {
    String result =
        'expName : $expName\nexpNumber : $expNumber\nexpLink : $exp_link\nreport_link : $report_link\nvideo_link : $video_link\nexp_path : $exp_path\nreport_path : $report_path';
    return result + '\n----------------------------------------------\n';
  }
}