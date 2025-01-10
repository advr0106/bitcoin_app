import 'package:bitcoin_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(ConversorCriptoMonedas());

class ConversorCriptoMonedas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue
        )
      ),
      home: HomeScreen(),
    );
  }
}
