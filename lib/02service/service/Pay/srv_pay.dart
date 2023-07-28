import 'dart:convert';

import 'package:postjava/03dominio/pos/request_transfer_accounts.dart';
import 'package:postjava/03dominio/pos/resul_moves.dart';
import 'package:postjava/03dominio/user/result.dart';
import 'package:postjava/03dominio/user/verify_user_result.dart';
import 'package:postjava/helper/util_preferences.dart';

import '../../../03dominio/QR/get_encrypted_qr_string_result.dart';
import '../../../03dominio/pos/resul_voucher.dart';
import '../../../03dominio/user/resul_get_user_session_info.dart';
import '../../helper/util_conextion.dart';

class SrvPay {
  static Future<List<ResulMoves>> getLasMoves() async {
    List<ResulMoves> vLista = ResulMoves.vCarga;

    return vLista;
  }

  static Future<GetEncryptedQrStringResult> getQrPay(
      {required double pAmount, required String pGlosa}) async {


    Map<String, dynamic> toMap =
    {
          'idPerson': UtilPreferences.getIdWebPersonClient(),
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
          UtilConextion.getEncryptedQrString,vJSON );
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        respuesta = GetEncryptedQrStringResult.fromJson(jsonResponse['GetEncryptedQrStringResult']);
      } else {
        respuesta = respuesta.errorRespuesta(response.statusCode);
      }


    } catch (e) {
      respuesta.message = "error sub: ${e.toString()}";
      respuesta.state = 3;
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

  static Future<Result> savingsTransferAccounts(
      {required String pCodeSavingAccount,
        required String pIdMoneyTrans,
        required double pAmountTrans,
        required String pCodeSavingAccountTarget,
        required String pTokken  }
      )
  async
  {
    dynamic jsonResponse;
    Result respuesta = Result();
    try{
      final vPing = await UtilConextion.internetConnectivity();
      if (vPing == false) {
        respuesta.verifyUserResult=VerifyUserResult();
        respuesta.verifyUserResult!.codeBase = UtilConextion.errorInternet;
        respuesta.verifyUserResult!.state = 3;
        respuesta.verifyUserResult!.message = "No tiene acceso a internet";
        return respuesta;
      }
      final objRequesTrans=RequestTransferAccounts(objParameter: ObjParameter(amountTrans: pAmountTrans,codeSavingAccount: pCodeSavingAccount,codeSavingAccountTarget: pCodeSavingAccountTarget,idMoneyTrans: pIdMoneyTrans));
      String vJSON = jsonEncode(objRequesTrans.toJson());
      final response =
      await UtilConextion.httpPostByNewTokken(pAction: UtilConextion.transferAccounts,pJsonEncode:  vJSON,pTokken: pTokken);
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        respuesta = Result.fromJson(jsonResponse);
      } else {
        respuesta = respuesta.errorRespuesta(response.statusCode);
      }
    }
    catch(e)
    {
      respuesta.verifyUserResult = VerifyUserResult();
      respuesta.verifyUserResult?.message = "error sub: ${e.toString()}";
      respuesta.verifyUserResult?.state = 3;
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
        montoPago: 180,
        nroTransaccion: 122245547,
        titular: 'Perlita perlita');

    return vResul;
  }
}
