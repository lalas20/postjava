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
  final _txtCard = TextEditingController();

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
    _streamSubscriptionCard = resul.emvChannel.event
        .receiveBroadcastStream()
        .listen(_listenStreamCard);
    resul.emvChannel.emvSearch();
  }

  void _listenStreamCard(value) {
    _txtCard.text = value;
    getCboSavingAcount();
  }

  void getCboSavingAcount() async {
    if (_txtCard.text.isEmpty) {
      print('getCboSavingAcount');
      return;
    }
    UtilModal.mostrarDialogoSinCallback(context, "Cargando...");
    await provider.getDocIdentidadPago(_txtCard.text);
    Navigator.of(context).pop();

    if (provider.resp.state == RespProvider.correcto.toString()) {
      vListaCuentaByCi = provider.resp.obj as List<SavingAccounts>;
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

  void _findFinger() async {
   /* _streamSubscriptionFinger = resul.fingerChannel.event
        .receiveBroadcastStream()
        .listen(_listenStreamFinger);
    */
  await  provider.getNameDeviceDP();
  if(provider.resp.state==RespProvider.incorrecto.toString())
    {
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
  if(provider.resp.state==RespProvider.incorrecto.toString())
  {
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

  void _listenStreamFinger(value) {
    if (value == null) {
      tieneFinger = false;
    } else {
      print("finger: " + value.toString());
      tieneFinger = true;
      provider.fingerWIdentityCard = value.toString();
    }
    /*imagePath = value;
    File imgfile = File(value);
    image = Image.file(
      imgfile,
      fit: BoxFit.cover,
      width: responsive.anchoPorcentaje(50),
      height: responsive.altoPorcentaje(40),
    );*/
    print('_listenStreamFinger:39');
    setState(() {});
  }

  @override
  void dispose() {
    resul.fingerChannel.dispose();

    resul.cardChannel.dispose();
    super.dispose();
  }

  void _converBase64() async {
    print('imagePath');
    File imagefile = File(imagePath);
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string = base64.encode(imagebytes);

    print(base64string);

    var file =
        await File('/sdcard/dataFinger1.txt').writeAsString(base64string);
    //final vstring = await imagefile.readAsString();
    //print(vstring);
  }

  _saveCardFinger() async {
    UtilModal.mostrarDialogoSinCallback(context, "Cargando...");
    await provider.saveCardFinger(
        pIdOperationEntity: selecAcount == null
            ? ''
            : selecAcount!.idSavingsAccount.toString(),
        pOperationCodeCliente:
            selecAcount == null ? '' : selecAcount!.codeAccount!);
    Navigator.of(context).pop();

    if (provider.resp.state == RespProvider.correcto.toString()) {
      final resul = PlaformChannel();
      final voucher = ResulVoucher(
        bancoDestino: 'BANCO PRODEM',
        cuentaDestino: UtilPreferences.getAcount(), // '117-2-1-11208-1',
        cuentaOrigen: selecAcount!.codeAccount!, // '117-2-1-XXXX-1',
        fechaTransaccion: UtilMethod.formatteDate(DateTime.now()),
        glosa: provider.glosaWIdentityCard,
        montoPago: provider.montoWIdentityCard,
        nroTransaccion: 122245547,
        titular: UtilPreferences.getClientePos(),
        tipoPago: 'Tarjeta débito y huella',
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

    return Container(
      //width: responsive.vAncho - 50,
      //decoration: BoxDecoration(color: UtilConstante.colorFondo),
      child: Column(
        children: [
          _iconFinger(),
          _cardNumber(),
          _cboSavingAcount(),
          WBtnConstante(
            pName: "Grabar",
            fun: _saveCardFinger,
          )
        ],
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
                    child:
                        Text("${pCuenta.codeAccount!}  ${pCuenta.moneyDescription}"),
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
                icon:
                    Icon(Icons.card_membership, color: UtilConstante.btnColor)),
          ),
        ),
        WBtnConstante(
          pName: "",
          fun: _findCardNumber,
          ico: const Icon(Icons.find_in_page),
        )
      ],
    );
  }
}
