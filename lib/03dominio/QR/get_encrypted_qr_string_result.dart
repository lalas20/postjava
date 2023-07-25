class GetEncryptedQrStringResult {
  String? codeBase;
  String? message;
  int? state;
  String? code;
  QRResul? object;

  GetEncryptedQrStringResult({
    this.codeBase,
    this.message,
    this.state,
    this.code,
    this.object,
  });

  GetEncryptedQrStringResult.fromJson(Map<String, dynamic> json)
      : codeBase = json['CodeBase'],
        message = json['Message'] as String?,
        state = json['State'] as int?,
        code = json['Code'],
        object = (json['Object'] as Map<String, dynamic>?) != null
            ? QRResul.fromJson(json['Object'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'CodeBase': codeBase,
        'Message': message,
        'State': state,
        'Code': code,
        'Object': object?.toJson()
      };

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

class QRResul {
  int? idQuickResponse;
  String? qrValue;

  QRResul({
    this.idQuickResponse,
    this.qrValue,
  });

  QRResul.fromJson(Map<String, dynamic> json)
      : idQuickResponse = json['IdQuickResponse'] as int?,
        qrValue = json['QrValue'] as String?;

  Map<String, dynamic> toJson() =>
      {'IdQuickResponse': idQuickResponse, 'QrValue': qrValue};
}
