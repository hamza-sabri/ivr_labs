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
  String expLink;
  @HiveField(3)
  String reportLink;
  @HiveField(4)
  String videoLink;
  @HiveField(5)
  String expPath;
  @HiveField(6)
  String reportPath;

  Paths({
    this.expName,
    this.expNumber,
    this.expLink,
    this.reportLink,
    this.videoLink,
    this.expPath,
    this.reportPath,
  });


}