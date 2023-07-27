import 'dart:convert';

import 'package:postjava/03dominio/user/aditional_item.dart';
import 'package:postjava/03dominio/user/credential.dart';
import 'package:postjava/03dominio/user/saving_accounts.dart';

import '../../../03dominio/user/credential_verify_user.dart';
import '../../../03dominio/user/result.dart';
import '../../../03dominio/user/verify_user_result.dart';
import '../../helper/util_conextion.dart';

class SrvVerifyUser {

  static Future<Result> ObtieneCuentaByTarjetaPan(
  {required String pTarjetaPan,
  required String pFinger
  }  ) async {
    dynamic jsonResponse;
    Result respuesta = Result();
    try {
    final vCredencialVeryUser = Credential(
        user: pTarjetaPan,
        password: pFinger,
        channel: 3,
        aditionalItems: [
          AditionalItems(key: 'IdATM', value: '9'),
          AditionalItems(key: 'TypeAuthentication', value: 'MasterCard'),
        ]);
    final vRes = CredentialVerifyUser(credential: vCredencialVeryUser);

    String vJSON = jsonEncode(vRes.toJson());
    final response =
    await UtilConextion.httpPostSin(UtilConextion.verifyUser, vJSON);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      respuesta = Result.fromJson(jsonResponse);
    } else {
      respuesta = respuesta.errorRespuesta(response.statusCode);
    }
  } catch (e) {
  respuesta.verifyUserResult = VerifyUserResult();
  respuesta.verifyUserResult?.message = "error sub: ${e.toString()}";
  respuesta.verifyUserResult?.state = 3;
  }
    return respuesta;
  }


  static Future<Result> verifyUser(
      CredentialVerifyUser pCredentialVerifyUser) async {
    Result respuesta = Result();
    respuesta.verifyUserResult = VerifyUserResult();
    VerifyUserResult vObjVerify = VerifyUserResult();
    dynamic jsonResponse;

    try {
      final vPing = await UtilConextion.internetConnectivity();
      if (vPing == false) {
        vObjVerify.codeBase = UtilConextion.errorInternet;
        vObjVerify.state = 3;
        vObjVerify.message = "No tiene acceso a internet";
        respuesta.verifyUserResult = vObjVerify;
        return respuesta;
      }
      String vJSON = jsonEncode(pCredentialVerifyUser.toJson());
      final response =
          await UtilConextion.httpPostSin(UtilConextion.verifyUser, vJSON);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        respuesta = Result.fromJson(jsonResponse);
      } else {
        respuesta = respuesta.errorRespuesta(response.statusCode);
      }
    } catch (e) {
      respuesta.verifyUserResult = VerifyUserResult();
      respuesta.verifyUserResult?.message = "error sub: ${e.toString()}";
      respuesta.verifyUserResult?.state = 3;
    }
    return respuesta;
  }
}
