// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../02service/channel/plataformchannel.dart';

class FingerPage extends StatefulWidget {
  const FingerPage({super.key});

  @override
  State<FingerPage> createState() => _FingerPageState();
}

class _FingerPageState extends State<FingerPage> {
  final txtInicial = TextEditingController();
  final txtProcess = TextEditingController();
  final txtRespuesta = TextEditingController();
  final resul = PlaformChannel();
  String vHuella = '';
  @override
  void initState() {
    // implement initState
    super.initState();
    //final resul = PlaformChannel();
    //resul.fingerChannel.inicilizaFinger();
    txtInicial.text = "Ejecutando";
  }

  @override
  void dispose() {
    resul.fingerChannel.dispose();
    super.dispose();
  }
  //

  void _getFinger() async {
    final res = await resul.fingerChannel.captureFingerISO();
    setState(() {
      txtProcess.text = res ?? "sin revisión";
      //resul.fingerChannel.vResult = '';
    });
  }

  void _getVerifyUser() async {
    final res = await resul.fingerChannel.verifyUser(vHuella);
    setState(() {
      txtRespuesta.text = res.verifyUserResult!.message.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: txtInicial,
              readOnly: true,
            ),
            StreamBuilder(
              builder: ((BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  vHuella = snapshot.data ?? '';
                  return Text(vHuella);
                } else {
                  return const Text('sin data');
                }
              }),
              stream: resul.fingerChannel.capturFingerEvent(),
            ),
            TextField(
              controller: txtProcess,
              readOnly: true,
            ),
            ElevatedButton(
                onPressed: _getFinger, child: const Text('Captura huella')),
            ElevatedButton(
                onPressed: _getVerifyUser, child: const Text('Envio')),
            TextField(
              controller: txtRespuesta,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  String convertBytesToHex(List<Uint8List> src) {
    if (src.isEmpty) {
      return '';
    } else {
      final buffer = StringBuffer();
      for (final bytes in src) {
        for (int i = 0; i < bytes.length; i++) {
          int value = bytes[i];
          String hex = value.toRadixString(16);
          if (hex.length == 1) {
            buffer.write('0');
          }
          buffer.write(hex);
        }
      }
      return buffer.toString();
    }
  }
}
