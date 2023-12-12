import 'package:flutter/material.dart';
import 'package:postjava/02service/service/User/srv_cliente_pos.dart';
import 'package:postjava/03dominio/generic/resul_provider.dart';
import 'package:postjava/03dominio/pos/request_verific_pos_device.dart';
import 'package:postjava/helper/enum.dart';
import 'package:postjava/helper/util_preferences.dart';

import '../helper/util_constante.dart';

class HomePageProvider with ChangeNotifier {
  late ResulProvider _resp;
  ResulProvider get resp => _resp;
  set resp(ResulProvider value) {
    _resp = value;
    notifyListeners();
  }

  verificaPOSDevice() async {
    String vCodPOS = UtilPreferences.getCodPosDevice();
    String vIdWebPosDevice = UtilPreferences.getIdPosDevice();
    final vrespu = await SrvClientePos.verificPosDevice(
        verificPosDevice: RequestVerificPosDevice(
            pCodPosDevice: vCodPOS,
            pIdPosDevice: int.tryParse(vIdWebPosDevice)));
    if (vrespu.state != 1) {
      _resp = ResulProvider(
        message: vrespu.message ?? '',
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }
    if (vrespu.data!.idcState == Estado.habilitado.stateVal) {
      _resp = ResulProvider(
        message: '',
        state: RespProvider.correcto.toString(),
      );
    } else {
      _resp = ResulProvider(
        message:
            'El dispositivo se encuentra en estado: ${estado(vrespu.data!.idcState!)} por lo tanto no podra continuar con las operaciones.',
        state: RespProvider.incorrecto.toString(),
      );
    }
  }

  String estado(int pIdcEstado) {
    String vestado = '';
    if (Estado.baja.stateVal == pIdcEstado) {
      vestado = Estado.baja.stateTxt;
    } else if (Estado.configuracion.stateVal == pIdcEstado) {
      vestado = Estado.configuracion.stateTxt;
    } else if (Estado.deshabilitado.stateVal == pIdcEstado) {
      vestado = Estado.deshabilitado.stateTxt;
    } else {
      vestado = '';
    }
    return vestado;
  }
}
