import 'package:flutter/material.dart';

import '../../02service/service/Pay/srv_pay.dart';
import '../../03dominio/generic/resul_provider.dart';
import '../helper/util_constante.dart';

class LastMovesProvider with ChangeNotifier {
  late ResulProvider _resp;
  ResulProvider get resp => _resp;
  set resp(ResulProvider value) {
    _resp = value;
    notifyListeners();
  }

  getLasMovimiento() async {
    final resul = await SrvPay.getLasMoves();
    if (resul.state == 1) {
      resp = ResulProvider(
        message: "Registro recuperados satisfactoriamente",
        state: RespProvider.correcto.toString(),
        obj: resul,
      );
    } else {
      resp = ResulProvider(
          message: resul.message,
          state: RespProvider.incorrecto.toString(),
          obj: resul.code);
    }
  }
}
