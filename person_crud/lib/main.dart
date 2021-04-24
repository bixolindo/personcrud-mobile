import 'package:flutter/material.dart';
import 'package:person_crud/config/base_api.dart';
import 'package:person_crud/views/person_list.dart';

void main() {
  BaseAPI().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PersonCrud',
      theme: ThemeData(
        primarySwatch: primaryRed,
      ),
      home: PersonList(),
    );
  }

  static const MaterialColor primaryRed = MaterialColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xffffdfe4),
      100: Color(0xffe2bbc5),
      200: Color(0xffbf92a0),
      300: Color(0xff9e6a7a),
      400: Color(0xff864d60),
      500: Color(0xff6e3046),
      600: Color(0xff62293f),
      700: Color(0xff521f34),
      800: Color(0xff42142a),
      900: Color(0xff31081f),
    },
  );
  static const int _redPrimaryValue = 0xFF31081f;
}
