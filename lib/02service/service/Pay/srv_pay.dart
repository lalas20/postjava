import 'dart:convert';

import 'package:postjava/02service/service/User/srv_cliente_pos.dart';
import 'package:postjava/03dominio/pos/request_savings_account_transfer_pos_result.dart';
import 'package:postjava/03dominio/pos/resul_moves.dart';
import 'package:postjava/helper/util_preferences.dart';
import 'package:postjava/helper/utilmethod.dart';

import '../../../03dominio/QR/get_encrypted_qr_string_result.dart';
import '../../../03dominio/pos/resul_voucher.dart';
import '../../helper/util_conextion.dart';

class SrvPay {
  static Future<ResulMasterMoves> getLasMoves() async {
    List<ResulMoves> vLista = [];
    ResulMasterMoves resultado = ResulMasterMoves();
    MasterResulMoves vEntidad = MasterResulMoves();
    final resul =
        await SrvClientePos.savingsAccountExtractDataTransactionable();
    if (resul.state == 1) {
      vEntidad.accountBalance = resul.object!.accountBalance;
      vEntidad.codeSavingsAccount = resul.object!.codeSavingsAccount;
      vEntidad.moneyCode = resul.object!.moneyCode;
      vEntidad.processDate = UtilMethod.formatteDate(
          UtilMethod.parseJsonDate(resul.object!.processDate!));
      for (var item in resul.object!.colDetailsMovemment!) {
        vLista.add(ResulMoves(
            agencia: item.officeTransaction,
            fechaTransaccion: UtilMethod.formatteDate(
                UtilMethod.parseJsonDate(item.dateTransaction!)),
            monto: item.deposit == 0 ? -1 * item.withdrawal! : item.deposit,
            nroTransaccion: item.descriptionOperation,
            referencia: item.reference,
            saldo: item.amountBalance));
      }
      vEntidad.listResulMoves = vLista;
      resultado.masterResulMoves = vEntidad;
      resultado.state = 1;
      resultado.message = resul.message!;
    } else {
      resultado.state = resul.state!;
      resultado.message = resul.message!;
      resultado.code = resul.code ?? '';
    }
    return resultado;
  }

  static Future<GetEncryptedQrStringResult> getQrPay(
      {required double pAmount, required String pGlosa}) async {
    Map<String, dynamic> toMap = {
      'idPerson': UtilPreferences.getsIdPerson(),
      'accountCode': UtilPreferences.getAcount(),
      'moneyCode': UtilPreferences.getCodMoney(),
      'amount': pAmount,
      'isUniqueUse': true,
      'expiredOption': 10,
      'reference': pGlosa,
      'IdQuickResponse': 0
    };
    GetEncryptedQrStringResult respuesta = GetEncryptedQrStringResult();
    final vPing = await UtilConextion.internetConnectivity();
    if (vPing == false) {
      respuesta.codeBase = UtilConextion.errorInternet;
      respuesta.state = 3;
      respuesta.message = "No tiene acceso a internet";
      return respuesta;
    }
    dynamic jsonResponse;
    try {
      String vJSON = jsonEncode(toMap);
      final response = await UtilConextion.httpPost(
          UtilConextion.getEncryptedQrString, vJSON);
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        respuesta = GetEncryptedQrStringResult.fromJson(
            jsonResponse['GetEncryptedQrStringResult']);
      } else if (response.statusCode == 400) {
        final error400 = response.body;
        if (error400.contains('Token Expirado') ||
            error400.contains("Excepted Token")) {
          respuesta.code = '99';
          respuesta.message = UtilMethod.vMensajeError404;
          respuesta.state = 2;
        } else {
          respuesta = respuesta.errorRespuesta(response.statusCode);
        }
      } else {
        respuesta = respuesta.errorRespuesta(response.statusCode);
      }
    } catch (e) {
      respuesta.message = "error sub: ${e.toString()}";
      respuesta.state = 3;
    }
    return respuesta;
  }

  static Future<RequestSavingsAccountTransferPOSResult>
      savingsTransferAccounts({
    required String pCodeSavingAccount,
    required String pIdMoneyTrans,
    required double pAmountTrans,
    required String pCodeSavingAccountTarget,
    required String pBeneficiarioName,
    required String pTokken,
    required String pGlosa,
  }) async {
    dynamic jsonResponse;

    RequestSavingsAccountTransferPOSResult respuesta =
        RequestSavingsAccountTransferPOSResult();
    String vJSON = '';
    try {
      final vPing = await UtilConextion.internetConnectivity();
      if (vPing == false) {
        respuesta.savingsAccountTransferPOSResult =
            SavingsAccountTransferPOSResult();
        respuesta.savingsAccountTransferPOSResult!.codeBase =
            UtilConextion.errorInternet;
        respuesta.savingsAccountTransferPOSResult!.state = 3;
        respuesta.savingsAccountTransferPOSResult!.message =
            "No tiene acceso a internet";
        return respuesta;
      }
      Map<String, dynamic> map = {
        "CodeSavingAccountSource": pCodeSavingAccount,
        "IdPerson": UtilPreferences.getsIdPerson(),
        "CodeSavingAccountTarget": pCodeSavingAccountTarget,
        "AmountTransfer": pAmountTrans,
        "IdMoneyTransfer": 1,
        "Observation": pGlosa,
        "IsNaturalClient": true,
        "reasonDestiny": "",
        "ApplyGeneratePCC01": false,
        "IdUser": UtilPreferences.getIdUsuario(),
        "IMEI": "",
        "location": "",
        "IpAddress": "0.0.0.0",
        "BeneficiaryName": pBeneficiarioName
      };
      vJSON = jsonEncode(map);
      final response = await UtilConextion.httpPostByNewTokken(
          pAction: UtilConextion.savingsAccountTransferPOS,
          pJsonEncode: vJSON,
          pTokken: UtilPreferences.getToken());
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        respuesta =
            RequestSavingsAccountTransferPOSResult.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final error400 = response.body;
        if (error400.contains('Token Expirado') ||
            error400.contains("Excepted Token")) {
          respuesta.savingsAccountTransferPOSResult =
              SavingsAccountTransferPOSResult();
          respuesta.savingsAccountTransferPOSResult?.code = '99';
          respuesta.savingsAccountTransferPOSResult?.message =
              UtilMethod.vMensajeError404;
          respuesta.savingsAccountTransferPOSResult?.state = 2;
        } else {
          respuesta = respuesta.errorRespuesta(response.statusCode);
        }
      } else {
        respuesta = respuesta.errorRespuesta(response.statusCode);
      }
    } catch (e) {
      UtilMethod.writeToLog("error:${e.toString()}");
      UtilMethod.writeToLog("vJSON:$vJSON");
      UtilMethod.writeToLog(
          "SavingsAccountTransferPOS:${UtilConextion.savingsAccountTransferPOS}");
      UtilMethod.writeToLog("getToken:${UtilPreferences.getToken()}");

      respuesta.savingsAccountTransferPOSResult =
          SavingsAccountTransferPOSResult();
      respuesta.savingsAccountTransferPOSResult?.message =
          "error: ${e.toString()}";
      respuesta.savingsAccountTransferPOSResult?.state = 3;
    }
    return respuesta;
  }

  static Future<ResulVoucher> printVoucher(String pIdTransaccion) async {
    final vResul = ResulVoucher(
        bancoDestino: 'BANCO PRODEM',
        cuentaDestino: '117-2-1-11208-1',
        cuentaOrigen: '117-2-1-XXXX-1',
        fechaTransaccion: DateTime.now().toString(),
        glosa: 'Pago de algo',
        montoPago: "1802",
        nroTransaccion: "122245547",
        titular: 'Perlita perlita');

    return vResul;
  }
}
