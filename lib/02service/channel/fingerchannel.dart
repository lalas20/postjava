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

class FingerChannel extends ChannelMethod {
  static const starFinger = "starFinger";
  static const captureFingerISOname = "captureFingerISO";
  static const disposeFinger = "disposeFinger";

  Stream<String> vHuellares = const Stream.empty();
  late StreamSubscription fingerStreamSubcription;
  String vResult = '';

  /*finger */
  static String eventChannelNameFinge = "com.prodem/emcF";

  final _event = EventChannel(eventChannelNameFinge);
  get event => _event;

  FingerChannel(MethodChannel methodChannel) : super(methodChannel);

  Stream<String> capturFingerEvent() {
    final controller = StreamController<String>.broadcast();

    fingerStreamSubcription = _event.receiveBroadcastStream().listen((event) {
      Uint8List original = Uint8List.fromList(event);
      vResult = base64.encode(original);
      print("vResult::=> $vResult");
      controller.add(vResult);
    });
    if (vResult.isNotEmpty) {
      vHuellares = controller.stream;
    } else {
      controller.add('sin huekla');
      vHuellares = controller.stream;
    }

    return vHuellares;
  }

  dispose() async {
    vResult = '';
    try {
      final vRespuesta =
          await methodChannel.invokeMethod<String?>(disposeFinger);

      print({"exito  captureFingerISO==>> $vRespuesta"});
      return "exito: $vRespuesta";
    } catch (e) {
      print({"error ==>> $e"});
    }

    fingerStreamSubcription.cancel();
    return null;
  }

  Future<String?> captureFingerISO() async {
    try {
      final vRespuesta =
          await methodChannel.invokeMethod<String?>(captureFingerISOname);

      print({"exito  captureFingerISO==>> $vRespuesta"});
      return "exito: $vRespuesta";
    } catch (e) {
      print({"error ==>> $e"});
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
