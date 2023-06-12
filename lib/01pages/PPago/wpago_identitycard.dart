// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/utilmodal.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:postjava/03dominio/pos/resul_voucher.dart';
import 'package:postjava/helper/utilmethod.dart';
import 'package:provider/provider.dart';

import '../../02service/channel/plataformchannel.dart';
import '../../03dominio/user/resul_get_user_session_info.dart';
import '../../helper/util_preferences.dart';
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
  final _ciController = TextEditingController();
  late PagoProvider provider;
  late UtilResponsive responsive;
  List<ListCodeSavingsAccount>? vListaCuentaByCi;
  ListCodeSavingsAccount? selecAcount;

  final resul = PlaformChannel();
  late StreamSubscription _streamSubscription;
  bool tieneFinger = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _ciController.dispose();
    resul.fingerChannel.dispose();
    super.dispose();
  }

  void getCboSavingAcount() async {
    if (_ciController.text.isEmpty) {
      print('ingresando');
      return;
    }
    UtilModal.mostrarDialogoSinCallback(context, "Cargando...");
    await provider.getDocIdentidadPago(_ciController.text);
    Navigator.of(context).pop();

    if (provider.resp.state == RespProvider.correcto.toString()) {
      vListaCuentaByCi = provider.resp.obj as List<ListCodeSavingsAccount>;
    } else {
      vListaCuentaByCi = List.empty();
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
                icon:
                    Icon(Icons.card_membership, color: UtilConstante.btnColor)),
            keyboardType: TextInputType.text,
          ),
        ),
        WBtnConstante(
          pName: '',
          fun: getCboSavingAcount,
          ico: const Icon(Icons.find_in_page_outlined),
        )
      ],
    );
  }

  Widget _cboSavingAcount() {
    return DropdownButtonFormField<ListCodeSavingsAccount>(
      items: vListaCuentaByCi == null
          ? null
          : vListaCuentaByCi!.map<DropdownMenuItem<ListCodeSavingsAccount>>(
              (ListCodeSavingsAccount pCuenta) {
                return DropdownMenuItem(
                  value: pCuenta,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child:
                        Text("${pCuenta.operationCode!}  ${pCuenta.codMoney}"),
                  ),
                );
              },
            ).toList(),
      onChanged: (value) {
        selecAcount = value;
      },
      elevation: 10,
      hint: const Text("Seleccione una cuenta"),
      decoration: UtilConstante.entrada(
          labelText: "Cuenta cliente",
          icon: Icon(Icons.list_outlined, color: UtilConstante.btnColor)),
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
            fun: _getFinger,
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
    final keyfrm = widget.frmKey;
    provider = Provider.of<PagoProvider>(context);
    responsive = UtilResponsive.of(context);
    return Container(
      child: Column(
        children: [
          _txtCI(),
          _cboSavingAcount(),
          _iconFinger(),
          const SizedBox(
            height: 50,
          ),
          WBtnConstante(pName: 'Grabar', fun: _saveIdentityCard)
        ],
      ),
    );
  }

  _saveIdentityCard() async {
    UtilModal.mostrarDialogoSinCallback(context, "Cargando...");
    await provider.saveIdentityCard(
        pCi: _ciController.text,
        pIdOperationEntity: selecAcount == null
            ? ''
            : selecAcount!.idOperationEntity.toString(),
        pOperationCodeCliente:
            selecAcount == null ? '' : selecAcount!.operationCode!);
    Navigator.of(context).pop();

    if (provider.resp.state == RespProvider.correcto.toString()) {
      final resul = PlaformChannel();
      final voucher = ResulVoucher(
        bancoDestino: 'BANCO PRODEM',
        cuentaDestino: UtilPreferences.getAcount(), // '117-2-1-11208-1',
        cuentaOrigen: selecAcount!.operationCode!, // '117-2-1-XXXX-1',
        fechaTransaccion: UtilMethod.formatteDate(DateTime.now()),
        glosa: provider.glosaWIdentityCard,
        montoPago: provider.montoWIdentityCard,
        nroTransaccion: 122245547,
        titular: UtilPreferences.getClientePos(),
        tipoPago: 'Doc. Identidad y huella',
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

  void _getFinger() {
    print('_getFinger:39');
    _streamSubscription = resul.fingerChannel.event
        .receiveBroadcastStream()
        .listen(_listenStream);
    resul.fingerChannel.captureFingerISO();
  }

  void _listenStream(value) {
    if (value == null) {
      tieneFinger = false;
    } else {
      print(value.toString());
      tieneFinger = true;
      provider.fingerWIdentityCard = value.toString();
    }
    setState(() {});
  }
}
