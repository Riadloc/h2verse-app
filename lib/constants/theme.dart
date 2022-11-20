import 'package:flutter/material.dart';

final OutlineInputBorder kInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(
    color: Colors.grey.shade100,
    width: 1,
  ),
);

final OutlineInputBorder kInputFocusdBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(
    color: xPrimaryColor,
    width: 1,
  ),
);

const List<BoxShadow> kCardBoxShadow = [
  BoxShadow(
    offset: Offset(0, 10),
    blurRadius: 10,
    spreadRadius: 0,
    color: Color.fromRGBO(230, 230, 230, 0.1),
  )
];

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

const Color xPrimaryColor = Color(0xFF3491FA);

final ThemeData theme = ThemeData(
    backgroundColor: const Color.fromARGB(255, 247, 247, 247),
    primarySwatch: Colors.lightBlue,
    // visualDensity: VisualDensity.standard,
    inputDecorationTheme: InputDecorationTheme(
      border: kInputBorder,
      focusedBorder: kInputFocusdBorder,
      enabledBorder: kInputBorder,
    ),
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.black54,
    ),
    cardTheme: const CardTheme(
      elevation: 0,
      margin: EdgeInsets.all(0),
    ));
