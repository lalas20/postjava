import 'dart:convert';

import 'package:postjava/03dominio/user/aditional_item.dart';
import 'package:postjava/03dominio/user/credential.dart';
import 'package:postjava/03dominio/user/result.dart';
import 'package:postjava/03dominio/user/savings_account_extract_data_transactionable_result.dart';
import 'package:postjava/helper/util_preferences.dart';

import '../../../03dominio/user/credential_verify_user.dart';
import '../../../03dominio/user/resul_get_user_session_info.dart';
import '../../../03dominio/user/verify_user_result.dart';
import '../../helper/util_conextion.dart';

class SrvClientePos {

  static Future<SavingsAccountExtractDataTransactionableResult> SavingsAccountExtractDataTransactionable() async {
    SavingsAccountExtractDataTransactionableResult respuesta = SavingsAccountExtractDataTransactionableResult();

    dynamic jsonResponse;
    try {
      final vPing = await UtilConextion.internetConnectivity();
      if (vPing == false) {
       respuesta.codeBase = UtilConextion.errorInternet;
       respuesta.state = 3;
       respuesta.message = "No tiene acceso a internet";
        return respuesta;
      }
      Map<String, String> vParam = {
        "CodeSavingAccount":UtilPreferences.getAcount(),
        "IdPerson":UtilPreferences.getsIdPerson(),
        "IdUser":UtilPreferences.getIdUsuario(),
        "IMEI":"",
        "location":"",
        "IpAddress":"0.0.0.0"
      };

      String vJSON = jsonEncode(vParam);
      final response =
      await UtilConextion.httpPost(UtilConextion.savingsAccountExtractDataTransactionable, vJSON);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        respuesta = SavingsAccountExtractDataTransactionableResult.fromJson(jsonResponse['SavingsAccountExtractDataTransactionableResult']);
      } else {
        respuesta = respuesta.errorRespuesta(response.statusCode);
      }
    } catch (e) {
      respuesta = SavingsAccountExtractDataTransactionableResult();
      respuesta.message =
      "error sub: ${e.toString()}";
      respuesta.state = 3;
    }
    return respuesta;
  }

  static Future<ResulGetUserSessionInfo> getUserSessionInfo(
      String pIdWebClient) async {
    ResulGetUserSessionInfo respuesta = ResulGetUserSessionInfo();
    GetUserSessionInfoResult getUserSessionInfo = GetUserSessionInfoResult();
    dynamic jsonResponse;
    try {
      final vPing = await UtilConextion.internetConnectivity();
      if (vPing == false) {
        getUserSessionInfo.codeBase = UtilConextion.errorInternet;
        getUserSessionInfo.state = 3;
        getUserSessionInfo.message = "No tiene acceso a internet";
        respuesta.getUserSessionInfoResult = getUserSessionInfo;
        return respuesta;
      }

      Map<String, String> vWebCliente = {
        'vIdWebClient': UtilPreferences.getIdWebPersonClient()
      };

      String vJSON = jsonEncode(vWebCliente);
      final response =
          await UtilConextion.httpPost(UtilConextion.getUserSessionInfo, vJSON);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        respuesta = ResulGetUserSessionInfo.fromJson(jsonResponse);
      } else {
        respuesta = respuesta.errorRespuesta(response.statusCode);
      }
    } catch (e) {
      respuesta.getUserSessionInfoResult = GetUserSessionInfoResult();
      respuesta.getUserSessionInfoResult?.message =
          "error sub: ${e.toString()}";
      respuesta.getUserSessionInfoResult?.state = 3;
    }
    return respuesta;
  }

  static Future<Result> autentica(pDI, pPass) async {
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

      final vCredencialVeryUser = Credential(
          user: pDI,
          password: pPass,
          channel: 1,
          aditionalItems: [
            AditionalItems(key: 'IP', value: '255.255.255.255')
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
}
