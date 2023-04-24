import 'package:flutter/services.dart';
import 'package:postjava/02service/channel/plataformchannel.dart';

class FingerChannel extends ChannelMethod {
  static const starFinger = "starFinger";
  Stream<String> fingerStream = const Stream.empty();

  /*finger */
  static const eventChannelNameFinge = "com.prodem/emc";
  final EventChannel eventChannelFinger =
      const EventChannel(eventChannelNameFinge);

  FingerChannel(MethodChannel methodChannel) : super(methodChannel);

  Stream<String> capturFinger() {
    fingerStream = eventChannelFinger
        .receiveBroadcastStream()
        .map<String>((event) => event);

    // ignore: avoid_print
    print({"fingerStream:  $fingerStream"});
    return fingerStream;
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
