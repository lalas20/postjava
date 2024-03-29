// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:postjava/01pages/PMovimientos/last_moves_provider.dart';
import 'package:postjava/01pages/PMovimientos/wcardinfo.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/wrow_opcion.dart';
import 'package:postjava/03dominio/pos/resul_moves.dart';
import 'package:postjava/helper/util_preferences.dart';
import 'package:postjava/helper/utilmethod.dart';

import 'package:provider/provider.dart';

import '../Plogin/login_autentica.dart';
import '../helper/util_responsive.dart';
import '../helper/utilmodal.dart';

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
  bool cargando = true;
  ResulMasterMoves? vEntidad;
  List<ResulMoves> vLista = [];

  _getLastMoves() async {
    await provider.getLasMovimiento();
    cargando = false;
    if (provider.resp.state == RespProvider.correcto.toString()) {
      vEntidad = provider.resp.obj as ResulMasterMoves;
      vLista = vEntidad!.masterResulMoves!.listResulMoves!;
    } else {
      vLista = [];
      if (provider.resp.obj == '99') {
        UtilModal.mostrarDialogoNativo(
            context,
            "Atención!",
            Text(
              provider.resp.message,
              style: TextStyle(color: UtilConstante.colorAppPrimario),
            ),
            "Aceptar", () {
          if (provider.resp.obj == '99') {
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginAutentica.route, (Route<dynamic> route) => false);
          }
        });
        return;
      }
    }
  }

  _refresh() async {
    UtilModal.mostrarDialogoSinCallback(context, "Cargando...");
    await provider.getLasMovimiento();
    Navigator.of(context).pop();
    if (provider.resp.state == RespProvider.correcto.toString()) {
      vEntidad = provider.resp.obj as ResulMasterMoves;
      vLista = vEntidad!.masterResulMoves!.listResulMoves!;
    } else {
      vLista = [];
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
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh))
        ],
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
                value: vEntidad == null
                    ? ""
                    : vEntidad!.masterResulMoves!.processDate!,
              ),
              WRowOpcion(
                label: 'Saldo: ',
                value: vEntidad == null
                    ? "0"
                    : UtilMethod.stringByDouble(
                        vEntidad!.masterResulMoves!.accountBalance ?? 0),
              ),
              cargando ? UtilModal.iniCircularProgres() : listVacia()
            ],
          ),
        ),
      ),
    );
  }

  Widget listVacia() {
    return vLista.isEmpty
        ? UtilModal.iniSinRegistro()
        : Container(
            padding: const EdgeInsets.only(top: 10),
            height: responsive.altoPorcentaje(65),
            child: ListView.builder(
              itemCount: vLista.length,
              itemBuilder: (context, index) {
                return WCardInfo(resulMoves: vLista[index]);
              },
            ),
          );
  }
}
