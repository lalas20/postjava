import 'package:flutter/material.dart';
import 'package:postjava/01pages/PConfiguration/configuration_view.dart';
import 'package:postjava/01pages/PPago/pago_view.dart';
import 'package:postjava/01pages/emv_page.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/wcardpage.dart';

import 'cardpage.dart';
import 'fingerpage.dart';
import 'printpage.dart';
import 'testpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String route = '/HomePage';
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
    } else if (pClasse == 'Configuración') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConfigurationView()),
      );
    } else if (pClasse == 'EMV') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmvPage()),
      );
    } else if (pClasse == 'Pago') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PagoView()),
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
                pImg: UtilConstante.iCard,
                pName: 'Card'),
            WCarPage(
                pElevation: 10,
                pFun: () => processMethod('Print'),
                pImg: UtilConstante.iCard,
                pName: 'Print'),
            WCarPage(
                pElevation: 10,
                pFun: () => processMethod('Finger'),
                pImg: UtilConstante.iFinger,
                pName: 'Finger'),
            WCarPage(
                pElevation: 10,
                pFun: () => processMethod('Pago'),
                pImg: UtilConstante.iPago,
                pName: 'Pago'),
            WCarPage(
                pElevation: 10,
                pFun: () => processMethod('Configuración'),
                pImg: UtilConstante.iConfiguration,
                pName: 'Configuración'),
            WCarPage(
                pElevation: 10,
                pFun: () => processMethod('EMV'),
                pImg: UtilConstante.iConfiguration,
                pName: 'EMV'),
          ]),
    );
  }
}
