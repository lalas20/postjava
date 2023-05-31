import 'package:flutter/material.dart';

class WPagoIdentityCard extends StatelessWidget {
  const WPagoIdentityCard({required this.txtCI, super.key});
  final TextFormField txtCI;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [txtCI],
      ),
    );
  }
}
