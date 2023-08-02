class RequestSavingsAccountTransferPOSResult {
  SavingsAccountTransferPOSResult? savingsAccountTransferPOSResult;

  RequestSavingsAccountTransferPOSResult({
    this.savingsAccountTransferPOSResult,
  });

  RequestSavingsAccountTransferPOSResult.fromJson(Map<String, dynamic> json) {
    savingsAccountTransferPOSResult = (json['SavingsAccountTransferPOSResult'] as Map<String,dynamic>?) != null ? SavingsAccountTransferPOSResult.fromJson(json['SavingsAccountTransferPOSResult'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['SavingsAccountTransferPOSResult'] = savingsAccountTransferPOSResult?.toJson();
    return json;
  }

  RequestSavingsAccountTransferPOSResult errorRespuesta(int statusCode) {
    final respuesta = RequestSavingsAccountTransferPOSResult();
    respuesta.savingsAccountTransferPOSResult = SavingsAccountTransferPOSResult();
    if (statusCode == 404) {
      respuesta.savingsAccountTransferPOSResult?.message = "servicio no encontrado";
      respuesta.savingsAccountTransferPOSResult?.state = 404;
    } else if (statusCode == 500) {
      respuesta.savingsAccountTransferPOSResult?.message = "No se puede acceder al servidor";
      respuesta.savingsAccountTransferPOSResult?.state = 500;
    } else {
      respuesta.savingsAccountTransferPOSResult?.message =
      "Error inesperado al consumir el servicio";
      respuesta.savingsAccountTransferPOSResult?.state = 600;
    }
    return respuesta;
  }
}

class SavingsAccountTransferPOSResult {
  String? codeBase;
  String? message;
  int? state;
  String? code;
  String? object;

  SavingsAccountTransferPOSResult({
    this.codeBase,
    this.message,
    this.state,
    this.code,
    this.object,
  });

  SavingsAccountTransferPOSResult.fromJson(Map<String, dynamic> json) {
    codeBase = json['CodeBase'] as String?;
    message = json['Message'] as String?;
    state = json['State'] as int?;
    code = json['Code'] as String?;
    object = json['Object'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['CodeBase'] = codeBase;
    json['Message'] = message;
    json['State'] = state;
    json['Code'] = code;
    json['Object'] = object;
    return json;
  }
}