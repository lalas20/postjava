import 'package:flutter/material.dart';

import '../02service/channel/plataformchannel.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController txtcontroller = TextEditingController();

  void _verificar() async {
    final resul = PlaformChannel();
    final res = await resul.testMethod.horaVersionChannel();
    setState(() {
      txtcontroller.text = res ?? "vacio";
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
              controller: txtcontroller,
            ),
            ElevatedButton(
                onPressed: _verificar, child: const Text('Datos de Prueba'))
          ],
        ),
      ),
    );
  }
}
