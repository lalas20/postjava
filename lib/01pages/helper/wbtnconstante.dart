import 'package:flutter/material.dart';

import 'util_constante.dart';

class WBtnConstante extends StatelessWidget {
  const WBtnConstante({
    required this.pName,
    required this.fun,
    this.ico,
    Key? key,
  }) : super(key: key);

  final String pName;
  final Function() fun;
  final Icon? ico;

  @override
  Widget build(BuildContext context) {
    return ico == null
        ? MaterialButton(
            color: UtilConstante.btnColor,
            elevation: 5,
            onPressed: () {
              fun();
            },
            child: Text(
              pName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ))
        : IconButton(
            onPressed: () {
              fun();
            },
            icon: ico!);
  }
}
