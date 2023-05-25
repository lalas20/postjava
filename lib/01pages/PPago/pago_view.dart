import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:postjava/helper/util_preferences.dart';

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
  final _formKey = GlobalKey<FormState>();
  TipoPago selectTipoPago = TipoPago.QR;

  late UtilResponsive responsive;
  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
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
        icon: Icon(Icons.monetization_on, color: UtilConstante.btnColor),
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
        setState(() {});
      },
      elevation: 10,
      hint: const Text("Seleccion un tipo"),
    );
  }

  Widget wSeleccTipoPago() {
    final Widget resul;

    switch (selectTipoPago) {
      case TipoPago.TARJETA:
        resul = const SizedBox(height: 100, child: Text("card"));
        break;
      case TipoPago.DOC_IDENTIDAD:
        resul = const SizedBox(height: 100, child: Text("identitycard"));
        break;
      case TipoPago.QR:
        resul = const SizedBox(height: 100, child: Text("QR"));
        break;
      default:
        resul = const SizedBox(height: 100, child: Text("seleccione registro"));
        break;
    }
    return resul;
  }
}
