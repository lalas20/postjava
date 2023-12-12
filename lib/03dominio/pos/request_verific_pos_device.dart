import 'request_pos_data.dart';

class RequestVerificPosDevice {
  String? pCodPosDevice;
  int? pIdPosDevice;

  RequestVerificPosDevice({this.pCodPosDevice, this.pIdPosDevice});

  RequestVerificPosDevice.fromJson(Map<String, dynamic> json) {
    pCodPosDevice = json['pCodPosDevice'];
    pIdPosDevice = json['pIdPosDevice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pCodPosDevice'] = pCodPosDevice;
    data['pIdPosDevice'] = pIdPosDevice;
    return data;
  }
}

/* resultado del request */
class VerificPosDeviceResult {
  VerificPosDeviceResult({
    this.codeBase,
    this.message,
    this.state,
    this.code,
  });

  String? codeBase;
  String? message;
  int? state;
  String? code;
  RequestDTOWebPosDevice? data;

  VerificPosDeviceResult.fromJson(Map<String, dynamic> json) {
    codeBase = json['CodeBase'];
    message = json['Message'] as String?;
    state = json['State'] as int?;
    code = json['Code'];
    data = (json['Object'] as Map<String, dynamic>?) != null
        ? RequestDTOWebPosDevice.fromJson(
            json['Object'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['CodeBase'] = codeBase;
    json['Message'] = message;
    json['State'] = state;
    json['Code'] = code;
    json['Object'] = data?.toJson();
    return json;
  }

  VerificPosDeviceResult errorRespuesta(int statusCode) {
    final respuesta = VerificPosDeviceResult();
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
