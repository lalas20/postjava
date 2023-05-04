import 'package:flutter/services.dart';
import 'package:postjava/02service/channel/plataformchannel.dart';

class FingerChannel extends ChannelMethod {
  static const starFinger = "starFinger";
  static const captureFingerISOname = "captureFingerISO";
  Stream<Uint8List> fingerStream = const Stream.empty();

  /*finger */
  static const eventChannelNameFinge = "com.prodem/emc";
  final EventChannel eventChannelFinger =
      const EventChannel(eventChannelNameFinge);

  FingerChannel(MethodChannel methodChannel) : super(methodChannel);

  Stream<Uint8List> capturFingerEvent() {
    fingerStream =
        eventChannelFinger.receiveBroadcastStream().map<Uint8List>((event) {
      print('event => $event');
      return event;
    });

    //final respuesta = fingerStream as Uint8List;

    //print(bytes);

    // ignore: avoid_print
    print({"fingerStream desde flutter:  $fingerStream"});
    return fingerStream;
  }

  Future<String?> captureFingerISO() async {
    try {
      final vRespuesta =
          await methodChannel.invokeMethod<String?>(captureFingerISOname);
      // ignore: avoid_print
      print({"exito  $vRespuesta"});
      return "exito: $vRespuesta";
    } catch (e) {
      // ignore: avoid_print
      print({"error  $e"});
    }
    return null;
  }

  Future<String?> inicilizaFinger() async {
    try {
      final vRespuesta = await methodChannel.invokeMethod<String?>(starFinger);
      // ignore: avoid_print
      print({"exito  $vRespuesta"});
      return vRespuesta;
    } catch (e) {
      // ignore: avoid_print
      print({"error  $e"});
    }
    return null;
  }
}
