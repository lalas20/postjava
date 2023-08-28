import 'dart:async';

import 'package:flutter/services.dart';
import 'package:postjava/02service/channel/plataformchannel.dart';
import 'package:postjava/helper/utilmethod.dart';

class EmvChannel extends ChannelMethod {
  static const searchEMV = "searchEMV";
  static const disposeEMVName = "disposeEMV";

  EmvChannel(super.methodChannel);

  static String eventChannelNameEmv = "com.prodem/emcEmv";
  static String methodChannelNameEmv = "com.prodem/mc";

  String vResul = '';
  final _channel = MethodChannel(methodChannelNameEmv);
  final _event = EventChannel(eventChannelNameEmv);
  get event => _event;

  Stream<String> emvIc = const Stream.empty();
  late StreamSubscription emvStreamSubscription;

  Future<String> emvSearch() async {
    String rpt = '';
    try {
    rpt=  await _channel.invokeMethod(searchEMV);
      UtilMethod.imprimir('emvSearch: $rpt');
    } catch (e) {
      rpt = e.toString();
    }
    return rpt;
  }

  dispose() async {
    vResul = '';
    try {
      final vRespuesta = await _channel.invokeMethod<String?>(disposeEMVName);
      return "exito: $vRespuesta";
      // ignore: empty_catches
    } catch (e) {}
    emvStreamSubscription.cancel();
    return null;
  }
}
