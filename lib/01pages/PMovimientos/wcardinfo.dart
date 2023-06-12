import 'package:flutter/material.dart';

import '../../03dominio/pos/resul_moves.dart';

class WCardInfo extends StatelessWidget {
  const WCardInfo({required this.resulMoves, super.key});
  final ResulMoves resulMoves;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text('leading ${resulMoves.agencia}'),
        subtitle: Text('subtitle ${resulMoves.fechaTransaccion}'),
        title: Text('title ${resulMoves.referencia}'),
        trailing: Text('trailing ${resulMoves.monto}'),
      ),
    );
  }
}
