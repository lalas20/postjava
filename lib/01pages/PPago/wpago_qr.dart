import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class WPagoQR extends StatelessWidget {
  const WPagoQR({
    super.key,
    required this.monto,
    required this.fun,
    required this.imgTxt,
  });
  final String imgTxt;
  final double monto;
  final Function() fun;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            'Monto: $monto',
            style: TextStyle(color: UtilConstante.colorAppPrimario),
          ),
          PrettyQr(
            size: 250,
            data: imgTxt,
            errorCorrectLevel: QrErrorCorrectLevel.H,
            typeNumber: null,
            roundEdges: true,
            //image:AssetImage(UtilConstante.iprdBlue),
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
