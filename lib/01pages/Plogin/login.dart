// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:postjava/01pages/Plogin/login_provider.dart';
import 'package:postjava/01pages/helper/util_responsive.dart';
import 'package:postjava/01pages/helper/utilmodal.dart';
import 'package:postjava/01pages/helper/wbtnconstante.dart';
import 'package:postjava/helper/utilmethod.dart';
import 'package:provider/provider.dart';

import '../helper/util_constante.dart';
import '../homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static String route = '/Login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  LoginProviders provider = LoginProviders();
  final _usuariocontroller = TextEditingController(text: "perlita103");
  final _passcontroller = TextEditingController(text: "Pr0d3m123");
  late UtilResponsive responsive;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProviders>(context);
    responsive = UtilResponsive.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Autenticación')),
      body: SingleChildScrollView(
        child: Container(
          height: responsive.vAlto - 100,
          decoration: BoxDecoration(
            color: UtilConstante.colorFondo,
            // image: DecorationImage(
            //     image: AssetImage(UtilConstante.fondo), fit: BoxFit.cover),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: const BoxDecoration(
                  //color: UtilConstante.bodyColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  //boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 25.0)],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Image.asset(
                        UtilConstante.fondo,
                        fit: BoxFit.fitWidth,
                        height: 100,
                        alignment: Alignment.topRight,
                      ),
                      txtUsuario(),
                      txtPass(),
                      WBtnConstante(
                          pName: "Ingresar",
                          fun: () {
                            final vValida = _formKey.currentState!.validate();
                            if (vValida) {
                              _autentica();
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

  _autentica() async {
    UtilModal.mostrarDialogoSinCallback(context, "Procesando...");
    await provider.autentica(_usuariocontroller.text, _passcontroller.text);
    Navigator.of(context).pop();
    UtilMethod.imprimir(provider.resp.state);
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

  Widget txtPass() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: _passcontroller,
        onEditingComplete: () {
          _formKey.currentState!.validate();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingrese su contraseña';
          }
          return null;
        },
        decoration: UtilConstante.entrada(
            labelText: "Contraseña",
            icon: Icon(
              Icons.password_sharp,
              color: UtilConstante.btnColor,
            )),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget txtUsuario() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: _usuariocontroller,
        onEditingComplete: () {
          _formKey.currentState!.validate();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingrese su usuario';
          }
          if (value.length <= 5) {
            return 'Usuario no válido';
          }
          return null;
        },
        decoration: UtilConstante.entrada(
            labelText: "Usuario",
            icon: Icon(
              Icons.person_4_rounded,
              color: UtilConstante.btnColor,
            )),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
