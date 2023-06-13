import 'dart:math';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/PMovimientos/last_moves_provider.dart';
import 'package:postjava/01pages/PMovimientos/wcardinfo.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/wrow_opcion.dart';
import 'package:postjava/03dominio/pos/resul_moves.dart';
import 'package:postjava/helper/util_preferences.dart';
import 'package:postjava/helper/utilmethod.dart';
import 'package:provider/provider.dart';

import '../helper/util_responsive.dart';

class LastMoves extends StatefulWidget {
  static String route = '/LastMoves';

  const LastMoves({super.key});

  @override
  State<LastMoves> createState() => _LastMovesState();
}

class _LastMovesState extends State<LastMoves> {
  late LastMovesProvider provider;
  late UtilResponsive responsive;
  bool esIngreso = true;
  List<ResulMoves> vLista = [];

  _getLastMoves() async {
    await provider.getLasMovimiento();
    if (provider.resp.state == RespProvider.correcto.toString()) {
      vLista = provider.resp.obj as List<ResulMoves>;
    }
  }

  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
    provider = Provider.of<LastMovesProvider>(context);
    if (esIngreso) {
      esIngreso = false;
      _getLastMoves();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ultimos movimientos"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: UtilConstante.colorFondo),
          height: responsive.vAlto - 10,
          width: responsive.vAncho,
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  text: "Cuenta de ahorro",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: UtilConstante.btnColor,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: UtilPreferences.getAcount(),
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 1.5,
                    color: UtilConstante.btnColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              WRowOpcion(
                  label: 'Fecha: ',
                  value: UtilMethod.formatteOnlyDate(DateTime.now())),
              const WRowOpcion(label: 'Saldo: ', value: '1548.50 Bs'),
              Container(
                padding: const EdgeInsets.only(top: 10),
                height: responsive.altoPorcentaje(65),
                child: ListView.builder(
                  itemCount: vLista.length,
                  itemBuilder: (context, index) {
                    return WCardInfo(resulMoves: vLista[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
