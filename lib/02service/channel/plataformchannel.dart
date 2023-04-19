import 'package:flutter/services.dart';

class PlaformChannel {
  static const methodChannelName = "com.prodem/mc";
  final MethodChannel methodChannel = const MethodChannel(methodChannelName);

  late TestMethod testMethod;
  PlaformChannel() {
    testMethod = TestMethod(methodChannel);
  }
}

class ChannelMethod {
  final MethodChannel methodChannel;
  ChannelMethod(this.methodChannel);
}

class TestMethod extends ChannelMethod {
  static const horaVersion = "horaversion";

  TestMethod(MethodChannel methodChannel) : super(methodChannel);

  Future<String?> horaVersionChannel() async {
    try {
      final vRespuesta = await methodChannel.invokeMethod<String?>(horaVersion);
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
