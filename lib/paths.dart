class Paths {
  String expName, expNumber;
  String exp_link, report_link, video_link;
  String exp_path, report_path;
  bool fab_maker;

  Paths({
    this.expName,
    this.expNumber,
    this.exp_link,
    this.report_link,
    this.video_link,
    this.fab_maker,
  });

  String toString() {
    String result =
        'expName : $expName \nexpNumber : $expNumber \nexpLinke : $exp_link \neportLink : $report_link \nvideo : $video_link';

    return result;
  }
}
