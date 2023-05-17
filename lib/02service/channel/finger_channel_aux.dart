// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:postjava/02service/channel/plataformchannel.dart';
import 'package:postjava/02service/service/User/srv_verify_user.dart';
import 'package:postjava/03dominio/user/aditional_item.dart';
import 'package:postjava/03dominio/user/credential.dart';
import 'package:postjava/03dominio/user/credential_verify_user.dart';
import 'package:postjava/03dominio/user/result.dart';

class FingerChannelAux extends ChannelMethod {
  static const starFinger = "starFinger";
  static const captureFingerISOname = "captureFingerISO";

  Stream<String> vHuellares = const Stream.empty();
  String vResult = '';
  late StreamSubscription fingerStreamSubcription;

  /*finger */
  static const eventChannelNameFinge = "com.prodem/emcF";
  final EventChannel eventChannelFinger =
      const EventChannel(eventChannelNameFinge);

  FingerChannelAux(MethodChannel methodChannel) : super(methodChannel);

  String convertBytesToHex(Uint8List bytes) {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < bytes.length;) {
      int firstWord = (bytes[i] << 8) + bytes[i + 1];
      if (0xD800 <= firstWord && firstWord <= 0xDBFF) {
        int secondWord = (bytes[i + 2] << 8) + bytes[i + 3];
        buffer.writeCharCode(
            ((firstWord - 0xD800) << 10) + (secondWord - 0xDC00) + 0x10000);
        i += 4;
      } else {
        buffer.writeCharCode(firstWord);
        i += 2;
      }
    }

    return buffer.toString();
  }

  Stream<String> capturFingerEvent() {
    final controller = StreamController<String>.broadcast();

    fingerStreamSubcription =
        eventChannelFinger.receiveBroadcastStream().listen((event) {
      Uint8List original = Uint8List.fromList(event);
      vResult = base64.encode(original);
      print("vResult::=> $vResult");
      controller.add(vResult);
      // ignore: void_checks
      // return event;
    });
    if (vResult.isNotEmpty) {
      vHuellares = controller.stream;
    }

    return vHuellares;
  }

  dispose() {
    vResult = '';
    fingerStreamSubcription.cancel();
  }

  Future<String?> captureFingerISO() async {
    try {
      final vRespuesta =
          await methodChannel.invokeMethod<String?>(captureFingerISOname);

      print({"exito  $vRespuesta"});
      return "exito: $vRespuesta";
    } catch (e) {
      print({"error  $e"});
    }
    return null;
  }

  Future<String?> inicilizaFinger() async {
    try {
      final vRespuesta = await methodChannel.invokeMethod<String?>(starFinger);

      print({"exito  $vRespuesta"});
      return vRespuesta;
    } catch (e) {
      print({"error  $e"});
    }
    return null;
  }

  Future<Result> verifyUser(String pFinger) async {
    List<AditionalItems> vListaItem = [
      AditionalItems(groupName: '', key: 'IdATM', value: '1'),
      AditionalItems(
          groupName: '', key: 'TypeAuthentication', value: 'IdentityCard')
    ];
    final pCredential = Credential(
        user: '5961581LP',
        password: pFinger,
        channel: 3,
        aditionalItems: vListaItem);
    final pCredentialVerifyUser = CredentialVerifyUser(credential: pCredential);

    final resul = await SrvVerifyUser.verifyUser(pCredentialVerifyUser);
    print({"resul  $resul"});
    return resul;
  }

  final String huella =
      'AAEAAAD/////AQAAAAAAAAAEAQAAAH9TeXN0ZW0uQ29sbGVjdGlvbnMuR2VuZXJpYy5MaXN0YDFbW1N5c3RlbS5TdHJpbmcsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OV1dAwAAAAZfaXRlbXMFX3NpemUIX3ZlcnNpb24GAAAICAkCAAAAAgAAAAIAAAARAgAAAAQAAAAGAwAAAJIDPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48RmlkPjxCeXRlcz5BT2pZQU1ncDQzTmN3RUUzODFhS3E1SmNaMmJQd0RqeVBpV2Q2M2tUa0ZxdXBOVWx4eWs0VHdqUU5jWi90QUhxZTg4K3BkTUNmclpKZjMxTyszUTJmS1VCT3dKQmJRd2Rzc2ZrWHBlTmNhY3VMSThnbElSMExZOVZpbG1GSlo3STJ4eGhSdExOMXdyWE1MelNncWFOdEZHbmt4NnVLTU85S1MvTmhabm1zOHNwb2kzZVJhM0JLa2FOUk84aGZkaGQ5dWRSVEtWMnV5UEYwcDhNSzNXVjNNWktia0lTUFZmTThuT21OZTQrUE9vUXhIR21lM2xmREZIU2VIU0lyTWtNckMvYnZQNGljT2p2eEFJUVV2MlZUVFRUeXJiWGQrdXJHc1pVbFc4PTwvQnl0ZXM+PEZvcm1hdD4yPC9Gb3JtYXQ+PFZlcnNpb24+MS4wLjA8L1ZlcnNpb24+PC9GaWQ+BgQAAACBAzw/eG1sIHZlcnNpb249IjEuMCIgZW5jb2Rpbmc9IlVURi04Ij8+PEZpZD48Qnl0ZXM+UmsxU0FDQXlNQUFBQUFETUFBQUJPZ0ZpQU1VQXhRRUFBQUJXSFlESEFSaFNYb0RiQVBkTlhvQnZBSVNWWFlCREFVOVlYSUM4QUw1WFc0RENBSnZUV2tEVUFITmdXVUJGQUtDaFdVQ2VBU2xRV0VDNEFGeHBWMERyQVBMT1ZrQmJBTXUxVllCbUFHT1FWSURlQVRoVlZJQ1RBSmFEVWtDUkFEenRUMER4QUlyVFQwQTRBUGZBVGtESkFHL2RUVURvQU1KUVRVRHZBUDFKVFlCR0FNZXlUSUR3QU1YVVMwQ05BTzdKU0lDS0FOWEtSSUNRQU1mVFBrQ0JBVnhnT2dDSEFNS3VNd0NOQU0vT01RQUE8L0J5dGVzPjxGb3JtYXQ+MTY4NDI3NTM8L0Zvcm1hdD48VmVyc2lvbj4xLjAuMDwvVmVyc2lvbj48L0ZpZD4NAgs=';
}
