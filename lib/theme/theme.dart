import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = Color.fromARGB(255, 255, 153, 36);
  static Color BGcolor = Color.fromARGB(255, 255, 255, 255);


  static void setOsc(bool isOsc){
    if (isOsc == true) {
      //BGcolor = Color.fromARGB(255, 56, 56, 56);
    }else{
      BGcolor = Color.fromARGB(255, 255, 255, 255);;
    }
  }

  static final mainTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      elevation: 1
    ),
    scaffoldBackgroundColor: BGcolor,

    listTileTheme: ListTileThemeData(
      selectedColor: Colors.grey,
      contentPadding: EdgeInsets.all(20),
    ),

    iconTheme: IconThemeData(
      color: primary
    )
  );
}
