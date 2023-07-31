import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';

class UtilMethod {
  static void imprimir(String pMessage) {
    //if (UtilConstante.ambiente != Ambiente.ePREPROD) {
    String? vtrace = Trace.current().frames[1].member;
    debugPrint(vtrace == null ? 'error: ->$pMessage' : '$vtrace->$pMessage');
    //}
  }
  static DateTime parseJsonDate(String jsonDate) {
    // Obtener el valor numérico entre los paréntesis del formato "/Date(...)/"
    int timestamp = int.parse(jsonDate.substring(6, jsonDate.length - 7));

    // Crear un objeto DateTime usando el timestamp en milisegundos
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static String formatteDate(DateTime pFecha) {
    return '${pFecha.year}-${_twoDigits(pFecha.month)}-${_twoDigits(pFecha.day)} ${_twoDigits(pFecha.hour)}:${_twoDigits(pFecha.minute)}:${_twoDigits(pFecha.second)}';
  }

  static String formatteOnlyDate(DateTime pFecha) {
    return '${_twoDigits(pFecha.day)}/${_twoDigits(pFecha.month)}/${pFecha.year}';
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
