import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';

class WPagoQR extends StatelessWidget {
  const WPagoQR(
      {super.key, required this.imgQR, required this.monto, required this.fun});
  final String imgQR;
  final double monto;
  final Function() fun;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = const Base64Decoder().convert(imgQR);
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Monto: $monto',
              style: TextStyle(color: UtilConstante.colorAppPrimario),
            ),
          ),
          Image.memory(
            bytes,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: child,
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(UtilConstante.iTest),
              );
            },
          ),
          WBtnConstante(
              pName: "Salir",
              fun: () {
                fun();
              })
        ],
      ),
    );
  }
}
