import 'package:flutter/material.dart';

class WAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WAppBar({
    required this.pTitle,
    required this.pSubTitle,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  final String pTitle, pSubTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ListTile(
        title: RichText(
          text: TextSpan(
            text: pTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          textAlign: TextAlign.center,
        ),
        subtitle: RichText(
          text: TextSpan(
            text: 'Dispositivo: ',
            style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 12),
            children: <TextSpan>[
              TextSpan(
                  text: pSubTitle.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12)),
            ],
          ),
          textAlign: TextAlign.right,
        ),
        textColor: Colors.white,
      ),
      elevation: 10,
    );
  }
}
