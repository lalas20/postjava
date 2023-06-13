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
    await Future.delayed(const Duration(seconds: 2));
    final resul = await SrvPay.getLasMoves();

    resp = ResulProvider(
      message: "Registro recuperados saatisfactoriamente",
      state: RespProvider.correcto.toString(),
      obj: resul,
    );
  }
}
