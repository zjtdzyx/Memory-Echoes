import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    
  );
}
