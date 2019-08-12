import 'package:flutter/material.dart';
import 'lab_builder.dart';

/*
this class works as a contanier to 
display the cards of the labs 
*=> the cards in this class is for the Engineering collage
*/
class EngeneeringCollege extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('كلية الهندسة'),
        centerTitle: true,
      ),
      body: LabBuilder(
        college: 'الهندسة',
      ),
    );
  }
}
