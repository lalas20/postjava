import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as imglib;
import 'package:postjava/02service/channel/plataformchannel.dart';
import 'package:postjava/02service/service/Pay/srv_pay.dart';
import 'package:postjava/02service/service/User/srv_cliente_pos.dart';
import 'package:postjava/02service/service/User/srv_verify_user.dart';
import 'package:postjava/03dominio/user/aditional_item.dart';
import 'package:postjava/03dominio/user/saving_accounts.dart';
import 'package:postjava/helper/util_preferences.dart';

import '../../03dominio/generic/resul_provider.dart';
import '../../03dominio/user/resul_get_user_session_info.dart';
import '../helper/util_constante.dart';

class PagoProvider with ChangeNotifier {
  late ResulProvider _resp;
  ResulProvider get resp => _resp;
  set resp(ResulProvider value) {
    _resp = value;
    notifyListeners();
  }

  String vIdSavingAcount = '';
  String vFile = '';
  String vCodigo = '';
  double vMontoPagar = 0;
  String fingerDP="";
  String nameDeviceDP="";
  List<SavingAccounts> vListaCuentaByCi=[];
  Uint8List vImgQR = Uint8List(0);
  String tokkeSavinAcountTransfer='';
  String beneficiarioName='';

  bool tieneFinger = false;

  getCardFinger() async {
    await Future.delayed(const Duration(seconds: 2));
    resp = ResulProvider(
      message: 'correcto',
      state: RespProvider.correcto.toString(),
    );
  }

  getNameDeviceDP() async {
    final resul = PlaformChannel();
    nameDeviceDP=  await resul.fingerChannel.captureNameDeviceDP();
    if(nameDeviceDP.isEmpty) {
      resp = ResulProvider(
        message: "Dispositivo no encontrado",
        state: RespProvider.incorrecto.toString(),
      );
    }
    else
      {
        resp = ResulProvider(
          message: "Registro recuperado satisfactoriamente",
          state: RespProvider.correcto.toString(),
          obj: nameDeviceDP,
        );
      }
  }

  getFingerDP() async {
    final resul = PlaformChannel();
    fingerWIdentityCard=  await resul.fingerChannel.captureFingerISODP();
    if(fingerWIdentityCard.isEmpty) {
      resp = ResulProvider(
        message: "Huella no capturada",
        state: RespProvider.incorrecto.toString(),
      );
    }
    else
    {
      resp = ResulProvider(
        message: "Registro recuperado satisfactoriamente",
        state: RespProvider.correcto.toString(),
        obj: fingerWIdentityCard,
      );
    }
  }



  getDocIdentidadPago({required String pCi}) async {
    if (pCi.isEmpty) {
      resp = ResulProvider(
        message: "La Tarjeta es obligatorio",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }

    final resul=await SrvVerifyUser.ObtieneCuentaByCI(pCI: pCi, pFinger: huellaCI,);
    if(resul.verifyUserResult!.state==1) {
      AditionalItems addItems = resul.verifyUserResult!.object!.aditionalItems!
          .firstWhere((element) => element.key == "SavingAccounts");
      addItems.value=addItems.value?.replaceAll("\\", "");
      List<dynamic>  jsonResponse = json.decode(addItems.value!);
      final aux=jsonResponse
          .map((e) =>
          SavingAccounts.fromJson(e))
          .toList();
      vListaCuentaByCi=aux;
      tokkeSavinAcountTransfer=resul.verifyUserResult!.object!.token!;
    }
    if (vListaCuentaByCi.isEmpty) {
      resp = ResulProvider(
        message: "No tiene cuentas asociado al documento de identidad",
        state: RespProvider.incorrecto.toString(),
      );
    } else {
      resp = ResulProvider(
        message: "Registro recuperado satisfactoriamente",
        state: RespProvider.correcto.toString(),
        obj: vListaCuentaByCi,
      );
    }
  }

  getQRPago(double pMonto, String pGlosa) async {
    if (pMonto <= 0) {
      resp = ResulProvider(
        message: "El monto a pagar debe ser mayor 0",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }
    if (pGlosa.isEmpty) {
      resp = ResulProvider(
        message: "Glosa es un campo requerido",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }

    final resul = await SrvPay.getQrPay(pAmount: pMonto, pGlosa: pGlosa);
    if (resul.state == 1) {
      resp = ResulProvider(
        message: resul.message!,
        state: RespProvider.correcto.toString(),
        obj:resul.object?.qrValue,  //Uint8List(0)// generateQRCode(resul.object?.qrValue ?? '0'),
      );
      vMontoPagar = pMonto;
    } else {
      resp = ResulProvider(
        message: resul.message!,
        state: RespProvider.incorrecto.toString(),
        obj: Uint8List(0),
      );
    }
  }



/*eventos y metodos de card y finger*/

  getSavingAcountByCardFinger({required String pCard}) async{
    if (pCard.isEmpty) {
      resp = ResulProvider(
        message: "La Tarjeta es obligatorio",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }

    final resul=await SrvVerifyUser.ObtieneCuentaByTarjetaPan(pTarjetaPan: pCard, pFinger: huellaPan,);
    if(resul.verifyUserResult!.state==1) {
    AditionalItems addItems = resul.verifyUserResult!.object!.aditionalItems!
        .firstWhere((element) => element.key == "SavingAccounts");
    addItems.value=addItems.value?.replaceAll("\\", "");
    List<dynamic>  jsonResponse = json.decode(addItems.value!);
    final aux=jsonResponse
                    .map((e) =>
                    SavingAccounts.fromJson(e))
                    .toList();
    vListaCuentaByCi=aux;
     tokkeSavinAcountTransfer=resul.verifyUserResult!.object!.token!;
    }
    if (vListaCuentaByCi.isEmpty) {
      resp = ResulProvider(
        message: "No tiene cuentas: ${resul.verifyUserResult!.message!}",
        state: RespProvider.incorrecto.toString(),
      );
    } else {
      resp = ResulProvider(
        message: "Registro recuperado satisfactoriamente",
        state: RespProvider.correcto.toString(),
        obj: vListaCuentaByCi,
      );
    }

  }

  savingsAccountByCard(String pCard) async {
    await Future.delayed(const Duration(seconds: 5));
    final resul = await SrvPay.savingsAccountByCard(pCard);
    if (resul.getUserSessionInfoResult!.state == 1) {
      resp = ResulProvider(
        message: resul.getUserSessionInfoResult!.message!,
        state: RespProvider.correcto.toString(),
        obj: vLista,
      );
    } else {
      resp = ResulProvider(
        message: resul.getUserSessionInfoResult!.message!,
        state: RespProvider.incorrecto.toString(),
      );
    }
  }

  /* se usa saveCardFinger*/
  saveCardFinger({
    required String pOperationCodeCliente,
    required String pIdOperationEntity,
  }) async {
    List<String> vmessge = [];
    if (glosaWIdentityCard.isEmpty) {
      vmessge.add("Glosa.");
    }
    if (montoWIdentityCard <= 0) {
      vmessge.add("Monto a pagar.");
    }
    if (pOperationCodeCliente.isEmpty) {
      vmessge.add("Cuenta cliente.");
    }
    /*
    if (fingerWIdentityCard.isEmpty) {
      vmessge.add("Captura de huella.");
    }*/
    if (UtilPreferences.getAcount().isEmpty) {
      vmessge.add("Depósito a la cuenta.");
    }
    if (tokkeSavinAcountTransfer.isEmpty) {
      vmessge.add("tokken de autenticación es obligatorio.");
    }



    if (vmessge.isNotEmpty) {
      if (vmessge.length > 1) {
        vmessge.add("son campos requeridos.");
      } else {
        vmessge.add("es campo requerido.");
      }
      resp = ResulProvider(
        message:
            vmessge.join('\n'), // "Debe completar la siguiente informacion",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }

    final resul = await SrvPay.savingsTransferAccounts(pCodeSavingAccount: pOperationCodeCliente,
                                                      pIdMoneyTrans: "1",
                                                      pAmountTrans: montoWIdentityCard,
                                                      pCodeSavingAccountTarget: UtilPreferences.getAcount(),
                                                      pTokken: tokkeSavinAcountTransfer,
                                                      pBeneficiarioName:UtilPreferences.getClientePos(),
       pGlosa: glosaWIdentityCard
    );
    if (resul.savingsAccountTransferPOSResult!.state == 1) {
      resp = ResulProvider(
        message: "Registro guardado correctamente",
        state: RespProvider.correcto.toString(),
        obj: resul.savingsAccountTransferPOSResult!.object!
      );
    } else {
      resp = ResulProvider(
        message: resul.savingsAccountTransferPOSResult!.message!,
        state: RespProvider.incorrecto.toString(),
      );
    }
  }

  /* evento de registrar el proceso de pago caso WIDENTITYCAR*/
    String glosaWIdentityCard = '';
  String fingerWIdentityCard = '';
  double montoWIdentityCard = 0;

  getinitDocIdentidadPago() {
    //clearIdentityCard();
    vListaCuentaByCi = [];
    resp = ResulProvider(
      message: "Registro recuperado satisfactoriamente",
      state: RespProvider.correcto.toString(),
      obj: vListaCuentaByCi,
    );
  }

  clearIdentityCard() {
    glosaWIdentityCard = '';
    fingerWIdentityCard = '';
    montoWIdentityCard = 0;
    vListaCuentaByCi = [];
  }

  saveIdentityCard({
    required String pCi,
    required String pOperationCodeCliente,
    required String pIdOperationEntity,
  }) async {
    List<String> vmessge = [];
    if (glosaWIdentityCard.isEmpty) {
      vmessge.add("Glosa.");
    }
    if (montoWIdentityCard <= 0) {
      vmessge.add("Monto a pagar.");
    }
    if (pCi.isEmpty) {
      vmessge.add("Documento de identidad.");
    }
    if (pOperationCodeCliente.isEmpty) {
      vmessge.add("Cuenta cliente.");
    }
    /*if (fingerWIdentityCard.isEmpty) {
      vmessge.add("Captura de huella.");
    }*/
    if (UtilPreferences.getAcount().isEmpty) {
      vmessge.add("Depósito a la cuenta.");
    }
    if (vmessge.isNotEmpty) {
      if (vmessge.length > 1) {
        vmessge.add("son campos requeridos.");
      } else {
        vmessge.add("es campo requerido.");
      }
      resp = ResulProvider(
        message:
            vmessge.join('\n'), // "Debe completar la siguiente informacion",
        state: RespProvider.incorrecto.toString(),
      );
      return;
    }

    final resul = await SrvPay.savingsTransferAccounts(pCodeSavingAccount: pOperationCodeCliente,
        pIdMoneyTrans: "1",
        pAmountTrans: montoWIdentityCard,
        pCodeSavingAccountTarget: UtilPreferences.getAcount(),
        pTokken: tokkeSavinAcountTransfer,
        pBeneficiarioName:UtilPreferences.getClientePos(),
        pGlosa: glosaWIdentityCard
    );
    if (resul.savingsAccountTransferPOSResult!.state == 1) {
      resp = ResulProvider(
          message: "Registro guardado correctamente",
          state: RespProvider.correcto.toString(),
          obj: resul.savingsAccountTransferPOSResult!.object!
      );
    } else {
      resp = ResulProvider(
        message: resul.savingsAccountTransferPOSResult!.message!,
        state: RespProvider.incorrecto.toString(),
      );
    }
  }

  List<ListCodeSavingsAccount> vLista = [
    ListCodeSavingsAccount(
        availableAmount: 120000,
        codMoney: 'Sus',
        idMoney: 2,
        idOffice: 0,
        idOperationEntity: 1,
        operationCode: '117-2-2-04422-8'),
    ListCodeSavingsAccount(
        availableAmount: 100000,
        codMoney: 'Bs',
        idMoney: 1,
        idOffice: 0,
        idOperationEntity: 2,
        operationCode: '117-2-1-16869-8'),
    ListCodeSavingsAccount(
        availableAmount: 100000,
        codMoney: 'Bs',
        idMoney: 1,
        idOffice: 0,
        idOperationEntity: 2,
        operationCode: '117-2-1-16869-8'),
    ListCodeSavingsAccount(
        availableAmount: 1000,
        codMoney: 'Bs',
        idMoney: 1,
        idOffice: 0,
        idOperationEntity: 3,
        operationCode: '706-2-1-41944-7'),
    ListCodeSavingsAccount(
        availableAmount: 1200,
        codMoney: 'Sus',
        idMoney: 2,
        idOffice: 0,
        idOperationEntity: 3,
        operationCode: '706-2-2-14188-4'),
  ];

  final imgQR =
      "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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/kb8DwGa+rOnUOmwAAAAASUVORK5CYII=";

  final huellaPan="AAEAAAD/////AQAAAAAAAAAEAQAAAH9TeXN0ZW0uQ29sbGVjdGlvbnMuR2VuZXJpYy5MaXN0YDFbW1N5c3RlbS5TdHJpbmcsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OV1dAwAAAAZfaXRlbXMFX3NpemUIX3ZlcnNpb24GAAAICAkCAAAAAgAAAAIAAAARAgAAAAQAAAAGAwAAAKoEPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48RmlkPjxCeXRlcz5BT2hMQWNncDQzTmN3RUUzODFhSzY1WmNaMlljblhDc2tYWnk5bXdwbG5xc205aGZHU1BZWjJYUmhtUGRMdzlsbEhsZFZqZmhPc1BoZm1EdjM0QWs5eXZZQmRFcm85bjJabnl1eWpndTFSMkNpdlo2bklzbVU3VG9TVkRuZ3BuUFNZSGExU3Y5S3VnMmM2QUZJTlNtZGUzaHdhSVlYaUlHTGtkekdzNS9XVHE4Z0tFRlI5ZTFBUVRua0pFd3NDeVVCcDh5T0xKb1VVaW95QUx3T3V5d1pLU1FvMmdBOUZDM2k1WW9CcnNOV3FOaVJHQi9OdUdXVlp6NS83ZUNnTjM4dGZkdkdMNlEwOE9udWZEbXhoWG04M1d1TnBPUzBBVm1FMzNpbHcrd0JLK05Mb1FGbkhyVFBBSHNLZDNZdEJia2RLTkc3M0RJdVBtcDhFaXZMTmh3cUxmWHF5enM1U0tndG9WcFVSYXJXVUcxK0xsQ2dsbG9peXhNcUFlMFpCa1RndDg1b1NNU0swN1UvNnpndTlFdE15RkZ4N2ozUVdtVHcySXR2QnB1aUxGcEcyQ1pNVnhJVnFjRVlTZzN1VnB2PC9CeXRlcz48Rm9ybWF0PjI8L0Zvcm1hdD48VmVyc2lvbj4xLjAuMDwvVmVyc2lvbj48L0ZpZD4GBAAAALkFPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48RmlkPjxCeXRlcz5SazFTQUNBeU1BQUFBQUcyQUFBQk9nRmlBTVVBeFFFQUFBQldSRUR1QU4zVFlZQ0JBRy83WUlEZkFQL0hYNEE5QU55MVhVRFNBRlp5WFVCUUFKNFhYRUJmQUkrWFdFQkpBSytnV0lCREFQL0ZWNEQyQVZpNVYwRHZBUnJEVm9Db0FHbjFWVUN0QUlsNVU0REVBUEhEVTRDWUFUR2dVMEJOQVZSM1VvRFBBR2ZzVDREUUFKVGpUMENFQVBsRFRZRDhBUzg1VFlDSEFPakdUWUNsQUhSN1RFRFVBTXZUVEVBeUFTdlNUSUVLQVVJMVRFQXpBSzhhU1lDVkFUYVdTWURRQUtyaFNZRWZBUld6U1lCMUFWYUFTWUMyQUdoN1NFQnZBVGhwU0VFV0FUaTFSWUI3QU5DdFJZQzBBUktyUkVDakFVcVlSSUNOQVJxaFJJRUFBUDNNUTREOEFTVkhRa0VGQVJOUVFrRUZBUzB6UW9FTEFQL09RVUM0QVJDd1FVREVBSTdvUUVDM0FKcHdQa0JEQUpZU1BVQjdBUWpPTzRDSEFOek5PWUNIQUZCOE9JRVZBUTFZT0VFQUFSNVFOa0F0QVRySU5rRUlBVG93TmdDR0FPTExOUUF6QUxVZ05BRVBBVE16TXdFY0FVQTdNd0VWQVA1Wk13RUlBVFl5TWdFVkFSYzNNQUVYQVMwNE1BQWhBT0k1TUFBaUFOaXRMd0VnQVF6QUxRRFpBVml6TFFBaUFNcXJMUUM5QVZ5d0xRRWZBVFc1S3dBQTwvQnl0ZXM+PEZvcm1hdD4xNjg0Mjc1MzwvRm9ybWF0PjxWZXJzaW9uPjEuMC4wPC9WZXJzaW9uPjwvRmlkPg0CCw==";
final cardPan="7265210000050007";

final huellaCI="AAEAAAD/////AQAAAAAAAAAEAQAAAH9TeXN0ZW0uQ29sbGVjdGlvbnMuR2VuZXJpYy5MaXN0YDFbW1N5c3RlbS5TdHJpbmcsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OV1dAwAAAAZfaXRlbXMFX3NpemUIX3ZlcnNpb24GAAAICAkCAAAAAgAAAAIAAAARAgAAAAQAAAAGAwAAAJIDPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48RmlkPjxCeXRlcz5BT2pZQU1ncDQzTmN3RUUzODFhS3E1SmNaMmJQd0RqeVBpV2Q2M2tUa0ZxdXBOVWx4eWs0VHdqUU5jWi90QUhxZTg4K3BkTUNmclpKZjMxTyszUTJmS1VCT3dKQmJRd2Rzc2ZrWHBlTmNhY3VMSThnbElSMExZOVZpbG1GSlo3STJ4eGhSdExOMXdyWE1MelNncWFOdEZHbmt4NnVLTU85S1MvTmhabm1zOHNwb2kzZVJhM0JLa2FOUk84aGZkaGQ5dWRSVEtWMnV5UEYwcDhNSzNXVjNNWktia0lTUFZmTThuT21OZTQrUE9vUXhIR21lM2xmREZIU2VIU0lyTWtNckMvYnZQNGljT2p2eEFJUVV2MlZUVFRUeXJiWGQrdXJHc1pVbFc4PTwvQnl0ZXM+PEZvcm1hdD4yPC9Gb3JtYXQ+PFZlcnNpb24+MS4wLjA8L1ZlcnNpb24+PC9GaWQ+BgQAAACBAzw/eG1sIHZlcnNpb249IjEuMCIgZW5jb2Rpbmc9IlVURi04Ij8+PEZpZD48Qnl0ZXM+UmsxU0FDQXlNQUFBQUFETUFBQUJPZ0ZpQU1VQXhRRUFBQUJXSFlESEFSaFNYb0RiQVBkTlhvQnZBSVNWWFlCREFVOVlYSUM4QUw1WFc0RENBSnZUV2tEVUFITmdXVUJGQUtDaFdVQ2VBU2xRV0VDNEFGeHBWMERyQVBMT1ZrQmJBTXUxVllCbUFHT1FWSURlQVRoVlZJQ1RBSmFEVWtDUkFEenRUMER4QUlyVFQwQTRBUGZBVGtESkFHL2RUVURvQU1KUVRVRHZBUDFKVFlCR0FNZXlUSUR3QU1YVVMwQ05BTzdKU0lDS0FOWEtSSUNRQU1mVFBrQ0JBVnhnT2dDSEFNS3VNd0NOQU0vT01RQUE8L0J5dGVzPjxGb3JtYXQ+MTY4NDI3NTM8L0Zvcm1hdD48VmVyc2lvbj4xLjAuMDwvVmVyc2lvbj48L0ZpZD4NAgs=";
}
