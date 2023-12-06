class GetEncryptedQrStringResultado {
  GetEncryptedQrStringResult? getEncryptedQrStringResult;

  GetEncryptedQrStringResultado({
    this.getEncryptedQrStringResult,
  });

  GetEncryptedQrStringResultado.fromJson(Map<String, dynamic> json) {
    getEncryptedQrStringResult =
        (json['GetEncryptedQrStringResult'] as Map<String, dynamic>?) != null
            ? GetEncryptedQrStringResult.fromJson(
                json['GetEncryptedQrStringResult'] as Map<String, dynamic>)
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['GetEncryptedQrStringResult'] = getEncryptedQrStringResult?.toJson();
    return json;
  }
}

class GetEncryptedQrStringResult {
  dynamic codeBase;
  String? message;
  int? state;
  dynamic code;
  Object? object;

  GetEncryptedQrStringResult({
    this.codeBase,
    this.message,
    this.state,
    this.code,
    this.object,
  });

  GetEncryptedQrStringResult.fromJson(Map<String, dynamic> json) {
    codeBase = json['CodeBase'];
    message = json['Message'] as String?;
    state = json['State'] as int?;
    code = json['Code'];
    object = (json['Object'] as Map<String, dynamic>?) != null
        ? Object.fromJson(json['Object'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['CodeBase'] = codeBase;
    json['Message'] = message;
    json['State'] = state;
    json['Code'] = code;
    json['Object'] = object?.toJson();
    return json;
  }

//espacop
  GetEncryptedQrStringResult errorRespuesta(int statusCode) {
    final respuesta = GetEncryptedQrStringResult();

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

class Object {
  int? idQuickResponse;
  String? qrValue;

  Object({
    this.idQuickResponse,
    this.qrValue,
  });

  Object.fromJson(Map<String, dynamic> json) {
    idQuickResponse = json['IdQuickResponse'] as int?;
    qrValue = json['QrValue'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['IdQuickResponse'] = idQuickResponse;
    json['QrValue'] = qrValue;
    return json;
  }
}
