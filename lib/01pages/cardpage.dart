import 'package:flutter/material.dart';
import 'package:postjava/02service/channel/card_channel.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  TextEditingController txtLectura = TextEditingController();

  @override
  void initState() {
    super.initState();
    CardChannel.instance.init();
  }

  void _researchICC() {
    CardChannel.instance.infosearchICC();
  }

  void _searchMagnetCard() {
    CardChannel.instance.searchMagnetCard();
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
            ElevatedButton(
              onPressed: _researchICC,
              child: const Text('lee captura'),
            ),
            ElevatedButton(
              onPressed: _searchMagnetCard,
              child: const Text('tarjeta Magnetica '),
            ),
          ],
        ),
      ),
    );
  }
}
