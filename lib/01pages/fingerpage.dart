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

  Stream<String> capturFingerEvent() {
    final res = resul.fingerChannel.capturFingerEvent();
    return res;
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
                  return Text('data: $snapshot.data');
                } else {
                  return const Text('sin data');
                }
              }),
              stream: capturFingerEvent(),
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
