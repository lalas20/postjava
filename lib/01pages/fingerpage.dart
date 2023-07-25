// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
  Image? image;
  // = Image.file(
  //   File('/sdcard/20230601003441.bmp'),
  //   fit: BoxFit.cover,
  // );
  final resul = PlaformChannel();
  String vHuella = '';
  late StreamSubscription _streamSubscription;

  @override
  void dispose() {
    resul.fingerChannel.dispose();
    super.dispose();
  }
  //

  void _getFinger() {
    print('_getFinger:39');
    _streamSubscription = resul.fingerChannel.event
        .receiveBroadcastStream()
        .listen(_listenStream);
    resul.fingerChannel.captureFingerISO();
  }

  void _getFingerByte() {
    print('_getFinger:39');
    _streamSubscription = resul.fingerChannel.event
        .receiveBroadcastStream()
        .listen(_listenStreamByte);
    resul.fingerChannel.captureFingerISObyte();
  }

  void _getVerifyUser() async {
    final res = await resul.fingerChannel.verifyUser(vHuella);
    setState(() {
      txtRespuesta.text = res.verifyUserResult!.message.toString();
    });
  }

  void _clearTxt() {
    print('limpiar');
    txtRespuesta.text = '';
    txtInicial.text = '';
    txtProcess.text = '';
    image = null;
    setState(() {});
  }

//cadena huella
  void _listenStreamByte(value) {
    print('listen');
    Uint8List original = Uint8List.fromList(value);
    txtRespuesta.text = base64.encode(original);
    vHuella = base64.encode(original);
    print('vHuella:  $vHuella');
  }

//byte de huella
  void _listenStream(value) {
    File imgfile = File(value);
    image = Image.file(
      imgfile,
      fit: BoxFit.cover,
      width: 300,
      height: 300,
    );
    print('value $value');
    setState(() {});
    /*Uint8List original = Uint8List.fromList(value);
    print('_listenStream:  ${original.length}');
    print('_listenStream:  ${original.runtimeType}');
    print('_listenStream:  ${value.runtimeType}');

    txtRespuesta.text = 'imagen capturada'; // base64.encode(original);
    //vHuella = base64.encode(original);
    print('_listenStream:  $original');
    try {
      image = byteArrayToImage(original);
      //setState(() {});
    } catch (e) {
      print('e:  $e');
      image = null;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Captura Huella"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: txtInicial,
              readOnly: true,
            ),
            TextField(
              controller: txtProcess,
              readOnly: true,
            ),
            image == null ? const Text('sin imagen') : image!,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _getFinger, child: const Text('huella img')),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: _clearTxt, child: const Text('Limpiar')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: _getVerifyUser, child: const Text('Envio')),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('5961581'),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: _getFingerByte,
                child: const Text('get huella byte txt')),
            TextField(
              controller: txtRespuesta,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
