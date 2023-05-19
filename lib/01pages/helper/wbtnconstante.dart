import 'package:flutter/material.dart';

import 'util_constante.dart';

class WBtnConstante extends StatelessWidget {
  const WBtnConstante({
    required this.pName,
    required this.fun,
    Key? key,
  }) : super(key: key);

  final String pName;
  final Function() fun;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: UtilConstante.btnColor,
        elevation: 5,
        onPressed: () {
          fun();
        },
        child: Text(
          pName,
          style: const TextStyle(color: Colors.white),
        ));
  }
}
