import 'package:flutter/material.dart';
import 'package:postjava/02service/service/User/srv_cliente_pos.dart';
import 'package:postjava/03dominio/user/aditional_item.dart';

import 'package:postjava/helper/util_preferences.dart';
import 'package:postjava/helper/utilmethod.dart';

import '../helper/util_constante.dart';

class LoginProviders with ChangeNotifier {
  String _resp = '';

  String get resp => _resp;

  set resp(String value) {
    _resp = value;
    notifyListeners();
  }

  autentica(String pDI, String pPass) async {
    final resul = await SrvClientePos.autentica(pDI, pPass);
    if (resul.verifyUserResult?.state == 1) {
      AditionalItems? iTems = resul.verifyUserResult!.object!.aditionalItems!
          .firstWhere((element) => element.key == 'IdUsuario');
      UtilPreferences.setIdUsuario(iTems.value!);
      iTems = resul.verifyUserResult!.object!.aditionalItems!
          .firstWhere((element) => element.key == 'IdWebPersonClient');
      UtilPreferences.setIdWebPersonClient(iTems.value!);

      UtilPreferences.setToken(resul.verifyUserResult!.object!.token!);
      UtilPreferences.setUser(resul.verifyUserResult!.object!.user!);

      UtilMethod.imprimir("mensajes get;");
      UtilMethod.imprimir(UtilPreferences.getIdUsuario());
      UtilMethod.imprimir(UtilPreferences.getIdWebPersonClient());
      UtilMethod.imprimir(UtilPreferences.getToken());
      UtilMethod.imprimir(UtilPreferences.getUser());
      resp = RespProvider.correcto.toString();
    } else {
      resp = RespProvider.incorrecto.toString();
    }
  }
}
