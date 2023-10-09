class GetQRStateSingleUseResult {
  String? codeBase;
  String? message;
  int? state;
  String? code;
  QRState? qrState;

  GetQRStateSingleUseResult(
      {this.codeBase, this.message, this.state, this.code, this.qrState});

  GetQRStateSingleUseResult.fromJson(Map<String, dynamic> json) {
    codeBase = json['CodeBase'];
    message = json['Message'];
    state = json['State'];
    code = json['Code'];
    qrState = json['Object'] != null ? QRState.fromJson(json['Object']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CodeBase'] = codeBase;
    data['Message'] = message;
    data['State'] = state;
    data['Code'] = code;
    if (qrState != null) {
      data['Object'] = qrState!.toJson();
    }
    return data;
  }

  GetQRStateSingleUseResult errorRespuesta(int statusCode) {
    final respuesta = GetQRStateSingleUseResult();

    if (statusCode == 404) {
      respuesta.message = "servicio no encontrado";
      respuesta.state = 404;
    } else if (statusCode == 500) {
      respuesta.message = "No se puede acceder al servidor";
      respuesta.state = 500;
    } else {
      respuesta.message = "Error inesperado al consumir el servicio";
      respuesta.state = 600;
    }
    return respuesta;
  }
}

class QRState {
  String? customerPayment;
  String? idColletQuickResponse;
  String? idPaymentQuickResponse;
  String? idTransaction;
  String? paymentDate;
  String? state;

  QRState(
      {this.customerPayment,
      this.idColletQuickResponse,
      this.idPaymentQuickResponse,
      this.idTransaction,
      this.paymentDate,
      this.state});

  QRState.fromJson(Map<String, dynamic> json) {
    customerPayment = json['CustomerPayment'];
    idColletQuickResponse = json['IdColletQuickResponse'];
    idPaymentQuickResponse = json['IdPaymentQuickResponse'];
    idTransaction = json['IdTransaction'];
    paymentDate = json['PaymentDate'];
    state = json['State'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustomerPayment'] = customerPayment;
    data['IdColletQuickResponse'] = idColletQuickResponse;
    data['IdPaymentQuickResponse'] = idPaymentQuickResponse;
    data['IdTransaction'] = idTransaction;
    data['PaymentDate'] = paymentDate;
    data['State'] = state;
    return data;
  }
}
