// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:postjava/01pages/PConfiguration/configuration_provider.dart';
import 'package:postjava/01pages/helper/util_responsive.dart';
import 'package:postjava/01pages/helper/utilmodal.dart';
import 'package:provider/provider.dart';

import '../../03dominio/user/resul_get_user_session_info.dart';
import '../helper/util_constante.dart';
import '../helper/wbtnconstante.dart';

class ConfigurationView extends StatefulWidget {
  const ConfigurationView({super.key});
  static String route = '/ConfigurationView';

  @override
  State<ConfigurationView> createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView> {
  final _formKey = GlobalKey<FormState>();
  late ConfigurationProvider provider; // = ConfigurationProvider();
  late UtilResponsive responsive;
  ObjectGetUserSessionInfoResult? sessionInfo;
  final _txtClientePos = TextEditingController();
  bool ingreso = false;
  bool sinData = false;
  String vMensajeValida = "Seleccione la cuenta";
  ListCodeSavingsAccount? account;
  void initConfiguration() async {
    await provider.getUserSessionInfo();
    if (provider.resp.state == RespProvider.correcto.toString()) {
      sessionInfo = provider.resp.obj as ObjectGetUserSessionInfoResult;
      _txtClientePos.text = sessionInfo!.personName ?? 'sin dato';
    } else {
      sinData = true;
      UtilModal.mostrarDialogoNativo(
          context,
          "Atención!",
          Text(
            provider.resp.message,
            style: TextStyle(color: UtilConstante.colorAppPrimario),
          ),
          "Aceptar", () {
        sessionInfo = ObjectGetUserSessionInfoResult();
        setState(() {});
      });
    }
  }

  void saveConfiguration() async {
    UtilModal.mostrarDialogoSinCallback(context, "Procesando...");
    await provider.saveDataIni(account, sessionInfo!);
    Navigator.of(context).pop();
    if (provider.resp.state == RespProvider.correcto.toString()) {
      Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ConfigurationProvider>(context);
    if (!ingreso) {
      ingreso = true;
      initConfiguration();
    }
    responsive = UtilResponsive.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración de cuenta"),
      ),
      body: Container(
        //height: responsive.vAlto - 100,
        decoration: BoxDecoration(
          color: UtilConstante.colorFondo,
        ),
        child: sessionInfo != null
            ? Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        UtilConstante.fondo,
                        fit: BoxFit.fitWidth,
                        height: 100,
                        alignment: Alignment.topRight,
                      ),
                      txtClientePos(),
                      cboCuentas(),
                      account == null
                          ? Text(
                              vMensajeValida,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : const SizedBox(
                              height: 10,
                            ),
                      WBtnConstante(
                          pName: "Grabar",
                          fun: () {
                            final vValida = _formKey.currentState!.validate();
                            if (vValida) {
                              saveConfiguration();
                            }
                          }),
                    ],
                  ),
                ),
              )
            : UtilModal.iniCircularProgres(),
      ),
    );
  }

  Widget txtClientePos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: _txtClientePos,
        onEditingComplete: () {
          _formKey.currentState!.validate();
        },
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nombre del cliente POS, es campo obligatorio';
          }
          return null;
        },
        decoration: UtilConstante.entrada(
            labelText: "Cliente POS",
            hintText: "Cliente POS",
            icon: Icon(
              Icons.person_3,
              color: UtilConstante.btnColor,
            )),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget cboCuentas() {
    List<ListCodeSavingsAccount>? pLista =
        sessionInfo?.listCodeSavingsAccount == null
            ? null
            : sessionInfo?.listCodeSavingsAccount!;
    return DropdownButtonFormField<ListCodeSavingsAccount>(
      items: pLista?.map<DropdownMenuItem<ListCodeSavingsAccount>>(
        (ListCodeSavingsAccount pCuenta) {
          return DropdownMenuItem(
            value: pCuenta,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("${pCuenta.operationCode!}  ${pCuenta.codMoney}"),
            ),
          );
        },
      ).toList(),
      onChanged: (value) {
        account = value;
        vMensajeValida = '';
        setState(() {});
      },
      icon: Icon(
        Icons.arrow_drop_down,
        color: UtilConstante.headerColor,
        size: 32,
      ),
      hint: const Text("Seleccione una cuenta"),
      elevation: 10,
      /*decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          //<-- SEE HERE
          borderSide: BorderSide(
            color: UtilConstante.headerColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          //<-- SEE HERE
          borderSide: BorderSide(
            color: UtilConstante.headerColor,
          ),
        ),
        filled: true,
        //fillColor: UtilConstante.colorAppPrimario,
      ),*/
    );
  }
}
