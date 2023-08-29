import 'package:flutter/material.dart';
import 'package:postjava/02service/channel/plataformchannel.dart';
import 'package:postjava/02service/service/User/srv_cliente_pos.dart';
import 'package:postjava/03dominio/generic/resul_provider.dart';
import 'package:postjava/03dominio/user/result.dart';
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
      ObjectGetUserSessionInfoResult pClientePos,
      {required String pNamePos, required String pAndroidID}) async {
    if (pOperationEntity == null) {
      resp = ResulProvider(
        message: "Seleccione la cuenta",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }
    if (pNamePos.isEmpty) {
      resp = ResulProvider(
        message: "Nombre POS, es campo obligatorio",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }
    if (pAndroidID.isEmpty) {
      resp = ResulProvider(
        message: "Identificador POS, es campo obligatorio",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }

    UtilPreferences.setNamePos(pNamePos);
    UtilPreferences.setIdOperationEntity(pOperationEntity.idOperationEntity!);
    UtilPreferences.setClientePos(pClientePos.personName!);
    UtilPreferences.setAcount(pOperationEntity.operationCode!);
    UtilPreferences.setIsSetting(true);
    UtilPreferences.setCodMoney(
        pOperationEntity.codMoney == 'BS' ? 'BOB' : pOperationEntity.codMoney!);
    resp = ResulProvider(
      message: "Registro guardado correctamente",
      state: RespProvider.correcto.toString(),
    );
  }

  getUserSessionInfo() async {
    final resul = await SrvClientePos.getUserSessionInfo(
        UtilPreferences.getIdWebPersonClient());
    if (resul.getUserSessionInfoResult!.state == 1) {
      UtilPreferences.setsIdPerson(resul.getUserSessionInfoResult!
          .objectGetUserSessionInfoResult!.sIdPerson!);
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

  getAndroidIDPos() async {
    try {
      final vresul = await PlaformChannel().settingPos.getAndroidIDPos();
      if (vresul!.isEmpty) {
        resp = ResulProvider(
          message: "sin data",
          state: RespProvider.incorrecto.toString(),
        );
      } else {
        resp = ResulProvider(
            message: "registro recuperado satisfactoriamente",
            state: RespProvider.correcto.toString(),
            obj: vresul);
      }
    } catch (e) {
      resp = ResulProvider(
        message: "Error: $e",
        state: RespProvider.incorrecto.toString(),
      );
    }
  }
}
