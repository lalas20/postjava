import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/util_constante.dart';

class WPagoQR extends StatelessWidget {
  const WPagoQR({super.key, required this.imgQR});
  final String imgQR;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = const Base64Decoder().convert(imgQR);
    return Container(
      child: Column(
        children: [
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
          )
        ],
      ),
    );
  }
}
