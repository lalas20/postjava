// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:postjava/02service/channel/plataformchannel.dart';

class CardChannel extends ChannelMethod {
  static const researchICC = "researchICC";
  static const searchMagnetCardName = "searchMagnetCard";
  static const disposeCardIcName = "disposeCardIc";

  CardChannel(MethodChannel methodChannel) : super(methodChannel);

  static String eventChannelNameFinge = "com.prodem/emcC";
  static String methodChannelNameFinge = "com.prodem/mc";
  String vResult = '';

  final _channel = MethodChannel(methodChannelNameFinge);
  final _event = EventChannel(eventChannelNameFinge);
  get event => _event;

  Stream<String> cardIc = const Stream.empty();
  late StreamSubscription cardStreamSubcription;

  // Future<String> init() async {
  //   String rpt = '';
  //   try {
  //     final resul = await _channel.invokeMethod(starCard);
  //     print('resul:=> $resul');
  //     rpt = 'ingreso';
  //   } catch (e) {
  //     rpt = e.toString();
  //   }
  //   return rpt;
  // }

  Future<String> infosearchICC() async {
    String rpt = '';
    try {
      final resul = await _channel.invokeMethod(researchICC);
      print('infosearchICC:=> $resul');
      rpt = 'ingreso';
    } catch (e) {
      rpt = e.toString();
    }
    return rpt;
  }

  Future<String> searchMagnetCard() async {
    String rpt = '';
    try {
      final resul = await _channel.invokeMethod(searchMagnetCardName);
      print('searchMagnetCard:=> $resul');
      rpt = 'searchMagnetCard';
    } catch (e) {
      rpt = e.toString();
    }
    return rpt;
  }

  Stream<String> capturaCardIC() {
    final controller = StreamController<String>.broadcast();
    cardStreamSubcription = _event.receiveBroadcastStream().listen((event) {
      print("vResult::=> $event");
      controller.add(event);
    });
    if (vResult.isNotEmpty) {
      cardIc = controller.stream;
    } else {
      controller.add('sin huekla');
      cardIc = controller.stream;
    }
    return cardIc;
  }

  dispose() async {
    vResult = '';
    try {
      final vRespuesta =
          await _channel.invokeMethod<String?>(disposeCardIcName);
      print({"exito  captureFingerISO==>> $vRespuesta"});
      return "exito: $vRespuesta";
    } catch (e) {
      print({"error ==>> $e"});
    }
    cardStreamSubcription.cancel();
    return null;
  }
}
