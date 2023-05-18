import 'package:flutter/material.dart';
import 'package:postjava/01pages/cardpage.dart';
import 'package:postjava/01pages/fingerpage.dart';
import 'package:postjava/01pages/homepage.dart';
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
        title: 'PRODEM TEST POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const HomePage() //const MyHomePage(title: 'Pruebas de POS'),
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
                    SizedBox(
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () => processMethod('Card'),
                          child: const Text("Card")),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () => processMethod('Print'),
                          child: const Text("Print")),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () => processMethod('Finger'),
                          child: const Text("Finger")),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 100,
                      child: ElevatedButton(
                          onPressed: () => processMethod('Test'),
                          child: const Text("Test")),
                    )
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
