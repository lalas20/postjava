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
  final resul = PlaformChannel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //final resul = PlaformChannel();
    resul.fingerChannel.inicilizaFinger();
    txtInicial.text = "Ejecutando";
  }

  void _getFinger() async {
    final res = await resul.fingerChannel.captureFingerISO();
    setState(() {
      txtProcess.text = res ?? "sin revisión";
    });
  }

  void capturFinger() {
    final res = resul.fingerChannel.capturFinger();
    setState(() {
      txtProcess.text = res as String;
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
            TextField(
              controller: txtProcess,
              readOnly: true,
            ),
            ElevatedButton(
                onPressed: _getFinger, child: const Text('Captura huella'))
          ],
        ),
      ),
    );
  }
}
