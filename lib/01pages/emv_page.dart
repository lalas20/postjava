import 'dart:async';

import 'package:flutter/material.dart';

import '../02service/channel/plataformchannel.dart';

class EmvPage extends StatefulWidget {
  const EmvPage({super.key});
  static String route = '/EmvPage';

  @override
  State<EmvPage> createState() => _EmvPageState();
}

class _EmvPageState extends State<EmvPage> {
  late StreamSubscription _streamSubscription;
  TextEditingController txtLectura = TextEditingController();
  String cardIC = '';
  final resul = PlaformChannel();

  void _researchICC() {
    _streamSubscription =
        resul.emvChannel.event.receiveBroadcastStream().listen(_listenStream);
    resul.emvChannel.emvSearch();
  }

  void _listenStream(value) {
    txtLectura.text = value;
  }

  void _clearTxt() {
    txtLectura.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EMV"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: txtLectura,
                readOnly: true,
              ),
              Text("Carid:  $cardIC: ".toUpperCase(),
                  textAlign: TextAlign.justify),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _researchICC,
                    child: const Text('tarjeta captura'),
                  ),
                  ElevatedButton(
                    onPressed: _clearTxt,
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
