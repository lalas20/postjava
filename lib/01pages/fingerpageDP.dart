// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../02service/channel/plataformchannel.dart';

class FingerPageDP extends StatefulWidget {
  const FingerPageDP({super.key});

  @override
  State<FingerPageDP> createState() => _FingerPageDPState();
}

class _FingerPageDPState extends State<FingerPageDP> {
  final txtRespuesta = TextEditingController();
  Image? image;
  final resul = PlaformChannel();



  @override
  void dispose() {
    resul.fingerChannel.dispose();
    super.dispose();
  }
  //

  void _getName() async {
    final res=await resul.fingerChannel.captureNameDeviceDP();
    setState(() {
      txtRespuesta.text="name: ${res!.isEmpty ?" vacio": res}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Captura Huella DP"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: txtRespuesta,
              readOnly: true,
            ),

            ElevatedButton(
                onPressed: _getName,
                child: const Text('get huella byte txt')),

          ],
        ),
      ),
    );
  }
}
