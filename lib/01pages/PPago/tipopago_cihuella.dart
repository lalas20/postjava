// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../02service/channel/plataformchannel.dart';
import '../../03dominio/pos/resul_voucher.dart';
import '../../03dominio/user/saving_accounts.dart';
import '../../helper/util_preferences.dart';
import '../../helper/utilmethod.dart';
import '../Plogin/login_autentica.dart';
import '../helper/util_constante.dart';
import '../helper/util_responsive.dart';
import '../helper/utilmodal.dart';
import '../helper/wappbar.dart';
import '../helper/wbtnconstante.dart';
import 'pago_provider.dart';

class TipoPagoCiHuella extends StatefulWidget {
  const TipoPagoCiHuella({super.key});

  @override
  State<TipoPagoCiHuella> createState() => _TipoPagoCiHuellaState();
}

class _TipoPagoCiHuellaState extends State<TipoPagoCiHuella> {
  late PagoProvider provider;
  late UtilResponsive responsive;
  final _glosaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _depositoController =
      TextEditingController(text: UtilPreferences.getAcount());
  final _montoController = TextEditingController();
  final _ciController = TextEditingController();

  List<SavingAccounts>? vListaCuentaByCi;
  SavingAccounts? selecAcount;
  final resul = PlaformChannel();
  late StreamSubscription _streamSubscription;
  bool tieneFinger = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _glosaController.dispose();
    _depositoController.dispose();
    _montoController.dispose();
    _ciController.dispose();
    resul.fingerChannel.dispose();
    provider.clearIdentityCard();
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

  Widget _iconFinger() {
    return GestureDetector(
      onTap: _findFinger,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25, top: 5),
        child: Column(
          children: [
            tieneFinger
                ? Text(
                    "Huella reconocida",
                    style: TextStyle(color: UtilConstante.headerColor),
                  )
                : const Text(
                    "Huella no reconocida",
                    style: TextStyle(color: Colors.red),
                  ),
            WBtnConstante(
              pName: '',
              fun: _findFinger,
              ico: Icon(
                Icons.fingerprint,
                color: tieneFinger ? UtilConstante.headerColor : Colors.red,
                size: 64,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _txtCI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: TextFormField(
            controller: _ciController,
            decoration: UtilConstante.entrada(
                labelText: "Documento Identidad",
                icon: Icon(Icons.card_membership,
                    color: _ciController.text.isEmpty
                        ? Colors.red
                        : UtilConstante.btnColor)),
            keyboardType: TextInputType.text,
          ),
        ),
        WBtnConstante(
          pName: '',
          fun: getCboSavingAcount,
          ico: Icon(
            Icons.find_in_page_outlined,
            color:
                vListaCuentaByCi == null ? Colors.red : UtilConstante.btnColor,
          ),
        )
      ],
    );
  }

  Widget _cboSavingAcount() {
    return DropdownButtonFormField<SavingAccounts>(
      value: selecAcount,
      items: vListaCuentaByCi == null ? null : llenaCuentaAll(),
      onChanged: (value) {
        selecAcount = value;
        setState(() {});
      },
      elevation: 10,
      hint: const Text("Seleccione una cuenta"),
      decoration: UtilConstante.entrada(
          labelText: "Cuenta cliente",
          icon: Icon(
            Icons.list_outlined,
            color: selecAcount == null ? Colors.red : UtilConstante.btnColor,
          )),
    );
  }

  List<DropdownMenuItem<SavingAccounts>>? llenaCuentaAll() {
    if (vListaCuentaByCi == null) {
      return null;
    }
    return vListaCuentaByCi!.map<DropdownMenuItem<SavingAccounts>>(
      (SavingAccounts? pCuenta) {
        return DropdownMenuItem(
          value: pCuenta,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child:
                Text("${pCuenta!.codeAccount!}  ${pCuenta!.moneyDescription}"),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
    provider = Provider.of<PagoProvider>(context);
    return Scaffold(
      appBar: WAppBar(
          pTitle: "Pago C.I Huella", pSubTitle: UtilPreferences.getNamePos()),
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
                _iconFinger(),
                _txtCI(),
                _cboSavingAcount(),
                const SizedBox(
                  height: 50,
                ),
                WBtnConstante(pName: 'Grabar', fun: _saveIdentityCard)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveIdentityCard() async {
    UtilModal.mostrarDialogoSinCallback(context, "Grabando...");
    await provider.saveIdentityCard(
        pCi: _ciController.text,
        pIdOperationEntity:
            selecAcount == null ? '' : selecAcount!.idSavingsAccount.toString(),
        pOperationCodeCliente:
            selecAcount == null ? '' : selecAcount!.codeAccount!);
    Navigator.of(context).pop();

    if (provider.resp.state == RespProvider.correcto.toString()) {
      final print =
          (provider.resp.obj as String).replaceAll('&', '').split('|');

      final resul = PlaformChannel();
      final voucher = ResulVoucher(
        bancoDestino: 'BANCO PRODEM',
        cuentaDestino:
            print[5], // UtilPreferences.getAcount(), // '117-2-1-11208-1',
        cuentaOrigen:
            print[3], //selecAcount!.operationCode!, // '117-2-1-XXXX-1',
        fechaTransaccion: print[1], //UtilMethod.formatteDate(DateTime.now()),
        glosa: print[8], // provider.glosaWIdentityCard,
        montoPago: print[2], //provider.montoWIdentityCard,
        nroTransaccion: print[0],
        titular: print[7], // UtilPreferences.getClientePos(),
        tipoPago: 'Doc. Identidad y huella',
      );

      Future future = resul.printMethod.printVoucherChannel(voucher);
      future
          .then((value) => UtilModal.mostrarDialogoNativo(
                  context,
                  "Atención",
                  Text(
                    provider.resp.message,
                    style: TextStyle(color: UtilConstante.btnColor),
                  ),
                  "Aceptar", () {
                Navigator.of(context).pop();
              }))
          .catchError((e) => UtilMethod.writeToLog(e.toString()));
    } else {
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
    }
  }

  void getCboSavingAcount() async {
    selecAcount = null;
    vListaCuentaByCi = null;
    if (_ciController.text.isEmpty) {
      UtilModal.mostrarDialogoNativo(
          context,
          "Atención",
          Text(
            "Documento de identidad es campo obligatorio",
            style: TextStyle(color: UtilConstante.btnColor),
          ),
          "Aceptar",
          () {});
      return;
    }
    UtilModal.mostrarDialogoSinCallback(context, "Buscando Cuenta...");
    await provider.getDocIdentidadPago(pCi: _ciController.text);
    Navigator.of(context).pop();

    if (provider.resp.state == RespProvider.correcto.toString()) {
      vListaCuentaByCi = provider.resp.obj as List<SavingAccounts>;
    } else {
      vListaCuentaByCi = null;
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
    }
  }

  void _findFinger() async {
    UtilModal.mostrarDialogoSinCallback(context, "Buscando...");
    await provider.getNameDeviceDP();
    if (provider.resp.state == RespProvider.incorrecto.toString()) {
      Navigator.of(context).pop();
      tieneFinger = false;
      UtilModal.mostrarDialogoNativo(
          context,
          "Atención",
          Text(
            provider.resp.message,
            style: TextStyle(color: UtilConstante.btnColor),
          ),
          "Aceptar",
          () {});
      return;
    }
    await provider.getFingerDP();
    Navigator.of(context).pop();
    if (provider.resp.state == RespProvider.incorrecto.toString()) {
      tieneFinger = false;
      UtilModal.mostrarDialogoNativo(
          context,
          "Atención",
          Text(
            provider.resp.message,
            style: TextStyle(color: UtilConstante.btnColor),
          ),
          "Aceptar",
          () {});
      return;
    }
    tieneFinger = true;
  }
}
