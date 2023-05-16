// ignore_for_file: avoid_print

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

  @override
  void initState() {
    super.initState();
    resul.cardChannel.init();
  }

  void _researchICC() {
    _streamSubscription =
        resul.cardChannel.event.receiveBroadcastStream().listen(_listenStream);
    print('_researchICC: 28');
    resul.cardChannel.infosearchICC();
    print('_researchICC: 30');
  }

  void _startListener() {
    _streamSubscription =
        resul.cardChannel.event.receiveBroadcastStream().listen(_listenStream);
    print('_researchICC: 36');
  }

  void _listenStream(value) {
    print('_listenStream: 40 : $value');
    setState(() {
      cardIC = value;
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
              controller: txtLectura,
            ),
            // StreamBuilder(
            //   builder: ((BuildContext context, AsyncSnapshot<String> snapshot) {
            //     if (snapshot.hasData) {
            //       cardIC = snapshot.data ?? '';
            //       return Text(cardIC);
            //     } else {
            //       return const Text('sin data');
            //     }
            //   }),
            //   stream: CardChannel.instance.capturaCardIC(),
            //),
            // Value in text
            Text("Carid:  $cardIC: ".toUpperCase(),
                textAlign: TextAlign.justify),
            const SizedBox(
              height: 50,
            ),

            ElevatedButton(
              onPressed: _researchICC,
              child: const Text('lee captura'),
            ),
            ElevatedButton(
              onPressed: _startListener,
              child: const Text('tarjeta Magnetica '),
            ),
          ],
        ),
      ),
    );
  }
}
