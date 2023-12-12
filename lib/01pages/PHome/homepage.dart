// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:postjava/01pages/PConfiguration/configuration_view.dart';
import 'package:postjava/01pages/PHome/home_page_provider.dart';
import 'package:postjava/01pages/PMovimientos/last%20_moves_page.dart';
import 'package:postjava/01pages/PTipoPago/tipo_pago_view.dart';
import 'package:postjava/01pages/emv_page.dart';
import 'package:postjava/01pages/fingerpageDP.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/wappbar.dart';
import 'package:postjava/01pages/helper/wcardpage.dart';
import 'package:postjava/helper/util_preferences.dart';
import 'package:provider/provider.dart';
import '../cardpage.dart';
import '../helper/utilmodal.dart';
import '../printpage.dart';
import '../testpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String route = '/HomePage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageProvider provider;

  void processMethod(String pClasse) async {
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
        MaterialPageRoute(builder: (context) => const FingerPageDP()),
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
      if (await verificaPOSDevice()) {
        Navigator.of(context)
            .push(UtilConstante.customPageRoute(const TipoPagoView()));
      }
    } else if (pClasse == 'UltimoMovimiento') {
      if (await verificaPOSDevice()) {
        Navigator.of(context)
            .push(UtilConstante.customPageRoute(const LastMoves()));
      }
    }
  }

  Future<bool> verificaPOSDevice() async {
    bool respuesta = false;
    await provider.verificaPOSDevice();
    if (provider.resp.state != RespProvider.correcto.toString()) {
      respuesta = false;
      UtilModal.mostrarDialogoNativo(
          context,
          "Atención!",
          Text(
            provider.resp.message,
            style: TextStyle(color: UtilConstante.colorAppPrimario),
          ),
          "Aceptar",
          () {});

      //return;
    } else {
      respuesta = true;
    }
    return respuesta;
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomePageProvider>(context, listen: false);

    return Scaffold(
      appBar: WAppBar(
        pTitle: "Opciones",
        pSubTitle: UtilPreferences.getNamePos(),
      ),
      body: Container(
        decoration: BoxDecoration(color: UtilConstante.colorFondo),
        child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              /*  WCarPage(
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
                  pFun: () => processMethod('EMV'),
                  pImg: UtilConstante.iConfiguration,
                  pName: 'EMV'),
              WCarPage(
                  pElevation: 10,
                  pFun: () => processMethod('Finger'),
                  pImg: UtilConstante.iFinger,
                  pName: 'Finger'),
               */
              if (!UtilPreferences.getIsSetting())
                WCarPage(
                    pElevation: 10,
                    pFun: () => processMethod('Configuración'),
                    pImg: UtilConstante.isvgConfig,
                    pName: 'Configuración'),
              if (UtilPreferences.getIsSetting())
                WCarPage(
                    pElevation: 10,
                    pFun: () => processMethod('Pago'),
                    pImg: UtilConstante.isvgTipoPago,
                    pName: 'Tipo de Pago'),
              if (UtilPreferences.getIsSetting())
                WCarPage(
                    pElevation: 10,
                    pFun: () => processMethod('UltimoMovimiento'),
                    pImg: UtilConstante.isvgRpt,
                    pName: 'Ultimos Movimientos'),
            ]),
      ),
    );
  }
}
