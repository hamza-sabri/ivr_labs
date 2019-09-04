/*
this class is the core of the data 
when extracted from the firebase it will be stored in 
a list of objects from this class 
so the structure of the data is formed the same as this class sugestes 
*/
class Paths {
  String expName, expNumber;
  String exp_link, report_link, video_link;
  String exp_path, report_path;

  Paths({
    this.expName,
    this.expNumber,
    this.exp_link,
    this.report_link,
    this.video_link,
  });
}
