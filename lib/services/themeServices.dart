import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices{
  final _box = GetStorage();    //getStorage saves value in key and value -> "id": 1
  final _key = 'isDarkMode';

  _saveThemeToBox(bool isDarkMode)=> _box.write(_key, isDarkMode);

  bool _loadThemeFromBox() => _box.read(_key) ?? false;   //a ?? b -> if a contains some +ve values it will return true otherwise false;

  ThemeMode get theme=> _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(){
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}