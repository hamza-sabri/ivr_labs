import 'package:flutter/material.dart';
import 'dialog.dart';
import 'engineering_college.dart';
import 'lab_builder.dart';

/*
this class works as a contanier to 
display the cards of the labs 
*=> the cards in this class is for Altatbeqea collage
*/
class AltatbeqeaCollege extends StatelessWidget {
  Icon forwordIcon = Icon(
    Icons.arrow_forward,
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: myAdder(context),
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

  //this method is called just for the ivr team members
  //it allows them to upload/update => the labs of any university
  Widget myAdder(context) {
    return FloatingActionButton(
      child: Icon(Icons.cloud_upload),
      onPressed: () {
        DialogCreator(resContext: context);
      },
    );
  }

  //this method is just to creat the arrow navgating us to the engineering collage page
  //you should add the controler when this button is clicked
  List<Widget> _myArow(BuildContext context) {
    List<Widget> myArrowList = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EngeneeringCollege()));
          },
          child: forwordIcon,
        ),
      )
    ];
    return myArrowList;
  }
}
