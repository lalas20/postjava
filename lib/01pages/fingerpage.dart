// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
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
  late StreamSubscription _streamSubscription;
  @override
  void initState() {
    // implement initState
    super.initState();
    // txtInicial.text = "Ejecutando";
  }

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

    // txtProcess.text = res ?? 'sin revisión';
    // setState(() {
    //   txtProcess.text = res ?? "sin revisión";
    //   //resul.fingerChannel.vResult = '';
    // });
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
  }

  void _startListener() {
    _streamSubscription =
        resul.cardChannel.event.receiveBroadcastStream().listen(_listenStream);
  }

  void _listenStream(value) {
    print('listen');
    Uint8List original = Uint8List.fromList(value);
    txtRespuesta.text = base64.encode(original);
    vHuella = base64.encode(original);
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
            // StreamBuilder(
            //   builder: ((BuildContext context, AsyncSnapshot<String> snapshot) {
            //     if (snapshot.hasData) {
            //       vHuella = snapshot.data ?? '';
            //       return Text(vHuella);
            //     } else {
            //       return const Text('sin data');
            //     }
            //   }),
            //   stream: resul.fingerChannel.capturFingerEvent(),
            // ),
            TextField(
              controller: txtProcess,
              readOnly: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _getFinger, child: const Text('Captura huella')),
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
