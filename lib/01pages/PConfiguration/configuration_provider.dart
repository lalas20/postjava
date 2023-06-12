import 'package:flutter/material.dart';
import 'package:postjava/02service/service/User/srv_cliente_pos.dart';
import 'package:postjava/03dominio/generic/resul_provider.dart';
import 'package:postjava/helper/util_preferences.dart';
import '../../03dominio/user/resul_get_user_session_info.dart';
import '../helper/util_constante.dart';

class ConfigurationProvider with ChangeNotifier {
  late ResulProvider _resp;
  ResulProvider get resp => _resp;
  set resp(ResulProvider value) {
    _resp = value;
    notifyListeners();
  }

  saveDataIni(ListCodeSavingsAccount? pOperationEntity,
      ObjectGetUserSessionInfoResult pClientePos) async {
    if (pOperationEntity == null) {
      resp = ResulProvider(
        message: "Seleccione la cuenta",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }

    UtilPreferences.setIdOperationEntity(pOperationEntity.idOperationEntity!);
    UtilPreferences.setClientePos(pClientePos.personName!);
    UtilPreferences.setAcount(pOperationEntity.operationCode!);
    resp = ResulProvider(
      message: "Registro guardado correctamente",
      state: RespProvider.correcto.toString(),
    );
  }

  getUserSessionInfo() async {
    final resul = await SrvClientePos.getUserSessionInfo(
        UtilPreferences.getIdWebPersonClient());
    if (resul.getUserSessionInfoResult!.state == 1) {
      resp = ResulProvider(
        message: resul.getUserSessionInfoResult!.message!,
        state: RespProvider.correcto.toString(),
        obj: resul.getUserSessionInfoResult!.objectGetUserSessionInfoResult,
      );
    } else {
      resp = ResulProvider(
        message: resul.getUserSessionInfoResult!.message!,
        state: RespProvider.incorrecto.toString(),
      );
    }
  }
}
