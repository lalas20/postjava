import 'dart:convert';
import 'package:postjava/03dominio/pos/request_transfer_accounts.dart';
import 'package:postjava/03dominio/user/aditional_item.dart';
import 'package:postjava/03dominio/user/credential.dart';
import 'package:postjava/03dominio/user/saving_accounts.dart';

import '../../../03dominio/user/credential_verify_user.dart';
import '../../../03dominio/user/result.dart';
import '../../../03dominio/user/verify_user_result.dart';
import '../../../helper/utilmethod.dart';
import '../../helper/util_conextion.dart';

class SrvVerifyUser {
  static Future<Result> ObtieneCuentaByCI(
      {required String pCI, required String pFinger}) async {
    dynamic jsonResponse;
    Result respuesta = Result();
    try {
      final vPing = await UtilConextion.internetConnectivity();
      if (vPing == false) {
        respuesta.verifyUserResult = VerifyUserResult();
        respuesta.verifyUserResult!.codeBase = UtilConextion.errorInternet;
        respuesta.verifyUserResult!.state = 3;
        respuesta.verifyUserResult!.message = "No tiene acceso a internet";
        return respuesta;
      }
      final vCredencialVeryUser =
          Credential(user: pCI, password: pFinger, channel: 6, aditionalItems: [
        AditionalItems(key: 'IP', value: '255.255.255.255'),
        AditionalItems(key: 'TypeAuthentication', value: 'IdentityCard'),
        AditionalItems(key: 'Subchanel', value: 'ClientComerce'),
        AditionalItems(key: 'IdPOS', value: '0'),
      ]);
      final vRes = CredentialVerifyUser(credential: vCredencialVeryUser);

      String vJSON = jsonEncode(vRes.toJson());
      final response =
          await UtilConextion.httpPostSin(UtilConextion.verifyUser, vJSON);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        respuesta = Result.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final error400 = response.body;
        if (error400.contains('Token Expirado') ||
            error400.contains("Excepted Token")) {
          respuesta.verifyUserResult = VerifyUserResult();
          respuesta.verifyUserResult?.code = '99';
          respuesta.verifyUserResult?.message = UtilMethod.vMensajeError404;
          respuesta.verifyUserResult?.state = 2;
        } else {
          respuesta = respuesta.errorRespuesta(response.statusCode);
        }
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

  static Future<Result> ObtieneCuentaByTarjetaPan(
      {required String pTarjetaPan, required String pFinger}) async {
    dynamic jsonResponse;
    Result respuesta = Result();
    try {
      final vPing = await UtilConextion.internetConnectivity();
      if (vPing == false) {
        respuesta.verifyUserResult = VerifyUserResult();
        respuesta.verifyUserResult!.codeBase = UtilConextion.errorInternet;
        respuesta.verifyUserResult!.state = 3;
        respuesta.verifyUserResult!.message = "No tiene acceso a internet";
        return respuesta;
      }
      final vCredencialVeryUser = Credential(
          user: pTarjetaPan,
          password: pFinger,
          channel: 6,
          aditionalItems: [
            AditionalItems(key: 'IP', value: '255.255.255.255'),
            AditionalItems(key: 'TypeAuthentication', value: 'MasterCard'),
            AditionalItems(key: 'Subchanel', value: 'ClientComerce'),
            AditionalItems(key: 'IdPOS', value: '0'),
          ]);
      final vRes = CredentialVerifyUser(credential: vCredencialVeryUser);

      String vJSON = jsonEncode(vRes.toJson());
      final response =
          await UtilConextion.httpPostSin(UtilConextion.verifyUser, vJSON);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        respuesta = Result.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final error400 = response.body;
        if (error400.contains('Token Expirado') ||
            error400.contains("Excepted Token")) {
          respuesta.verifyUserResult = VerifyUserResult();
          respuesta.verifyUserResult?.code = '99';
          respuesta.verifyUserResult?.message = UtilMethod.vMensajeError404;
          respuesta.verifyUserResult?.state = 2;
        } else {
          respuesta = respuesta.errorRespuesta(response.statusCode);
        }
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
