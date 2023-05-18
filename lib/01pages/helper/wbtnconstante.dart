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
        child: const Text(
          pName,
          style: const TextStyle(color: Colors.white),
        ),
        color: UtilConstante.headerColor,
        elevation: 5,
        onPressed: () {
          fun();
        });
  }
}
