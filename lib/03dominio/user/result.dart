import 'verify_user_result.dart';

class Result {
  VerifyUserResult? verifyUserResult = VerifyUserResult();

  Result({
    this.verifyUserResult,
  });

  Result.fromJson(Map<String, dynamic> json)
      : verifyUserResult =
            (json['VerifyUserResult'] as Map<String, dynamic>?) != null
                ? VerifyUserResult.fromJson(
                    json['VerifyUserResult'] as Map<String, dynamic>)
                : null;

  Map<String, dynamic> toJson() =>
      {'VerifyUserResult': verifyUserResult?.toJson()};

  Result errorRespuesta(int statusCode) {
    final respuesta = Result();
    respuesta.verifyUserResult = VerifyUserResult();
    if (statusCode == 404) {
      respuesta.verifyUserResult?.message = "servicio no encontrado";
      respuesta.verifyUserResult?.state = 404;
    } else if (statusCode == 500) {
      respuesta.verifyUserResult?.message = "No se puede acceder al servidor";
      respuesta.verifyUserResult?.state = 500;
    } else {
      respuesta.verifyUserResult?.message =
          "Error inesperado al consumir el servicio";
      respuesta.verifyUserResult?.state = 600;
    }
    return respuesta;
  }
}
