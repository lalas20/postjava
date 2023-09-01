// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:postjava/helper/util_preferences.dart';

class UtilConextion {
  static String errorInternet = "No tiene Acceso a Internet";
  static String error404 = "servicio no encontrado";
  static String error500 = "No se puede acceder al servidor";
  static String errorInesperado = "Error inesperado al consumir el servicio";

  static String server = 'https://bancaelectronica-test.prodem.bo';
  //static String server = 'https://bancaelectronica.prd.com.bo:3211'; //PRODUCCION
  static String puerto = ':3211/';
  static String puertoATM = ':3210/';

  static String hangarSafe = 'HangarSafeGate/';

  //ATM SavingsAccountTransferMobile
  static String savingsAccountTransferPOS =
      'rest/SavingAccountCoreServices.Services.SavingAccountService/SavingsAccountTransferPOS';

//OperacionesController
  static String verifyUser = 'rest/VerifyUser';
  static String getUserSessionInfo =
      'rest/ProdemNet.Services.Services.ProdemKeyServices/GetUserSessionInfo';
  static String getEncryptedQrString =
      'rest/SavingAccountCoreServices.Services.SavingAccountService/GetEncryptedQrString';
  static String savingsAccountExtractDataTransactionable =
      'rest/SavingAccountCoreServices.Services.SavingAccountService/SavingsAccountExtractDataTransactionable';
  //

  static Map<String, String> vHeaderSin = {'Content-Type': 'application/json'};
  // static Map<String, String> vHeader = {
  //   'Content-Type': 'application/json',
  //   'HangarAuthentication': UtilPreferences.getToken()
  // };

  static Map<String, String> vHeader() {
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'HangarAuthentication': UtilPreferences.getToken()
    };
    return header;
  }

  static Map<String, String> vHeaderByTokken(String pTokken) {
    return {
      'Content-Type': 'application/json',
      'HangarAuthentication': pTokken
    };
  }

  static Future<bool> internetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        print("Socket exception: ${e.toString()}");
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
      } else {
        print("Unhandled exception: ${e.toString()}");
      }
    }
    return true;
  }

  static Future<String> internetConnectivityTXT() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return 'correcto';
      }
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        return ("Socket exception: ${e.toString()}");
      } else if (e is TimeoutException) {
        //treat TimeoutException
        return ("Timeout exception: ${e.toString()}");
      } else {
        return ("Unhandled exception: ${e.toString()}");
      }
    }
    return 'ok';
  }

  static Future<http.Response> httpPostByNewTokken(
      {required String pAction,
      required String pJsonEncode,
      required String pTokken}) async {
    final vUrl = Uri.parse(server + puerto + pAction);
    final response = await http.post(vUrl,
        headers: vHeaderByTokken(pTokken), body: pJsonEncode);
    return response;
  }

  static Future<http.Response> httpPostSin(
      String pAction, String pJsonEncode) async {
    final vUrl = Uri.parse(server + puerto + hangarSafe + pAction);
    final response =
        await http.post(vUrl, headers: vHeaderSin, body: pJsonEncode);
    return response;
  }

  static Future<http.Response> httpPost(
      String pAction, String pJsonEncode) async {
    final vUrl = Uri.parse(server + puerto + pAction);
    final response =
        await http.post(vUrl, headers: vHeader(), body: pJsonEncode);
    return response;
  }

  static Future<http.Response> httpGetSin(String pAction, String pParam) async {
    final vUrl = Uri.parse("$server$puerto$hangarSafe$pAction?$pParam");
    final response = await http.get(vUrl);
    return response;
  }

  static Future<http.StreamedResponse> httpGetBody(
      String pAction, String pParam, String pBody) async {
    final vUrl = Uri.parse("$server$puerto$hangarSafe$pAction?$pParam");
    //Uri.http(authority, unencodedPath)
    http.Request req = http.Request('GET', vUrl)..body = pBody;

    final response = await req.send();
    return response;
  }

  static Future<String?> getIPAndress() async {
    final url = Uri.parse('https://api.ipify.org');
    final response = await http.get(url);
    return response.statusCode == 200 ? response.body : null;
  }
}
