// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:postjava/02service/channel/plataformchannel.dart';

class FingerChannel extends ChannelMethod {
  static const starFinger = "starFinger";
  static const captureFingerISOname = "captureFingerISO";
  Stream<Uint8List> fingerStream = const Stream.empty();

  late StreamSubscription fingerStreamSubcription;

  /*finger */
  static const eventChannelNameFinge = "com.prodem/emc";
  final EventChannel eventChannelFinger =
      const EventChannel(eventChannelNameFinge);

  FingerChannel(MethodChannel methodChannel) : super(methodChannel);

  Stream<Uint8List> capturFingerEvent() {
    //final aux = capturFingerEventSubcription();
    //print('event => $aux');

    fingerStream =
        eventChannelFinger.receiveBroadcastStream().map<Uint8List>((event) {
      print('event => $event');
      return event;
    });

    print({"fingerStream desde flutter:  $fingerStream"});
    return fingerStream;
  }

  StreamSubscription capturFingerEventSubcription() {
    fingerStreamSubcription =
        eventChannelFinger.receiveBroadcastStream().listen((event) {
      print('event => $event');
    });

    print({"fingerStreamSubcription desde flutter:  $fingerStreamSubcription"});
    return fingerStreamSubcription;
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
}
