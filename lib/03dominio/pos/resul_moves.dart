import 'package:postjava/helper/utilmethod.dart';

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

  List<ResulMoves> vCarga = [
    ResulMoves(
      agencia: 'POS VENTA',
      fechaTransaccion: UtilMethod.formatteDate(DateTime.now()),
      monto: 135.5,
      saldo: 180,
      nroTransaccion: '1',
      referencia: 'PAGO DE MEDICAMENTOS',
    ),
    ResulMoves(
      agencia: 'POS VENTA',
      fechaTransaccion: UtilMethod.formatteDate(DateTime.now()),
      monto: 132.5,
      saldo: 185,
      nroTransaccion: '2',
      referencia: 'PAGO DE ROPA',
    ),
    ResulMoves(
      agencia: 'POS VENTA',
      fechaTransaccion: UtilMethod.formatteDate(DateTime.now()),
      monto: 136.5,
      saldo: 183,
      nroTransaccion: '3',
      referencia: 'PAGO DE ROPA Y MEDICAMENTOS',
    ),
    ResulMoves(
      agencia: 'POS VENTA',
      fechaTransaccion: UtilMethod.formatteDate(DateTime.now()),
      monto: 1136.5,
      saldo: 1183,
      nroTransaccion: '5',
      referencia: 'PAGO DE MATERIAL DE TRABAJO',
    ),
    ResulMoves(
      agencia: 'POS VENTA',
      fechaTransaccion: UtilMethod.formatteDate(DateTime.now()),
      monto: 2136.5,
      saldo: 2183,
      nroTransaccion: '6',
      referencia: 'PAGO DE MATERIAL DE TRABAJO',
    ),
  ];
}
