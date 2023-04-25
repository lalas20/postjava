import 'package:flutter/material.dart';
import 'package:postjava/01pages/cardpage.dart';
import 'package:postjava/01pages/fingerpage.dart';
import 'package:postjava/01pages/printpage.dart';
import 'package:postjava/01pages/testpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Pruebas de POS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // void _incrementCounter() async {
  //   final resul = PlaformChannel();
  //   //final vres = await resul.printMethod.printTxt();
  //   final vres = await resul.fingerChannel.inicilizaFinger();
  //   //resul.testMethod.horaVersionChannel();
  //   // ignore: avoid_print
  //   print(vres.toString());

  //   setState(() {
  //     _counter++;
  //   });
  // }

  void processMethod(String pClasse) {
    if (pClasse == 'Card') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CardPage()),
      );
    } else if (pClasse == 'Print') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PrintPage()),
      );
    } else if (pClasse == 'Finger') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FingerPage()),
      );
    } else if (pClasse == 'Test') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TestPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.baseline,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () => processMethod('Card'),
                        child: const Text("Card")),
                    ElevatedButton(
                        onPressed: () => processMethod('Print'),
                        child: const Text("Print"))
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () => processMethod('Finger'),
                        child: const Text("Finger")),
                    ElevatedButton(
                        onPressed: () => processMethod('Test'),
                        child: const Text("Test"))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
