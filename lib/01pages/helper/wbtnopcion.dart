import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WBtnOpcion extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  WBtnOpcion({required this.fun, required this.heigth, required this.name});
  Function() fun;
  String name;
  double heigth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heigth,
      child: ElevatedButton(onPressed: () => fun, child: Text(name)),
    );
  }
}
