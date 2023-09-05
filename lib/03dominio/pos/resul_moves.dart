import 'package:postjava/helper/utilmethod.dart';

class ResulMasterMoves {
  MasterResulMoves? masterResulMoves;
  String message = '';
  int state = 0;
  String code = '';
}

class MasterResulMoves {
  double? accountBalance;
  String? codeSavingsAccount;
  String? processDate;
  String? moneyCode;
  List<ResulMoves>? listResulMoves;
}

class ResulMoves {
  //datos transferencia
  String? fechaTransaccion;
  String? nroTransaccion;
  String? agencia;
  String? referencia;
  double? monto;
  double? saldo;

  ResulMoves({
    this.fechaTransaccion,
    this.nroTransaccion,
    this.agencia,
    this.monto,
    this.referencia,
    this.saldo,
  });
  Map<String, dynamic> toMap() => {
        'fechaTransaccion': "FechaHora:  $fechaTransaccion",
        'nroTransaccion': "Transacción:  $nroTransaccion",
        'agencia': "Agencia:  $agencia",
        'referencia': "Referencia:  $referencia",
        'montotxt': "Monto:  ${UtilMethod.stringByDouble(monto ?? 0)}",
        'saldotxt': "Saldo:  ${UtilMethod.stringByDouble(saldo ?? 0)}",
      };
}
