import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:postjava/02service/channel/plataformchannel.dart';
import 'package:postjava/02service/service/User/srv_cliente_pos.dart';
import 'package:postjava/03dominio/generic/resul_provider.dart';
import 'package:postjava/03dominio/pos/request_pos_data.dart';
import 'package:postjava/helper/util_preferences.dart';
import 'package:postjava/helper/utilmethod.dart';
import '../../03dominio/user/resul_get_user_session_info.dart';
import '../helper/util_constante.dart';
import 'package:postjava/helper/enum.dart';
import 'package:device_info/device_info.dart';

class ConfigurationProvider with ChangeNotifier {
  late ResulProvider _resp;
  String namePos = UtilPreferences.getNamePos();
  ResulProvider get resp => _resp;
  set resp(ResulProvider value) {
    _resp = value;
    notifyListeners();
  }

  saveDataIni(ListCodeSavingsAccount? pOperationEntity,
      ObjectGetUserSessionInfoResult pClientePos,
      {required String pNamePos,
      required String pAndroidID,
      required BuildContext context}) async {
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
    UtilMethod.imprimir(Estado.configuracion.toString());
    UtilMethod.imprimir(Estado.deshabilitado.toString());
    RequestDTOWebPosDevice vEntidad = RequestDTOWebPosDevice();
    vEntidad.codPosDevice = pAndroidID;
    vEntidad.idcState = Estado.configuracion.stateVal;
    vEntidad.idWebPersonClient = UtilPreferences.getIdWebPersonClient();
    vEntidad.operation = Estado.configuracion.stateTxt;
    vEntidad.posData = await posInfo(context);

    if (vEntidad.posData == '') {
      resp = ResulProvider(
        message:
            "Las caracteristicas del dispositivos no se pudieron encontrar",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }
    final respuesta = await SrvClientePos.saveWebPosDevice(posDevice: vEntidad);
    if (respuesta.state != 1) {
      resp = ResulProvider(
        message: respuesta.message ?? '',
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }
    UtilPreferences.setIdPosDevice(respuesta.object?.idWebPosDevice);
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
        obj: resul.getUserSessionInfoResult!.code!,
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

Future<String> posInfo(BuildContext context) async {
  String resul = '';
  late AndroidDeviceInfo build;
  late IosDeviceInfo iosInfo;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (Theme.of(context).platform == TargetPlatform.android) {
      build = await deviceInfoPlugin.androidInfo;

      resul = 'version.securityPatch:${build.version.securityPatch}';
      resul += 'version.sdkInt: ${build.version.sdkInt}';
      resul += 'version.release: ${build.version.release}';
      resul += 'version.previewSdkInt:${build.version.previewSdkInt}';
      resul += 'version.incremental: ${build.version.incremental}';
      resul += 'version.codename:${build.version.codename}';
      resul += 'version.baseOS: ${build.version.baseOS}';
      resul += 'board:${build.board}';
      resul += 'bootloader:${build.bootloader}';
      resul += 'brand:${build.brand}';
      resul += 'device: ${build.device}';
      resul += 'display: ${build.display}';
      resul += 'fingerprint:${build.fingerprint}';
      resul += 'hardware: ${build.hardware}';
      resul += 'host: ${build.host}';
      resul += 'id: ${build.id}';
      resul += 'manufacturer:${build.manufacturer}';
      resul += 'model: ${build.model}';
      resul += 'product: ${build.product}';
      resul += 'supported32BitAbis:${build.supported32BitAbis}';
      resul += 'supported64BitAbis: ${build.supported64BitAbis}';
      resul += 'supportedAbis: ${build.supportedAbis}';
      resul += 'tags:${build.tags}';
      resul += 'type: ${build.type}';
      resul += 'isPhysicalDevice:${build.isPhysicalDevice}';
      resul += 'androidId: ${build.androidId}';
      resul += 'systemFeatures:${build.systemFeatures}';
      //resul = jsonEncode(build);
      // Puedes acceder a más propiedades de androidInfo según tus necesidades
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      iosInfo = await deviceInfoPlugin.iosInfo;
      resul = jsonEncode(iosInfo);
    }
  } catch (e) {
    UtilMethod.imprimir('Error al obtener la información del dispositivo: $e');
    resul = '';
  }
  return resul;
}
