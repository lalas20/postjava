import 'package:flutter/material.dart';

class WCarPage extends StatelessWidget {
  double elevation;
  Function() fun;
  String name;
  String img;
  WCarPage(this.elevation, this.fun, this.img, this.name);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          fun;
        },
        child: ListTile(
          title: Text(
            name,
            textAlign: TextAlign.center,
          ),
          subtitle: Image(
            image: AssetImage(img),
          ),
        ),
      ),
    );
  }
}
