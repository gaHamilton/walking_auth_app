import 'package:flutter/material.dart';
import 'ExplainScreen.dart';
import 'RecolectionScreen.dart';

//Llamado de la segunda pantalla
class InstructionsPage extends StatefulWidget {
  @override
  _InstructionsPage createState() => _InstructionsPage();
}

//Constructor de instrucciones de la aplicacion
class _InstructionsPage extends State<InstructionsPage> {
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
                "Instrucciones:",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                "1. Ingrese un usuario\n\n 2. Presione 'Entrenar' una sola vez.\n\n 3. Camine hasta que el estado de envio sea 'Respuesta obtenida' o el botón vuelva a color azul. \n\n 4. Repita las mismas acciones con el botón 'Probar'.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecolectionPage(title: 'Recolección de Información'),
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
