import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/src/models/theme.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.grey[600] : white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.isDarkMode ? white : grey),
          onPressed: ()=> Get.back(),
        ),
        title: Text(this.label.toString().split('|')[0], style: TextStyle(color: black),),
      ),
      body: Center(
        child: Container(
          height: 400.0,
          width: 300.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Get.isDarkMode ? white : Colors.grey[400]
          ),
          child: Text(this.label.toString().split('|')[1], style: TextStyle(color: Get.isDarkMode ? black : white, fontSize: 30.0),),
        ),
      ),
    );
  }
}