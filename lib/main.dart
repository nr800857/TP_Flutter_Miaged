import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'login.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async => {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      runApp(MyApp())
    };

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => const LoginPage(),
    HomePage.tag: (context) => const HomePage(),
  };

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    if(globals.isLoggedIn) {
      return MaterialApp(
        title: 'MIAGED',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          fontFamily: 'Nunito',
        ),
        home: const HomePage(),
        routes: routes,
      );
    }
    else {
      return MaterialApp(
      title: 'MIAGED',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: const LoginPage(),
      routes: routes,
    );
    }

    
  }
}
