import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:postjava/01pages/PConfiguration/configuration_provider.dart';
import 'package:postjava/01pages/PMovimientos/last_moves_provider.dart';
import 'package:postjava/01pages/PPago/pago_provider.dart';
import 'package:postjava/01pages/PPago/pago_view.dart';
import 'package:postjava/01pages/Plogin/login.dart';

import 'package:postjava/01pages/Plogin/login_provider.dart';
import 'package:provider/provider.dart';

import '01pages/PConfiguration/configuration_view.dart';
import '01pages/PMovimientos/last _moves_page.dart';
import '01pages/Plogin/login_autentica.dart';
import '01pages/emv_page.dart';
import '01pages/helper/util_constante.dart';
import '01pages/homepage.dart';
import 'helper/util_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UtilPreferences.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginProviders()),
      ChangeNotifierProvider(create: (_) => ConfigurationProvider()),
      ChangeNotifierProvider(create: (_) => PagoProvider()),
      ChangeNotifierProvider(create: (_) => LastMovesProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PRODEM POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      home: AnimatedSplashScreen(
        splash: Image.asset(UtilConstante.iprdBlue),
        nextScreen: const LoginAutentica(),
        // UtilPreferences.getToken() == ''
        //    ? const LoginAutentica()
        //    : const HomePage(), //const LoginAutentica(),
        splashTransition: SplashTransition.fadeTransition,
        duration: 1500,
        splashIconSize: 500,
        animationDuration: const Duration(seconds: 2),
        backgroundColor: UtilConstante.btnColor,
        pageTransitionType: PageTransitionType.fade,
      ),
      //initialRoute: LoginAutentica.route,
      //Login.route,
      //UtilPreferences.getToken() == '' ? Login.route : HomePage.route,
      routes: {
        LoginAutentica.route: (BuildContext context) => const LoginAutentica(),
        Login.route: (BuildContext context) => const Login(),
        HomePage.route: (BuildContext context) => const HomePage(),
        EmvPage.route: (BuildContext context) => const EmvPage(),
        PagoView.route: (BuildContext context) => const PagoView(),
        ConfigurationView.route: (BuildContext context) =>
        const ConfigurationView(),
        LastMoves.route: (BuildContext context) => const LastMoves(),
      },
    );
  }
}