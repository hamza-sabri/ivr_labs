import 'package:flutter/material.dart';
import 'package:ivr_labs/paths.dart';
import 'altatbeqea.dart';
import 'engineering_college.dart';
import 'epx_viewer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  List<Paths> pathes = [];

  @override
  Widget build(BuildContext context) {
    paths();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: 
      // Exp_viewer(
      //   labName: 'any lab',
      //   paths: pathes,
      // ),

      PageView(
        children: <Widget>[
          AltatbeqeaCollege(),
          EngeneeringCollege(),
        ],
      ),
    );
  }

  void paths() {
    pathes = [];
    pathes.add(new Paths(
        exp_link: 'http://www.orimi.com/pdf-test.pdf',
        expNumber: '1',
        expName: 'nutens law',
        report_link:
            'https://www.escaux.com/rsrc/EscauxCustomerDocs/DRD_T38Support_AdminGuide/T38_TEST_PAGES.pdf',
        fab_maker: true,
        video_link: 'https://www.youtube.com/watch?v=Fn56lB-BTak'));

    pathes.add(new Paths(
        exp_link:
            'https://www.antennahouse.com/antenna1/wp-content/uploads/2017/10/Regression-Testing-Flyer-20Oct17.pdf',
        expNumber: '2',
        expName: 'any shit',
        report_link:
            'https://www.escaux.com/rsrc/EscauxCustomerDocs/DRD_T38Support_AdminGuide/T38_TEST_PAGES.pdf',
        fab_maker: true,
        video_link: 'https://www.youtube.com/watch?v=Fn56lB-BTak'));

    pathes.add(new Paths(
        exp_link:
            'https://www.escaux.com/rsrc/EscauxCustomerDocs/DRD_T38Support_AdminGuide/T38_TEST_PAGES.pdf',
        expNumber: '3',
        expName: 'any shit2',
        report_link:
            'https://www.escaux.com/rsrc/EscauxCustomerDocs/DRD_T38Support_AdminGuide/T38_TEST_PAGES.pdf',
        // video_link: 'https://www.youtube.com/watch?v=Fn56lB-BTak'
      ),
    );
  }
}
