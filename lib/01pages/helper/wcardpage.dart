import 'package:flutter/material.dart';

class WCarPage extends StatelessWidget {
  final double pElevation;
  final Function() pFun;
  final String pName, pImg;
  const WCarPage(
      {required this.pElevation,
      required this.pFun,
      required this.pImg,
      required this.pName,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: pFun,
        child: ListTile(
          title: Text(
            pName,
            textAlign: TextAlign.center,
          ),
          subtitle: Image(
            image: AssetImage(pImg),
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
