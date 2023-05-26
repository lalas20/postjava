import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:postjava/02service/helper/util_conextion.dart';

import '../../02service/channel/plataformchannel.dart';

class WPagoCardFinger extends StatefulWidget {
  const WPagoCardFinger({super.key});
  @override
  State<WPagoCardFinger> createState() => _WPagoCardFingerState();
}

class _WPagoCardFingerState extends State<WPagoCardFinger> {
  TextEditingController txtCard = TextEditingController();
  TextEditingController txtfinger = TextEditingController();
  late StreamSubscription _streamSubscription;
  final resul = PlaformChannel();

  void _findCard() {
    _streamSubscription =
        resul.cardChannel.event.receiveBroadcastStream().listen(_listenStream);
    resul.cardChannel.infosearchICC();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              TextFormField(
                controller: txtCard,
                readOnly: true,
              ),
              WBtnConstante(
                pName: "",
                fun: _findCard,
                ico: const Icon(Icons.find_in_page),
              )
            ],
          ),
          Row(
            children: [
              TextFormField(
                controller: txtfinger,
                readOnly: true,
              ),
              WBtnConstante(
                pName: "",
                fun: _findFinger,
                ico: const Icon(Icons.fingerprint),
              )
            ],
          )
        ],
      ),
    );
  }
}
