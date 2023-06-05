// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/utilmodal.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:provider/provider.dart';

import '../../03dominio/user/resul_get_user_session_info.dart';
import '../helper/util_constante.dart';
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
  List<ListCodeSavingsAccount>? vListaCuentaByCi;

  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(getCboSavingAcount);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ciController.dispose();
    focusNode.dispose();
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
    return TextFormField(
      controller: _ciController,
      /*onEditingComplete: () {
        // keyfrm.currentState!.validate();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Documento de Identidad, es campo obligatorio';
        }
        return null;
      },*/
      decoration: UtilConstante.entrada(
          labelText: "Documento Identidad",
          icon: Icon(Icons.card_membership, color: UtilConstante.btnColor)),
      keyboardType: TextInputType.text,
      focusNode: focusNode,
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
      onChanged: (value) {},
      elevation: 10,
      hint: const Text("Seleccione una cuenta"),
      decoration: UtilConstante.entrada(
          labelText: "Cuenta cliente",
          icon: Icon(Icons.list_outlined, color: UtilConstante.btnColor)),
    );
  }

  void _getHuella() {
    print('_getHuella');
  }

  Widget _iconFinger() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "Huella no reconocida",
            style: TextStyle(color: Colors.red),
          ),
          WBtnConstante(
            pName: '',
            fun: _getHuella,
            ico: const Icon(
              Icons.fingerprint,
              color: Colors.red,
              size: 48,
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
    return Container(
      child: Column(
        children: [
          _txtCI(),
          _cboSavingAcount(),
          _iconFinger(),
        ],
      ),
    );
  }
}
