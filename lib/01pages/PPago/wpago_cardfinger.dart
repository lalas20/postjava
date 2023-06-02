import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

  late UtilResponsive responsive;
  late PagoProvider provider;
  Image? image;
  String imagePath = '';

  GestureDetector? gestor;

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
    imagePath = value;
    File imgfile = File(value);
    image = Image.file(
      imgfile,
      fit: BoxFit.cover,
      width: responsive.anchoPorcentaje(50),
      height: responsive.altoPorcentaje(40),
    );
    setState(() {});
  }

  @override
  void dispose() {
    resul.fingerChannel.dispose();

    resul.cardChannel.dispose();
    super.dispose();
  }

  void _converBase64() async {
    print('imagePath');
    File imagefile = File(imagePath);
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string = base64.encode(imagebytes);

    print(base64string);

    var file =
        await File('/sdcard/dataFinger1.txt').writeAsString(base64string);
    //final vstring = await imagefile.readAsString();
    //print(vstring);
  }

  Widget fingerIco() {
    return GestureDetector(
      onTap: _findFinger,
      child: image == null
          ? Icon(
              Icons.fingerprint,
              size: 80,
              color: UtilConstante.colorAppPrimario,
            )
          : image!,
    );
  }

  // Widget _cboAcount() {
  //    return DropdownButton<>(items: items, onChanged: onChanged)
  //  }

  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
    provider = Provider.of<PagoProvider>(context);

    return Container(
      width: responsive.vAncho - 50,
      decoration: BoxDecoration(color: UtilConstante.colorFondo),
      child: Expanded(
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
            fingerIco(),
            /*Row(
              children: [
                Expanded(
                  child: image == null
                      ? const SizedBox(
                          height: 10,
                        )
                      : image!,
                ),
                WBtnConstante(
                  pName: "",
                  fun: _findFinger,
                  ico: const Icon(Icons.fingerprint),
                )
              ],
            ),*/
            WBtnConstante(
              pName: "Convert",
              fun: _converBase64,
            )
          ],
        ),
      ),
    );
  }
}
