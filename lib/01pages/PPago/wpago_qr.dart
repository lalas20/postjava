import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.imgQR});
  final String imgQR;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = const Base64Decoder().convert(imgQR);
    return Container(
      child: Column(
        children: [
          Image.memory(
            bytes,
          )
        ],
      ),
    );
  }
}
