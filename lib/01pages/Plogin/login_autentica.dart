// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:postjava/01pages/helper/util_constante.dart';
import 'package:provider/provider.dart';

import '../helper/utilmodal.dart';
import '../PHome/homepage.dart';
import 'login_provider.dart';

class LoginAutentica extends StatefulWidget {
  const LoginAutentica({Key? key}) : super(key: key);
  static String route = '/LoginAutentica';

  @override
  State<LoginAutentica> createState() => _LoginAutenticaState();
}

class _LoginAutenticaState extends State<LoginAutentica> {
  LoginProviders provider = LoginProviders();
  TextEditingController txtuser = TextEditingController(text: "personal123");
  TextEditingController txtpass = TextEditingController(text: "Pr0d3m123");

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProviders>(context);

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
                      scale: 0.9,
                      image: AssetImage(UtilConstante.iLogo),
                      fit: BoxFit.scaleDown,
                      repeat: ImageRepeat.repeat)),
              child: Container(
                padding: const EdgeInsets.only(top: 90, left: 20),
                color: UtilConstante.colorBanner.withOpacity(.85),
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
          buildBottonHalfContainer(true),
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      children: [
                        builTexField(
                            Icons.person, "Usuario", false, false, txtuser),
                        builTexField(
                            Icons.password, "Contraseña", true, false, txtpass),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          buildBottonHalfContainer(false),
        ],
      ),
    );
  }

  Future<void> _autentica() async {
    UtilModal.mostrarDialogoSinCallback(context, "Procesando...");
    await provider.autentica(txtuser.text, txtpass.text);
    Navigator.of(context).pop();

    if (provider.resp.state == RespProvider.correcto.toString()) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.route, (Route<dynamic> route) => false);
    } else {
      UtilModal.mostrarDialogoNativo(
          context,
          "Atención",
          Text(
            provider.resp.message,
            style: TextStyle(color: UtilConstante.btnColor),
          ),
          "Aceptar",
          () {});
    }
  }

  Positioned buildBottonHalfContainer(bool showShadow) {
    return Positioned(
      top: 480,
      right: 0,
      left: 0,
      child: GestureDetector(
        onTap: () => _autentica(),
        child: Center(
          child: Container(
            height: 95,
            width: 95,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: UtilConstante.colorFondo,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  if (showShadow)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1.5,
                      blurRadius: 10,
                    )
                ]),
            child: !showShadow
                ? Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Colors.greenAccent, Colors.blueGrey],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1))
                        ]),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.amber,
                    ),
                  )
                : const Center(),
          ),
        ),
      ),
    );
  }

  Widget builTexField(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController pController) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: pController,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: UtilConstante.btnColor,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: UtilConstante.colorAppPrimario),
                borderRadius: const BorderRadius.all(Radius.circular(35.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: UtilConstante.colorAppPrimario),
                borderRadius: const BorderRadius.all(Radius.circular(35.0))),
            contentPadding: const EdgeInsets.all(10),
            hintText: hintText,
            hintStyle:
                TextStyle(fontSize: 14, color: UtilConstante.colorAppPrimario)),
      ),
    );
  }
}
