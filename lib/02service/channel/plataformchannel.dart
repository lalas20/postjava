import 'package:flutter/services.dart';
import 'package:postjava/02service/channel/card_channel.dart';
import 'package:postjava/02service/channel/emv_channel.dart';
import 'package:postjava/02service/channel/fingerchannel.dart';
import 'package:postjava/03dominio/pos/resul_voucher.dart';

class PlaformChannel {
  static const methodChannelName = "com.prodem/mc";
  final MethodChannel methodChannel = const MethodChannel(methodChannelName);

  late TestMethod testMethod;
  late PrintMethod printMethod;
  late FingerChannel fingerChannel;
  late CardChannel cardChannel;
  late EmvChannel emvChannel;

  PlaformChannel() {
    testMethod = TestMethod(methodChannel);
    printMethod = PrintMethod(methodChannel);
    fingerChannel = FingerChannel(methodChannel);
    cardChannel = CardChannel(methodChannel);
    emvChannel = EmvChannel(methodChannel);
  }
}

class ChannelMethod {
  final MethodChannel methodChannel;
  ChannelMethod(this.methodChannel);
}

class PrintMethod extends ChannelMethod {
  static const printtext = "printtext";
  static const printtextMessage = "printMessage";
  static const printVoucher = "printVoucher";

  PrintMethod(MethodChannel methodChannel) : super(methodChannel);

  Future<String?> printTxt() async {
    try {
      final vRespuesta = await methodChannel.invokeMethod<String?>(printtext);
      // ignore: avoid_print
      print({"exito  $vRespuesta"});
      return vRespuesta;
    } catch (e) {
      // ignore: avoid_print
      print({"error  $e"});
    }
    return null;
  }

  Future<String?> printTxtMessage(String pTexto) async {
    try {
      final vRespuesta =
          await methodChannel.invokeMethod<String?>(printtextMessage, pTexto);
      // ignore: avoid_print
      print({"exito  $vRespuesta"});
      return vRespuesta;
    } catch (e) {
      // ignore: avoid_print
      print({"error  $e"});
    }
    return null;
  }

  Future<String?> printVoucherChannel(ResulVoucher resulVoucher) async {
    try {
      Map<String, dynamic> map = resulVoucher.toMap();
      final vRespuesta =
          await methodChannel.invokeMethod<String?>(printVoucher, map);
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
