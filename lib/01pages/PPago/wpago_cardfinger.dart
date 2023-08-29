// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/PPago/pago_provider.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:postjava/03dominio/user/saving_accounts.dart';
import 'package:provider/provider.dart';

import '../../02service/channel/plataformchannel.dart';
import '../../03dominio/pos/resul_voucher.dart';
import '../../03dominio/user/resul_get_user_session_info.dart';
import '../../helper/util_preferences.dart';
import '../../helper/utilmethod.dart';
import '../helper/util_constante.dart';
import '../helper/util_responsive.dart';
import '../helper/utilmodal.dart';

class WPagoCardFinger extends StatefulWidget {
  const WPagoCardFinger({super.key});
  @override
  State<WPagoCardFinger> createState() => _WPagoCardFingerState();
}

class _WPagoCardFingerState extends State<WPagoCardFinger> {
  final _txtCard = TextEditingController(); // "7265210000050007");

  late UtilResponsive responsive;
  late PagoProvider provider;
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

  @override
  void dispose() {
    resul.fingerChannel.dispose();
    resul.cardChannel.dispose();
    super.dispose();
  }

  _saveCardFinger() async {
    UtilModal.mostrarDialogoSinCallback(context, "Cargando...");
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
          "Aceptar",
          () {});
    }
  }

  Widget _iconFinger() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 30),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    responsive = UtilResponsive.of(context);
    provider = Provider.of<PagoProvider>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
          //width: responsive.vAncho - 50,
          //decoration: BoxDecoration(color: UtilConstante.colorFondo),
          child: Column(
            children: [
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
    );
  }

  Widget _cboSavingAcount() {
    return DropdownButtonFormField<SavingAccounts>(
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
}
