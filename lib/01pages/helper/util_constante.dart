import 'package:flutter/material.dart';

enum RespProvider { correcto, incorrecto }

class UtilConstante {
  static Color colorAppPrimario = const Color.fromRGBO(80, 99, 136, 88);
  static Color bodyColor = const Color(0XFF2196f3);
  static Color headerColor = const Color.fromRGBO(5, 112, 181, 88.0);

  static MaterialButton btnMaterial(String txtBtn, Function() onpressed) {
    return MaterialButton(
        child: Text(
          txtBtn,
          style: const TextStyle(color: Colors.white),
        ),
        color: UtilConstante.headerColor,
        elevation: 5,
        onPressed: () {
          onpressed();
        });
  }
}
