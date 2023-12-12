// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/utilmodal.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:postjava/03dominio/pos/resul_voucher.dart';
import 'package:postjava/03dominio/user/saving_accounts.dart';
import 'package:postjava/helper/utilmethod.dart';
import 'package:provider/provider.dart';

import '../../02service/channel/plataformchannel.dart';
import '../helper/util_constante.dart';
import '../helper/util_responsive.dart';
import 'pago_provider.dart';

class WPagoIdentityCard extends StatefulWidget {
  const WPagoIdentityCard({super.key, required this.frmKey});
  final GlobalKey<FormState> frmKey;

  @override
  State<WPagoIdentityCard> createState() => _WPagoIdentityCardState();
}

class _WPagoIdentityCardState extends State<WPagoIdentityCard> {
/*eliminar */
  late StreamSubscription _streamSubscriptionCard;
  final _txtCard = TextEditingController(); // "7265210000050007");
/*fin eliminar */
  final _ciController = TextEditingController(); //(text:"756674BE" );

  late PagoProvider provider;
  late UtilResponsive responsive;
  List<SavingAccounts>? vListaCuentaByCi;
  SavingAccounts? selecAcount;

  final resul = PlaformChannel();
  late StreamSubscription _streamSubscription;
  bool tieneFinger = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _ciController.dispose();
    resul.fingerChannel.dispose();
    super.dispose();
  }

  void getCboSavingAcount() async {
    selecAcount = null;
    vListaCuentaByCi = null;
    if (_ciController.text.isEmpty) {
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
          "Aceptar",
          () {});
    }
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
      items: vListaCuentaByCi == null
          ? null
          : vListaCuentaByCi!.map<DropdownMenuItem<SavingAccounts>>(
              (SavingAccounts? pCuenta) {
                return DropdownMenuItem(
                  value: pCuenta,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        "${pCuenta!.codeAccount!}  ${pCuenta.moneyDescription}"),
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
          icon: Icon(
            Icons.list_outlined,
            color: selecAcount == null ? Colors.red : UtilConstante.btnColor,
          )),
    );
  }

  Widget _iconFinger() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
    //final keyfrm = widget.frmKey;
    provider = Provider.of<PagoProvider>(context);
    responsive = UtilResponsive.of(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _iconFinger(),
            _txtCI(),
            _cboSavingAcount(),
            _cardNumber(),
            const SizedBox(
              height: 50,
            ),
            WBtnConstante(pName: 'Grabar', fun: _saveIdentityCard)
          ],
        ),
      ),
    );
  }

  _saveIdentityCard() async {
    UtilModal.mostrarDialogoSinCallback(context, "Cargando...");
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
          .catchError((e) => UtilMethod.imprimir(e));
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

  void _listenStream(value) {
    if (value == null) {
      tieneFinger = false;
    } else {
      tieneFinger = true;
      provider.fingerWIdentityCard = value.toString();
    }
    setState(() {});
  }

  /* eliminar luyego */
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
  }
}
