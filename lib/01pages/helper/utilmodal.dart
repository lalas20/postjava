import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'util_constante.dart';

enum ActionStyle { normal, destructive, important, importantDestructive }

class UtilModal {
  static const Color _normal = Colors.white;
  static const Color _destructive = Colors.amber;

  static Future mostrarDialogoNativo(BuildContext context, String title,
      Widget message, String firstButtonText, Function firstCallBack,
      {ActionStyle firstActionStyle = ActionStyle.normal,
      String? secondButtonText,
      Function? secondCallback,
      ActionStyle secondActionStyle = ActionStyle.normal}) {
    return showDialog(
      barrierColor:
          const Color.fromRGBO(0, 0, 0, 0.5), // UtilConstante.bodyColor,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return _iosDialog(
              context, title, message, firstButtonText, firstCallBack,
              firstActionStyle: firstActionStyle,
              secondButtonText: secondButtonText,
              secondCallback: secondCallback,
              secondActionStyle: secondActionStyle);
        } else {
          return _androidDialog(
              context, title, message, firstButtonText, firstCallBack,
              firstActionStyle: firstActionStyle,
              secondButtonText: secondButtonText,
              secondCallback: secondCallback,
              secondActionStyle: secondActionStyle);
        }
      },
    );
  }

  static Future mostrarDialogoSinCallback(BuildContext context, String title) {
    return showDialog(
      barrierColor: UtilConstante.colorAppPrimario,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          backgroundColor: Colors.white, //bodyColor,
          title: Text(
            title,
            style: TextStyle(
                color: UtilConstante.btnColor,
                fontSize: 14,
                fontFamily: 'Poppins',
                decoration: TextDecoration.none),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 10.0,
                backgroundColor: UtilConstante.headerColor,
                color: UtilConstante.btnColor,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Dialogo en Android
  static Widget _androidDialog(BuildContext context, String title,
      Widget message, String firstButtonText, Function firstCallBack,
      {ActionStyle firstActionStyle = ActionStyle.normal,
      String? secondButtonText,
      Function? secondCallback,
      ActionStyle secondActionStyle = ActionStyle.normal}) {
    List<Widget> actions = [];
    actions.add(Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: UtilConstante.headerColor,
      ),
      child: TextButton(
        child: Text(
          firstButtonText,
          style: TextStyle(
              color: (firstActionStyle == ActionStyle.importantDestructive ||
                      firstActionStyle == ActionStyle.destructive)
                  ? _destructive
                  : _normal,
              fontWeight:
                  (firstActionStyle == ActionStyle.importantDestructive ||
                          firstActionStyle == ActionStyle.important)
                      ? FontWeight.bold
                      : FontWeight.normal),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          firstCallBack();
        },
      ),
    ));

    if (secondButtonText != null) {
      actions.add(Container(
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: UtilConstante.btnColorSec,
        ),
        // padding:
        //     const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: TextButton(
          child: Text(secondButtonText,
              style: TextStyle(
                  color:
                      (secondActionStyle == ActionStyle.importantDestructive ||
                              firstActionStyle == ActionStyle.destructive)
                          ? _destructive
                          : _normal)),
          onPressed: () {
            Navigator.of(context).pop();
            secondCallback!();
          },
        ),
      ));
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        firstCallBack();
        return true;
      },
      child: AlertDialog(
        title: Text(
          title,
          style: TextStyle(
              color: UtilConstante.headerColor,
              fontSize: 14,
              fontFamily: 'Poppins',
              decoration: TextDecoration.none),
          textAlign: TextAlign.center,
        ),
        content: message,
        actions: actions,
        backgroundColor: Colors.white, // UtilConstante.bodyColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        scrollable: true,
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

//dialogo para io
  static Widget _iosDialog(BuildContext context, String title, Widget message,
      String firstButtonText, Function firstCallback,
      {ActionStyle firstActionStyle = ActionStyle.normal,
      String? secondButtonText,
      Function? secondCallback,
      ActionStyle secondActionStyle = ActionStyle.normal}) {
    List<CupertinoDialogAction> actions = [];
    actions.add(
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.of(context).pop();
          firstCallback();
        },
        child: Text(
          firstButtonText,
          style: TextStyle(
              color: (firstActionStyle == ActionStyle.importantDestructive ||
                      firstActionStyle == ActionStyle.destructive)
                  ? _destructive
                  : _normal,
              fontWeight:
                  (firstActionStyle == ActionStyle.importantDestructive ||
                          firstActionStyle == ActionStyle.important)
                      ? FontWeight.bold
                      : FontWeight.normal),
        ),
      ),
    );

    if (secondButtonText != null) {
      actions.add(
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            secondCallback!();
          },
          child: Text(
            secondButtonText,
            style: TextStyle(
                color: (secondActionStyle == ActionStyle.importantDestructive ||
                        secondActionStyle == ActionStyle.destructive)
                    ? _destructive
                    : _normal,
                fontWeight:
                    (secondActionStyle == ActionStyle.importantDestructive ||
                            secondActionStyle == ActionStyle.important)
                        ? FontWeight.bold
                        : FontWeight.normal),
          ),
        ),
      );
    }

    return CupertinoAlertDialog(
      title: Text(title),
      content: message,
      actions: actions,
    );
  }

  static Widget iniCircularProgres() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 10.0,
            backgroundColor: UtilConstante.headerColor,
            color: UtilConstante.colorAppPrimario,
          ),
          Text(
            "Cargando...",
            style: TextStyle(
                color: UtilConstante.colorAppPrimario,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  static Widget iniSinRegistro() {
    return Container(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          children: [
            Text(
              "Sin Registros",
              style: TextStyle(
                  color: UtilConstante.colorAppPrimario,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
