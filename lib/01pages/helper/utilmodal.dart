import 'package:flutter/material.dart';

import 'util_constante.dart';

class UtilModal {
  static Future mostrarDialogoSinCallback(BuildContext context, String title) {
    return showDialog(
      barrierColor: UtilConstante.colorAppPrimario,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          backgroundColor: Colors.white, //bodyColor,
          title: Text(
            title,
            style: TextStyle(
                color: UtilConstante.bodyColor,
                fontSize: 14,
                fontFamily: 'Poppins',
                decoration: TextDecoration.none),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 10.0,
                backgroundColor: UtilConstante.headerColor,
                color: UtilConstante.bodyColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
