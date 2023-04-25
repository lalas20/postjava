import 'package:flutter/material.dart';

import '../02service/channel/plataformchannel.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  final TextEditingController txtcontroller = TextEditingController();
  String vRespuesta = "";

  void printTest() async {
    final resul = PlaformChannel();
    //final res = await resul.printMethod.printTxt();
    final res = await resul.printMethod.printTxtMessage(txtcontroller.text);
    setState(() {
      vRespuesta = res ?? "IMPRIMIENDOOO...";
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
                onPressed: printTest, child: const Text('Imprime Prueba')),
            Text('resp: $vRespuesta'),
          ],
        ),
      ),
    );
  }
}
