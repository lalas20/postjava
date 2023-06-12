class ResulVoucher {
  //datos transferencia
  int? nroTransaccion;
  String? titular;
  String? fechaTransaccion;
  double? montoPago;

  //cuenta origen
  String? cuentaOrigen;
  //cuenta destino
  String? cuentaDestino;
  String? bancoDestino;
  //concepto
  String? glosa;
  //tipo pago
  String? tipoPago;
  ResulVoucher({
    this.bancoDestino,
    this.cuentaDestino,
    this.cuentaOrigen,
    this.fechaTransaccion,
    this.glosa,
    this.montoPago,
    this.nroTransaccion,
    this.titular,
    this.tipoPago,
  });

  Map<String, dynamic> toMap() => {
        'nroTransaccion': nroTransaccion,
        'titular': titular,
        'fechaTransaccion': fechaTransaccion,
        'montoPago': montoPago,
        'cuentaOrigen': cuentaOrigen,
        'cuentaDestino': cuentaDestino,
        'bancoDestino': bancoDestino,
        'glosa': glosa,
        'tipoPago': tipoPago,
      };
}
