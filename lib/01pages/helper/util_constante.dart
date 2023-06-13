// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum RespProvider { correcto, incorrecto }

enum TipoPago { QR, TARJETA, DOC_IDENTIDAD }

class UtilConstante {
  static Color colorAppPrimario = const Color.fromRGBO(80, 99, 136, 88);
  //static Color bodyColor = const Color(0XFF2196f3);
  static Color headerColor = const Color.fromRGBO(5, 112, 181, 88.0);

  static Color btnColor = const Color.fromRGBO(0, 112, 175, 1);
  static Color colorBanner = const Color.fromRGBO(0, 112, 175, 1);

  static String iCard = "assets/images/card.png";
  static String iPos = "assets/images/POS.png";
  static String iFinger = "assets/images/finger.png";
  static String iTest = "assets/images/test.png";
  static String iConfiguration = "assets/images/test.png";
  static String iPago = "assets/images/pago.png";
  static String iLogo = "assets/images/logo.png";
  static String iLastMoves = "assets/images/lastMoves.png";

  static Color colorFondo = const Color.fromRGBO(221, 247, 233, 1);

  static String fondo = "assets/images/bg_fondo.jpg";

  static InputDecoration entrada(
      {String? hintText, String? labelText, Icon? icon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      icon: icon,
      prefixIconColor: Colors.red,
      floatingLabelStyle: TextStyle(
          color: UtilConstante.btnColor,
          fontSize: 18,
          fontWeight: FontWeight.bold),
      hintText: hintText,
      labelText: labelText,
      labelStyle: TextStyle(fontSize: 14.0, color: UtilConstante.btnColor),
      hintStyle: TextStyle(fontSize: 12.0, color: UtilConstante.btnColor),
    );
  }
}
