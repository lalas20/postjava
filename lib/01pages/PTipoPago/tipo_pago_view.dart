import 'package:flutter/material.dart';
import 'package:postjava/01pages/PPago/tipopago_cihuella.dart';
import 'package:postjava/01pages/PPago/tipopago_otrobanco.dart';
import 'package:postjava/01pages/PPago/tipopago_qr.dart';
import 'package:postjava/01pages/PPago/tipopago_tarjetahuella.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/wcardpage.dart';
import 'package:postjava/helper/util_preferences.dart';

import '../helper/wappbar.dart';

class TipoPagoView extends StatefulWidget {
  const TipoPagoView({super.key});
  static String route = "/TipoPagoView";

  @override
  State<TipoPagoView> createState() => _TipoPagoViewState();
}

class _TipoPagoViewState extends State<TipoPagoView> {
  _pageDireccion({required String pPage}) {
    if (pPage == 'QR') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const TipoPagoQR()),
      // );
      Navigator.of(context)
          .push(UtilConstante.customPageRoute(const TipoPagoQR()));
    } else if (pPage == 'CI') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const TipoPagoCiHuella()),
      // );
      Navigator.of(context)
          .push(UtilConstante.customPageRoute(const TipoPagoCiHuella()));
    } else if (pPage == 'TARJETA') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const TipoPagoTarjetaHuella()),
      // );
      Navigator.of(context)
          .push(UtilConstante.customPageRoute(const TipoPagoTarjetaHuella()));
    } else if (pPage == 'OTRO') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const TipoPagoOtroBanco()),
      // );
      Navigator.of(context)
          .push(UtilConstante.customPageRoute(const TipoPagoOtroBanco()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        pTitle: "Tipo Pago",
        pSubTitle: UtilPreferences.getNamePos(),
      ),
      backgroundColor: UtilConstante.colorFondo,
      body: Container(
        decoration: BoxDecoration(color: UtilConstante.colorFondo),
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.symmetric(vertical: 10),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            WCarPage(
                pElevation: 10,
                pFun: () => _pageDireccion(pPage: 'QR'),
                pImg: UtilConstante.isvgOtroBanco,
                pName: "Pago QR"),
            WCarPage(
                pElevation: 10,
                pFun: () => _pageDireccion(pPage: 'CI'),
                pImg: UtilConstante.isvgCI,
                pName: "Doc. Identidad"),
            WCarPage(
                pElevation: 10,
                pFun: () => _pageDireccion(pPage: 'TARJETA'),
                pImg: UtilConstante.isvgTarjeta,
                pName: "Tarjeta"),
            WCarPage(
                pElevation: 10,
                pFun: () => _pageDireccion(pPage: 'OTRO'),
                pImg: UtilConstante.isvgOtroBanco,
                pName: "Otro"),
          ],
        ),
      ),
    );
  }
}
