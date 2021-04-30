import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Color(0xff0a00b6);
  Color primaryColor = Color(0xff6200ea);
  Color lightColor = Color(0xff9d46ff);

  BoxDecoration boxDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white54,
      );

  TextStyle redBoldStyle() => TextStyle(
        color: Colors.red.shade700,
        fontWeight: FontWeight.bold,
      );

  Widget showLogo() => Image.asset('images/eye.png');

  Widget titleH1(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: darkColor,
        ),
      );

  Widget titleH2(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: darkColor,
        ),
      );

  Widget titleH2White(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );

  Widget titleH3(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          //fontWeight:FontWeight.bold,

          color: darkColor,
        ),
      );

  Widget titleH3White(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          //fontWeight:FontWeight.bold,

          color: Colors.white54,
        ),
      );

  Widget titleH4(String string) {
    return Text(
      string,
      style: TextStyle(
        fontSize: 16,
        //fontWeight:FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  MyStyle();
}
