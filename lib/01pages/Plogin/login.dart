import 'package:flutter/material.dart';
import 'package:postjava/01pages/Plogin/login_provider.dart';
import 'package:postjava/01pages/helper/util_responsive.dart';
import 'package:provider/provider.dart';

import '../helper/util_constante.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  LoginProviders loginprov = LoginProviders();
  late UtilResponsive responsive;

  @override
  Widget build(BuildContext context) {
    loginprov = Provider.of<LoginProviders>(context);
    responsive = UtilResponsive.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Autenticación')),
      body: SingleChildScrollView(
        child: Container(
          height: responsive.vAlto - 100,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(UtilConstante.fondo), fit: BoxFit.cover),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: UtilConstante.bodyColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 25.0)
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Image.asset(
                        "assets/images/logosubsidio.png",
                        fit: BoxFit.fitWidth,
                        height: 100,
                        alignment: Alignment.topRight,
                      ),
                      txtUsuario(),
                      txtPass(),
                      UtilConstante.btnMaterial("Ingresar", () {
                        final vValida = _formKey.currentState!.validate();
                        if (vValida) {
                          getBeneficiarioCI();
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
