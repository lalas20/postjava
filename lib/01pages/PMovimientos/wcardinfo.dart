import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:postjava/01pages/helper/util_responsive.dart';
import 'package:postjava/01pages/helper/wrow_opcion.dart';

import '../../03dominio/pos/resul_moves.dart';

class WCardInfo extends StatelessWidget {
  const WCardInfo({required this.resulMoves, super.key});
  final ResulMoves resulMoves;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        //leading: Text('${resulMoves.nroTransaccion}'),
        title: Text(
          ' ${resulMoves.fechaTransaccion}',
          style: TextStyle(
              color: UtilConstante.btnColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          ' ${resulMoves.referencia}',
          style: TextStyle(color: UtilConstante.btnColor),
        ),
        trailing: Text(' ${resulMoves.monto}',
            style: TextStyle(
                color: UtilConstante.btnColor,
                fontWeight: FontWeight.w400,
                fontSize: 20)),
        onTap: () {
          print(resulMoves.nroTransaccion);
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        },
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    final responsive = UtilResponsive.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      height: responsive.altoPorcentaje(50),
      width: responsive.anchoPorcentaje(70),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            width: responsive.anchoPorcentaje(100),
            color: Colors.white,
            child: Text(
              "Detalle de Movimiento",
              style: TextStyle(
                  color: UtilConstante.btnColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              children: [
                WRowOpcion(
                  label: "Fecha/Hora:",
                  value: " ${resulMoves.fechaTransaccion}",
                ),
                WRowOpcion(
                  label: "Nro. Transacción:",
                  value: " ${resulMoves.nroTransaccion}",
                ),
                WRowOpcion(
                  label: "Agencia:",
                  value: " ${resulMoves.agencia}",
                ),
                WRowOpcion(
                  label: "Referencia:",
                  value: " ${resulMoves.referencia}",
                ),
                WRowOpcion(
                  label: "Monto:",
                  value: " ${resulMoves.monto}",
                ),
                WRowOpcion(
                  label: "Saldo:",
                  value: " ${resulMoves.saldo}",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
