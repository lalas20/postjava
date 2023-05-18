import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';

class UtilMethod {
  static void imprimir(String pMessage) {
    //if (UtilConstante.ambiente != Ambiente.ePREPROD) {
    String? vtrace = Trace.current().frames[1].member;
    debugPrint(vtrace == null ? 'error: ->$pMessage' : '$vtrace->$pMessage');
    //}
  }
}
