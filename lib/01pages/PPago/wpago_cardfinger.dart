import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/PPago/pago_provider.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:provider/provider.dart';

import '../../02service/channel/plataformchannel.dart';
import '../helper/util_constante.dart';
import '../helper/util_responsive.dart';

class WPagoCardFinger extends StatefulWidget {
  const WPagoCardFinger({super.key});
  @override
  State<WPagoCardFinger> createState() => _WPagoCardFingerState();
}

class _WPagoCardFingerState extends State<WPagoCardFinger> {
  TextEditingController txtCard = TextEditingController();
  TextEditingController txtfinger = TextEditingController();
  late UtilResponsive responsive;
  late PagoProvider provider;

  late StreamSubscription _streamSubscriptionCard;
  late StreamSubscription _streamSubscriptionFinger;
  final resul = PlaformChannel();

  void _findCard() {
    _streamSubscriptionCard = resul.emvChannel.event
        .receiveBroadcastStream()
        .listen(_listenStreamCard);
    resul.emvChannel.emvSearch();
  }

  void _listenStreamCard(value) async {
    txtCard.text = value;
    provider.getCardFinger();
  }

  void _findFinger() {
    _streamSubscriptionFinger = resul.fingerChannel.event
        .receiveBroadcastStream()
        .listen(_listenStreamFinger);
    resul.fingerChannel.captureFingerISO();
  }

  void _listenStreamFinger(value) {
    print('listen');
    Uint8List original = Uint8List.fromList(value);
    txtfinger.text = base64.encode(original);
  }

  @override
  void dispose() {
    resul.fingerChannel.dispose();
    resul.cardChannel.dispose();
    super.dispose();
  }

  // Widget _cboAcount() {
  //   return DropdownButton(items: items, onChanged: onChanged)
  // }

  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
    provider = Provider.of<PagoProvider>(context);

    return Container(
      width: responsive.vAncho - 50,
      decoration: BoxDecoration(color: UtilConstante.colorFondo),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: txtCard,
                  readOnly: true,
                ),
              ),
              WBtnConstante(
                pName: "",
                fun: _findCard,
                ico: const Icon(Icons.find_in_page),
              )
            ],
          ),
          //_cboAcount(),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: txtfinger,
                  readOnly: true,
                ),
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
