import '../../../03dominio/user/resul_get_user_session_info.dart';

class SrvPay {
  static Future<ResulGetUserSessionInfo> getQrPay() async {
    ResulGetUserSessionInfo respuesta = ResulGetUserSessionInfo();
    respuesta.getUserSessionInfoResult = GetUserSessionInfoResult();
    try {
      respuesta.getUserSessionInfoResult!.state = 1;
      respuesta.getUserSessionInfoResult!.code = "1";
      respuesta.getUserSessionInfoResult!.codeBase = "1";
      respuesta.getUserSessionInfoResult!.message =
          "Registro recuperado correctamente";
    } catch (e) {
      respuesta.getUserSessionInfoResult!.state = 3;
      respuesta.getUserSessionInfoResult!.code = "3";
      respuesta.getUserSessionInfoResult!.codeBase = "3";
      respuesta.getUserSessionInfoResult!.message = e.toString();
    }
    return respuesta;
  }

  static Future<ResulGetUserSessionInfo> savingsAccountByCard(
      String pCard) async {
    ResulGetUserSessionInfo respuesta = ResulGetUserSessionInfo();
    respuesta.getUserSessionInfoResult = GetUserSessionInfoResult();
    try {
      respuesta.getUserSessionInfoResult!.state = 1;
      respuesta.getUserSessionInfoResult!.code = "1";
      respuesta.getUserSessionInfoResult!.codeBase = "1";
      respuesta.getUserSessionInfoResult!.message =
          "Registro recuperado correctamente";
    } catch (e) {
      respuesta.getUserSessionInfoResult!.state = 3;
      respuesta.getUserSessionInfoResult!.code = "3";
      respuesta.getUserSessionInfoResult!.codeBase = "3";
      respuesta.getUserSessionInfoResult!.message = e.toString();
    }
    return respuesta;
  }

  static Future<ResulGetUserSessionInfo> savingsAccountByCiAndFinger(
      String pCI, String pFinger) async {
    ResulGetUserSessionInfo respuesta = ResulGetUserSessionInfo();
    respuesta.getUserSessionInfoResult = GetUserSessionInfoResult();
    try {
      respuesta.getUserSessionInfoResult!.state = 1;
      respuesta.getUserSessionInfoResult!.code = "1";
      respuesta.getUserSessionInfoResult!.codeBase = "1";
      respuesta.getUserSessionInfoResult!.message =
          "Registro recuperado correctamente";
    } catch (e) {
      respuesta.getUserSessionInfoResult!.state = 3;
      respuesta.getUserSessionInfoResult!.code = "3";
      respuesta.getUserSessionInfoResult!.codeBase = "3";
      respuesta.getUserSessionInfoResult!.message = e.toString();
    }
    return respuesta;
  }
}
