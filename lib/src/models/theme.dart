import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color bluishClr = Color(0xff4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color black = Colors.black;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const darkHeaderClr = Color(0xFF424242);
const Color grey = Colors.grey;

class Themes{
  static final light =  ThemeData(   //app default theme
    backgroundColor: Colors.white,
    primaryColor: primaryClr,   //primary is responsible only for appBar and buttons
    brightness: Brightness.light,   //brightness responsible for background color and textColor, if background color is white then the text color will black && if background color is black (brightness.dark) then text color will white
  );

  static final dark =  ThemeData(
    backgroundColor: darkGreyClr,
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey
    )
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.w600,
        color: Get.isDarkMode ? white : black
      )
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? white : black
      )
  );
}
TextStyle get subTitleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[400]
      )
  );
}