// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/PPago/pago_provider.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/wappbar.dart';
import 'package:postjava/03dominio/QR/get_qr_state_single_use_result.dart';
import 'package:postjava/helper/util_preferences.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

import '../../helper/utilmethod.dart';
import '../Plogin/login_autentica.dart';
import '../helper/util_responsive.dart';
import '../helper/utilmodal.dart';
import '../helper/wbtnconstante.dart';

class TipoPagoQR extends StatefulWidget {
  const TipoPagoQR({super.key});
  static String route = "/TipoPagoQR";

  @override
  State<TipoPagoQR> createState() => _TipoPagoQRState();
}

class _TipoPagoQRState extends State<TipoPagoQR> {
  late PagoProvider provider;
  late UtilResponsive responsive;
  final _glosaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _depositoController =
      TextEditingController(text: UtilPreferences.getAcount());
  final _montoController = TextEditingController();
  String imgTxt = '';
  Timer? _timer;
  int _initTime = 5; // inicia despues de 10seg
  int _endTime = 100;

  bool isGenerado = false;

  @override
  void dispose() {
    provider.clearIdentityCard();
    _cancelTimer();
    super.dispose();
  }

  Widget wCuentaDeposito() {
    return TextFormField(
      controller: _depositoController,
      readOnly: true,
      onEditingComplete: () {
        _formKey.currentState!.validate();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La cuenta del deposito es campo obligatorio';
        }
        return null;
      },
      decoration: UtilConstante.entrada(
        labelText: "Depósito a la cuenta",
        icon: Icon(Icons.card_travel,
            color: _depositoController.text.isEmpty
                ? Colors.red
                : UtilConstante.btnColor),
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget wGlosa() {
    return TextFormField(
      controller: _glosaController,
      onEditingComplete: () {
        _formKey.currentState!.validate();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Glosa campo obligatorio';
        }
        return null;
      },
      decoration: UtilConstante.entrada(
        labelText: "Glosa",
        icon: Icon(Icons.edit_document,
            color: provider.glosaWIdentityCard.isEmpty
                ? Colors.red
                : UtilConstante.btnColor),
      ),
      keyboardType: TextInputType.multiline,
      maxLength: 60,
      minLines: 2,
      maxLines: 2,
      onChanged: (value) {
        provider.glosaWIdentityCard = value;
      },
    );
  }

  Widget wMontoPago() {
    return TextFormField(
      controller: _montoController,
      onEditingComplete: () {
        _formKey.currentState!.validate();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El monto es campo obligatorio';
        }
        final decimalValue = double.tryParse(value);
        if (decimalValue == null || decimalValue <= 0) {
          return 'Ingresa un monto mayor a cero';
        }
        return null;
      },
      decoration: UtilConstante.entrada(
        labelText: "Monto a pagar",
        icon: Icon(Icons.monetization_on,
            color: provider.montoWIdentityCard == 0
                ? Colors.red
                : UtilConstante.btnColor),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        provider.montoWIdentityCard = double.tryParse(value) ?? 0;
      },
    );
  }

  _generarQR() async {
    FocusScope.of(context).unfocus();
    UtilModal.mostrarDialogoSinCallback(context, "Procesando...");
    await provider.getQRPago(
        double.tryParse(_montoController.text) ?? 0, _glosaController.text);
    if (provider.resp.state != RespProvider.correcto.toString()) {
      Navigator.of(context).pop();
      UtilModal.mostrarDialogoNativo(
          context,
          "Atención",
          Text(
            provider.resp.message,
            style: TextStyle(color: UtilConstante.btnColor),
          ),
          "Aceptar", () {
        if (provider.resp.code == '99') {
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginAutentica.route, (Route<dynamic> route) => false);
        }
      });
      return;
    }
    Navigator.of(context).pop();
    imgTxt = provider.resp.obj.toString();
    isGenerado = true;
    _startTimer();
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: _initTime), (timer) async {
      await _getQRStateSingleUse();
      _endTime--;
      UtilMethod.formatteDate(DateTime.now());
      UtilMethod.imprimir('_endTime:$_endTime fecha:${DateTime.now()}');
      if (_endTime <= 0) {
        _cancelTimer();
      }
    });
  }

  _getQRStateSingleUse() async {
    await provider.getQRStateSingleUse();
    if (provider.resp.state != RespProvider.correcto.toString()) {
      if (provider.resp.code != null && provider.resp.code == '99') {
        Navigator.of(context).pop();
        _cancelTimer();
        UtilModal.mostrarDialogoNativo(
            context,
            "Atención",
            Text(
              provider.resp.message,
              style: TextStyle(color: UtilConstante.btnColor),
            ),
            "Aceptar", () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginAutentica.route, (Route<dynamic> route) => false);
        });
      }
    } else {
      final vQrState = provider.resp.obj as QRState;
      if (vQrState.state == '0000') {
        _cancelTimer();
        UtilModal.mostrarDialogoNativo(
          context,
          "Atención",
          Text(
            "La transacción fue realizada con exíto",
            style: TextStyle(color: UtilConstante.btnColor),
          ),
          "Aceptar",
          () {
            closeQr();
          },
          firstActionStyle: ActionStyle.important,
        );
      }
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  closeQr() {
    _cancelTimer();
    Navigator.of(context).pop();
  }

  Widget wBuilQR() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            'Monto: ${_montoController.text}',
            style: TextStyle(color: UtilConstante.colorAppPrimario),
          ),
          PrettyQr(
            size: 250,
            data: imgTxt,
            errorCorrectLevel: QrErrorCorrectLevel.H,
            typeNumber: null,
            roundEdges: true,
            //image:AssetImage(UtilConstante.iprdBlue),
          ),
          WBtnConstante(
              pName: "Salir",
              fun: () {
                closeQr();
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
    provider = Provider.of<PagoProvider>(context);
    return Scaffold(
      appBar: WAppBar(
          pTitle: "Pago por QR", pSubTitle: UtilPreferences.getNamePos()),
      backgroundColor: UtilConstante.colorFondo,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                wCuentaDeposito(),
                wGlosa(),
                wMontoPago(),
                isGenerado
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: wBuilQR(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child:
                            WBtnConstante(pName: "Genera QR", fun: _generarQR),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
