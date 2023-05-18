// ignore_for_file: avoid_print, unused_field, unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import '../02service/channel/plataformchannel.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late StreamSubscription _streamSubscription;
  TextEditingController txtLectura = TextEditingController();
  String cardIC = '';
  final resul = PlaformChannel();

  void _researchICC() {
    _streamSubscription =
        resul.cardChannel.event.receiveBroadcastStream().listen(_listenStream);
    resul.cardChannel.infosearchICC();
  }

  void _clearTxt() {
    txtLectura.text = '';
  }

  void _startListener() {
    _streamSubscription =
        resul.cardChannel.event.receiveBroadcastStream().listen(_listenStream);
  }

  void _listenStream(value) {
    txtLectura.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lectura de Tarjeta"),
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

  @override
  void dispose() {
    resul.cardChannel.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }
}
