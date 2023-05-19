import 'package:flutter/material.dart';
import 'package:postjava/01pages/Plogin/login.dart';

import 'package:postjava/01pages/Plogin/login_provider.dart';
import 'package:provider/provider.dart';

import '01pages/homepage.dart';
import 'helper/util_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UtilPreferences.init();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => LoginProviders())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PRODEM TEST POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute:
            UtilPreferences.getToken() == '' ? Login.route : HomePage.route,
        //home: const HomePage() //const MyHomePage(title: 'Pruebas de POS'),
        routes: {
          Login.route: (BuildContext context) => const Login(),
          HomePage.route: (BuildContext context) => const HomePage(),
        });
  }
}
