import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/util_constante.dart';

class LoginAutentica extends StatefulWidget {
  const LoginAutentica({Key? key}) : super(key: key);
  static String route = '/LoginAutentica';

  @override
  State<LoginAutentica> createState() => _LoginAutenticaState();
}

class _LoginAutenticaState extends State<LoginAutentica> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UtilConstante.colorFondo,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(UtilConstante.iLogo),
                      fit: BoxFit.fill)),
              child: Container(
                padding: const EdgeInsets.only(top: 90, left: 20),
                color: const Color(0xFF3b5999).withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                      text: const TextSpan(
                          text: "Bienvenido a ",
                          style: TextStyle(
                              fontSize: 25,
                              letterSpacing: 2,
                              color: Colors.white),
                          children: [
                            TextSpan(
                              text: "PRODEM",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              height: 380,
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: UtilConstante.colorFondo,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ]),
              child: Column(
                children: [
                  const Text(
                    "Iniciar sesión",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    height: 2,
                    width: 100,
                    color: Colors.amber,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
