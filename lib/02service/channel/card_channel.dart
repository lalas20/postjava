import 'package:flutter/services.dart';

class CardChannel {
  static const starCard = "starCard";
  static const captureFingerISOname = "captureFingerISO";
  CardChannel._internal();
  static final CardChannel _instance = CardChannel._internal();
  static CardChannel get instance => _instance;

  static String eventChannelNameFinge = "com.prodem/emc-card";
  static String methodChannelNameFinge = "com.prodem/mc-card";

  final _channel = MethodChannel(methodChannelNameFinge);
  final _event = EventChannel(eventChannelNameFinge);
}
