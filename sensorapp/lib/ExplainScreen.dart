import 'package:flutter/material.dart';
import 'InstructionsScreen.dart';

//Llamado de la primera pantalla
class ExplainPage extends StatefulWidget {
  @override
  _ExplainPage createState() => _ExplainPage();
}

//Constructor de explicacion de la aplicacion
class _ExplainPage extends State<ExplainPage> {
  Widget mainWidget = ExplainPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                "El propósito de esta aplicación es la recolección de datos del acelerómetro para poder realizar un estudio sobre métodos de autenticación basados en el comportamiento.\n\n Para la recolección de datos es necesario que se ingrese el mismo usuario al presionar ambos botones. A continuación podrá observar las instrucciones.\n\n Gracias por su participación.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstructionsPage(),
                  ),
                );
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
