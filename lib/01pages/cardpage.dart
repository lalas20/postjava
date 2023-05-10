import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  TextEditingController txtLectura = TextEditingController();

  void _readyCard() {}

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
                onPressed: _readyCard, child: const Text('lee captura')),
          ],
        ),
      ),
    );
  }
}
