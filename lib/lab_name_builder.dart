import 'package:flutter/material.dart';

class LabName extends StatefulWidget {
  final String name;

  LabName({this.name});

  @override
  _LabNameState createState() => _LabNameState();
}

class _LabNameState extends State<LabName> {
  TextStyle labNameStyle;

  @override
  Widget build(BuildContext context) {
    _dynamicText(context);
    return _labName(widget.name);
  }

  void _dynamicText(context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double size = 0;
    if (totalWidth >= 360 && totalWidth < 380) {
      size = (totalWidth / 110) + 13;
    } else if (totalWidth >= 380) {
      size = 18;
    } else {
      size = 14;
    }
    labNameStyle = new TextStyle(
      fontSize: size,
      color: Colors.white,
    );
  }

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
