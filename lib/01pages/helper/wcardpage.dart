import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/util_constante.dart';

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
      borderOnForeground: false,
      //color: UtilConstante.colorFondo,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: pFun,
        child: ListTile(
          title: Text(
            pName,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: UtilConstante.btnColor, fontWeight: FontWeight.bold),
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
