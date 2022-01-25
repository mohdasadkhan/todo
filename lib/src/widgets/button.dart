import 'package:flutter/material.dart';
import 'package:getx/src/models/theme.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  MyButton({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: primaryClr,
        ),
        child: Text(text, style: TextStyle(color: white, ),),
      ),
    );
  }
}
