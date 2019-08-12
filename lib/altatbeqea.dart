import 'package:flutter/material.dart';
import 'engineering_college.dart';
import 'lab_builder.dart';

/*
this class works as a contanier to 
display the cards of the labs 
*=> the cards in this class is for Altatbeqea collage
*/
class AltatbeqeaCollege extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('كلية التطبيقية'),
        actions: _myArow(context),
        centerTitle: true,
      ),
      body: LabBuilder(
        college: 'التطبيقية',
      ),
    );
  }

  //this method is just to creat the arrow navgating us to the engineering collage page
  List<Widget> _myArow(BuildContext context) {
    List<Widget> myArrowList = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EngeneeringCollege()));
          },
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      )
    ];
    return myArrowList;
  }
}
