// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../02service/channel/plataformchannel.dart';
import '../../03dominio/pos/resul_voucher.dart';
import '../../03dominio/user/saving_accounts.dart';
import '../../helper/util_preferences.dart';
import '../Plogin/login_autentica.dart';
import '../helper/util_constante.dart';
import '../helper/util_responsive.dart';
import '../helper/utilmodal.dart';
import '../helper/wappbar.dart';
import '../helper/wbtnconstante.dart';
import 'pago_provider.dart';

class TipoPagoTarjetaHuella extends StatefulWidget {
  const TipoPagoTarjetaHuella({super.key});
  static String route = "/TipoPagoTarjetaHuella";

  @override
  State<TipoPagoTarjetaHuella> createState() => _TipoPagoTarjetaHuellaState();
}

class _TipoPagoTarjetaHuellaState extends State<TipoPagoTarjetaHuella> {
  late PagoProvider provider;
  late UtilResponsive responsive;
  final _glosaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _depositoController =
      TextEditingController(text: UtilPreferences.getAcount());
  final _montoController = TextEditingController();
  final _txtCard = TextEditingController();

  Image? image;
  String imagePath = '';
  List<SavingAccounts>? vListaCuentaByCi;
  SavingAccounts? selecAcount;
  bool tieneFinger = false;

  late StreamSubscription _streamSubscriptionCard;
  late StreamSubscription _streamSubscriptionFinger;
  final resul = PlaformChannel();

  void _findCardNumber() {
    UtilModal.mostrarDialogoSinCallback(context, "Buscando Tarjeta...");
    _streamSubscriptionCard = resul.emvChannel.event
        .receiveBroadcastStream()
        .listen(_listenStreamCard);
    resul.emvChannel.emvSearch();
  }

  void _listenStreamCard(value) {
    if (value != "onNoCard") {
      _txtCard.text = value;
    }
    getCboSavingAcount();
  }

  @override
  void dispose() {
    _depositoController.dispose();
    _glosaController.dispose();
    _montoController.dispose();
    provider.clearIdentityCard();
    resul.fingerChannel.dispose();
    resul.cardChannel.dispose();
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

  void getCboSavingAcount() async {
    selecAcount = null;
    Navigator.of(context).pop();
    if (_txtCard.text.isEmpty) {
      UtilModal.mostrarDialogoNativo(
          context,
          "Atención",
          Text(
            "No tiene lector de tarjeta",
            style: TextStyle(color: UtilConstante.btnColor),
          ),
          "Aceptar",
          () {});
      return;
    }
    UtilModal.mostrarDialogoSinCallback(context, "Buscando Cuenta...");
    await provider.getSavingAcountByCardFinger(pCard: _txtCard.text);
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
          "Aceptar",
          () {});
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

  Widget _iconFinger() {
    return GestureDetector(
      onTap: _findFinger,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 25),
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

  Widget _cardNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: TextFormField(
            controller: _txtCard,
            readOnly: true,
            decoration: UtilConstante.entrada(
                labelText: "Tarjeta Debito",
                icon: Icon(Icons.card_membership,
                    color: _txtCard.text.isEmpty
                        ? Colors.red
                        : UtilConstante.btnColor)),
          ),
        ),
        WBtnConstante(
          pName: "",
          fun: _findCardNumber, //getCboSavingAcount,// _findCardNumber,
          ico: Icon(
            Icons.find_in_page,
            color:
                vListaCuentaByCi == null ? Colors.red : UtilConstante.btnColor,
          ),
        )
      ],
    );
  }

  _saveCardFinger() async {
    UtilModal.mostrarDialogoSinCallback(context, "Grabando...");
    await provider.saveCardFinger(
      pIdOperationEntity:
          selecAcount == null ? '' : selecAcount!.idSavingsAccount.toString(),
      pOperationCodeCliente:
          selecAcount == null ? '' : selecAcount!.codeAccount!,
    );

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
        tipoPago: 'Tarjeta y huella',
      );

      final res = await resul.printMethod.printVoucherChannel(voucher);
      UtilModal.mostrarDialogoNativo(
          context,
          "Atención",
          Text(
            provider.resp.message,
            style: TextStyle(color: UtilConstante.btnColor),
          ),
          "Aceptar", () {
        Navigator.of(context).pop();
      });
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

  Widget _cboSavingAcount() {
    return DropdownButtonFormField<SavingAccounts>(
      value: selecAcount,
      items: vListaCuentaByCi == null
          ? null
          : vListaCuentaByCi!.map<DropdownMenuItem<SavingAccounts>>(
              (SavingAccounts pCuenta) {
                return DropdownMenuItem(
                  value: pCuenta,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        "${pCuenta.codeAccount!}  ${pCuenta.moneyDescription}"),
                  ),
                );
              },
            ).toList(),
      onChanged: (value) {
        selecAcount = value;
        setState(() {});
      },
      elevation: 10,
      hint: const Text("Seleccione una cuenta"),
      decoration: UtilConstante.entrada(
          labelText: "Cuenta cliente",
          icon: Icon(Icons.list_outlined,
              color:
                  selecAcount == null ? Colors.red : UtilConstante.btnColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
    provider = Provider.of<PagoProvider>(context);
    return Scaffold(
      appBar: WAppBar(
          pTitle: "Pago Tarjeta Huella",
          pSubTitle: UtilPreferences.getNamePos()),
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
                _cardNumber(),
                _cboSavingAcount(),
                const SizedBox(
                  height: 50,
                ),
                WBtnConstante(
                  pName: "Grabar",
                  fun: _saveCardFinger,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
