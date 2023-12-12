import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/util_constante.dart';

class WRowOpcion extends StatelessWidget {
  const WRowOpcion({required this.label, required this.value, super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: UtilConstante.btnColor),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              value,
              style: TextStyle(color: UtilConstante.btnColor),
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
