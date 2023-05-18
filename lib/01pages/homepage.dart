import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/wcardpage.dart';

import 'cardpage.dart';
import 'fingerpage.dart';
import 'printpage.dart';
import 'testpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: const Text("Menu POS"),
      ),
      body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            WCarPage(
                pElevation: 10,
                pFun: () => processMethod('Card'),
                pImg: 'assets/images/finger.png',
                pName: 'Card'),
            WCarPage(
                pElevation: 10,
                pFun: () => processMethod('Print'),
                pImg: 'assets/images/POS.png',
                pName: 'Print'),
            WCarPage(
                pElevation: 10,
                pFun: () => processMethod('Finger'),
                pImg: 'assets/images/finger.png',
                pName: 'Finger'),
            WCarPage(
                pElevation: 10,
                pFun: () => processMethod('Test'),
                pImg: 'assets/images/finger.png',
                pName: 'Test'),
          ]),
    );
  }
}
