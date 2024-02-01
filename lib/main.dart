import 'package:flutter/material.dart';
import 'package:gestionfilms/widgets/accueil.dart';
import 'package:gestionfilms/widgets/filmform.dart';
import 'package:gestionfilms/widgets/login.dart';
import 'package:gestionfilms/widgets/movie.dart';
import 'package:gestionfilms/widgets/register.dart';
import 'package:gestionfilms/widgets/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => welcome(),
        '/login': (context) => LoginPage(),
        '/accueil': (context) => accueil(),
        '/register': (context) => RegisterPage(),
        '/ajoutFilm': (context) => FilmForm(),
        '/listefilm': (context) => FilmList()
      },
    );
  }
}
