// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:postjava/01pages/PPago/pago_provider.dart';
import 'package:postjava/01pages/PPago/wpago_cardfinger.dart';
import 'package:postjava/01pages/PPago/wpago_identitycard.dart';
import 'package:postjava/01pages/PPago/wpago_qr.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/utilmodal.dart';

import 'package:postjava/helper/util_preferences.dart';

import 'package:provider/provider.dart';

import '../helper/util_responsive.dart';
import '../helper/wappbar.dart';

class PagoView extends StatefulWidget {
  static String route = '/PagoView';
  const PagoView({super.key});

  @override
  State<PagoView> createState() => _PagoViewState();
}

class _PagoViewState extends State<PagoView> {
  final _depositoController =
      TextEditingController(text: UtilPreferences.getAcount());
  final _montoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TipoPago? selectTipoPago;
  late PagoProvider provider;
  late UtilResponsive responsive;
  final _glosaController = TextEditingController();

  @override
  void dispose() {
    provider.clearIdentityCard();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
    provider = Provider.of<PagoProvider>(context);
    return Scaffold(
      appBar:
          WAppBar(pTitle: "Tipo Pago", pSubTitle: UtilPreferences.getNamePos()),
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
                wCboCuentas(),
                wSeleccTipoPago(),
              ],
            ),
          ),
        ),
      ),
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

  void closeQr() {
    Navigator.of(context).pop();
  }

  Widget wCboCuentas() {
    return DropdownButtonFormField<TipoPago>(
      items: TipoPago.values.map<DropdownMenuItem<TipoPago>>(
        (TipoPago pTipoPago) {
          return DropdownMenuItem(
            value: pTipoPago,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text((pTipoPago.toString().split('.'))[1]),
            ),
          );
        },
      ).toList(),
      onChanged: (value) {
        selectTipoPago = value!;
        getwidgetTipoPago();
      },
      elevation: 10,
      hint: const Text("Seleccion un tipo"),
      decoration: UtilConstante.entrada(
          labelText: "Tipo de Pago",
          icon: Icon(Icons.list_outlined,
              color: selectTipoPago == null
                  ? Colors.red
                  : UtilConstante.btnColor)),
    );
  }

  void getwidgetTipoPago() async {
    if (selectTipoPago != null) {
      UtilModal.mostrarDialogoSinCallback(context, "Procesando...");
    }
    switch (selectTipoPago) {
      case TipoPago.TARJETA:
        await provider.getNameDeviceDP(); // provider.getCardFinger();
        break;
      case TipoPago.DOC_IDENTIDAD:
        await provider.getinitDocIdentidadPago();
        break;
      case TipoPago.QR:
        await provider.getQRPago(
            double.tryParse(_montoController.text) ?? 0, _glosaController.text);

        break;
      default:
        break;
    }
    Navigator.of(context).pop();
  }

  Widget wSeleccTipoPago() {
    if (selectTipoPago == null) {
      return const SizedBox(
        height: 10,
      );
    }
    final Widget resul;

    switch (selectTipoPago) {
      case TipoPago.TARJETA:
        // UtilMethod.imprimir(provider.resp.state.toString());
        // if (provider.resp.state == RespProvider.correcto.toString()) {

        resul = const WPagoCardFinger();
        //} else {
        //resul = SizedBox(height: 100, child: Text(provider.resp.message));
        //}
        break;
      case TipoPago.DOC_IDENTIDAD:
        resul = WPagoIdentityCard(
          frmKey: _formKey,
        );
        // if (provider.resp.state == RespProvider.correcto.toString()) {
        //   resul = WPagoIdentityCard(
        //     frmKey: _formKey,
        //   );
        // } else {
        //   resul = SizedBox(height: 100, child: Text(provider.resp.message));
        // }
        break;
      case TipoPago.QR:
        /*resul = WPagoQR(

          monto: provider.vMontoPagar,
          fun: closeQr,
          imgTxt: provider.resp.obj.toString(),
        );*/
        if (provider.resp.state == RespProvider.correcto.toString()) {
          resul = WPagoQR(
            monto: provider.vMontoPagar,
            fun: closeQr,
            imgTxt: provider.resp.obj.toString(),
          );
        } else {
          resul = SizedBox(
              height: 100,
              child: Text(
                provider.resp.message,
                style: const TextStyle(color: Colors.red, fontSize: 20),
              ));
        }
        break;
      default:
        resul = const SizedBox(height: 100, child: Text("seleccione registro"));
        break;
    }
    return resul;
  }
}
