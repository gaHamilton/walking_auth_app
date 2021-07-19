import 'package:flutter/material.dart';
import 'ExplainScreen.dart';

void main() {
  runApp(MyApp());
}

// Construccion de la aplicacion
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Recollection App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //Llamado a la primera pantalla
      home: ExplainPage(),
    );
  }
}
