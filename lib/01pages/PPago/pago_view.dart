// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:postjava/01pages/PPago/pago_provider.dart';
import 'package:postjava/01pages/PPago/wpago_identitycard.dart';
import 'package:postjava/01pages/PPago/wpago_qr.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/utilmodal.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:postjava/helper/util_preferences.dart';
import 'package:provider/provider.dart';

import '../helper/util_responsive.dart';

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
  final _ciController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TipoPago? selectTipoPago;
  late PagoProvider provider;

  late UtilResponsive responsive;
  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
    provider = Provider.of<PagoProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Pago de Servicio")),
      body: SingleChildScrollView(
        child: Container(
          height: responsive.vAlto - 10,
          decoration: BoxDecoration(color: UtilConstante.colorFondo),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                wCuentaDeposito(),
                wMontoPago(),
                wCboCuentas(),
                wSeleccTipoPago(),
                WBtnConstante(pName: "Pagar", fun: () {})
              ],
            ),
          ),
        ),
      ),
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
        icon: Icon(Icons.monetization_on, color: UtilConstante.btnColor),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
        icon: Icon(Icons.card_travel, color: UtilConstante.btnColor),
      ),
      keyboardType: TextInputType.text,
    );
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
          icon: Icon(Icons.list_outlined, color: UtilConstante.btnColor)),
    );
  }

  void getwidgetTipoPago() async {
    if (selectTipoPago != null) {
      UtilModal.mostrarDialogoSinCallback(context, "Procesando...");
    }
    switch (selectTipoPago) {
      case TipoPago.TARJETA:
        break;
      case TipoPago.DOC_IDENTIDAD:
        await provider.getDocIdentidad();
        break;
      case TipoPago.QR:
        await provider.getQRPago();

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
        child: Text("sin data"),
      );
    }
    final Widget resul;

    switch (selectTipoPago) {
      case TipoPago.TARJETA:
        resul = const SizedBox(height: 100, child: Text("card"));
        break;
      case TipoPago.DOC_IDENTIDAD:
        if (provider.resp.state == RespProvider.correcto.toString()) {
          resul = WPagoIdentityCard(
            txtCI: TextFormField(
              controller: _ciController,
              onEditingComplete: () {
                _formKey.currentState!.validate();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Documento de Identidad, es campo obligatorio';
                }
                return null;
              },
              decoration: UtilConstante.entrada(
                  labelText: "Documento Identidad",
                  icon: Icon(Icons.card_membership,
                      color: UtilConstante.btnColor)),
              keyboardType: TextInputType.text,
            ),
          );
        } else {
          resul =
              const SizedBox(height: 100, child: Text("seleccione registro"));
        }
        break;
      case TipoPago.QR:
        if (provider.resp.state == RespProvider.correcto.toString()) {
          resul = WPagoQR(
            imgQR: provider.resp.obj.toString(),
          );
        } else {
          resul = SizedBox(
              height: 100, child: Text("Error de ${provider.resp.message}"));
        }
        break;
      default:
        resul = const SizedBox(height: 100, child: Text("seleccione registro"));
        break;
    }
    return resul;
  }
}
