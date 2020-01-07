import 'package:flutter/material.dart';

class LabName extends StatelessWidget {
  final String name;
  TextStyle labNameStyle;
  LabName({this.name});
  @override
  Widget build(BuildContext context) {
    _dynamicText(context);
    return _labName(name);
  }

  //making the text dynamic based on the width of the screen
  void _dynamicText(context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double size = (totalWidth / 110) + 13;
    labNameStyle = new TextStyle(
      fontSize: size,
      color: Colors.white,
    );
  }

  //this method is just to add the lab name to the card
  Widget _labName(String name) {
    return Positioned(
      bottom: 20,
      right: 10,
      left: 10,
      child: Container(
        color: Colors.black.withOpacity(.6),
        child: Center(
          child: Text(
            name,
            style: labNameStyle,
          ),
        ),
      ),
    );
  }
}
