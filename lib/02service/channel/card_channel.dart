// ignore_for_file: avoid_print

import 'package:flutter/services.dart';

class CardChannel {
  static const starCard = "starCard";
  static const researchICC = "researchICC";

  CardChannel._internal();
  static final CardChannel _instance = CardChannel._internal();
  static CardChannel get instance => _instance;

  static String eventChannelNameFinge = "com.prodem/mc";
  static String methodChannelNameFinge = "com.prodem/mc";

  final _channel = MethodChannel(methodChannelNameFinge);
  final _event = EventChannel(eventChannelNameFinge);

  Future<String> init() async {
    String rpt = '';
    try {
      final resul = await _channel.invokeMethod(starCard);
      print('resul:=> $resul');
      rpt = 'ingreso';
    } catch (e) {
      rpt = e.toString();
    }
    return rpt;
  }

  Future<String> infosearchICC() async {
    String rpt = '';
    try {
      final resul = await _channel.invokeMethod(researchICC);
      print('resul:=> $resul');
      rpt = 'ingreso';
    } catch (e) {
      rpt = e.toString();
    }
    return rpt;
  }
}
