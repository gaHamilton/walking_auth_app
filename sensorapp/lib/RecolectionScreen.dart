import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sensorapp/Object.dart';
import 'package:sensors/sensors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//Llamado de la tercera pantalla
class RecolectionPage extends StatefulWidget {
  RecolectionPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _RecolectionPage createState() => _RecolectionPage();
}

//Pagina de recoleccion de datos
class _RecolectionPage extends State<RecolectionPage> {
  String _result = "Sin Enviar";
  final _user = TextEditingController();
  bool _validate = false;
  String _realLabel = "Real";
  String _questionLabel = "?";
  bool _entrenar = false;
  bool _probar = false;

  //Construccion de la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                "Al Ingresar el usuario, usar el mismo identificador al presionar los dos botones",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 150,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _user,
                autocorrect: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Usuario',
                  errorText: _validate ? 'Ingrese un Valor' : null,
                ),
              ),
            ),
            ElevatedButton(
              //Al presionar el boton, si no fue presioando anteriormente, llamar al metodo para verificar la conexion a internet
              onPressed: _entrenar ? null : () => getConn(context, _realLabel),
              child: Text('Entrenar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    //Revision del boton para saber si fue presionado y por lo tanto desactivado y pintarlo
                    if (states.contains(MaterialState.disabled))
                      return Colors.red;
                    return null;
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed:
                  _probar ? null : () => getConn(context, _questionLabel),
              child: Text('Probar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    //Revision del boton para saber si fue presionado y por lo tanto desactivado y pintarlo
                    if (states.contains(MaterialState.disabled))
                      return Colors.red;
                    return null;
                  },
                ),
              ),
            ),
            Text(
              'Estado de Envio:',
            ),
            Text(
              '$_result',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }

  //Metodo de recoleccion de datos del acelerometro
  void _recolectData(String label) {
    List list = [];
    setState(() {
      _result = "Recolectando";
    });
    var time = DateTime.now();
    StreamSubscription AccStream = accelerometerEvents.listen(
      (AccelerometerEvent event) {},
    );
    AccStream.onData(
      (data) {
        Coordinates coor = Coordinates(data.x, data.y, data.z);
        list.add(coor.toMap());

        if (time.difference(DateTime.now()).inSeconds.abs() > 10) {
          AccStream.pause();
          sendDataNetwork(list, label);
        }
      },
    );
  }

  //Metodo para verificar existencia de un usuario en la base de datos, 4 casos posibles
  Future<http.Response> checkUserDatabase(label) async {
    //1. Existe, Real -> Usuario ya existe, cambie de usuario
    //2. Existe, Prueba -> ----Continua Bien -----
    //3. None, Real -> -----Continua Bien ------
    //4. None, Prueba -> No existe, entrene primero
    const url = 'https://authentication-backend-pg2021.herokuapp.com/Exists';
    var sending = {
      'User': _user.text,
    };

    http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sending),
    )
        .then(
      (res) {
        String res1 = res.body.toString();
        if (res1 == 'None' && label == _realLabel ||
            res1 == 'Exists' && label == _questionLabel) {
          //Caso 2 y 3
          _recolectData(label);
        } else if (res1 == 'Exists' && label == _realLabel) {
          setState(() {
            _entrenar = false;
          });
          //Caso 1
          Alert(
            title: "Usuario Existente",
            desc:
                "Ya existe un usuario con ese nombre, por favor use otro nombre de usuario",
            context: context,
            buttons: [
              DialogButton(
                child: Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        } else if (res1 == "None") {
          setState(() {
            _probar = false;
          });
          //Caso 4
          Alert(
            title: "Usuario No Existente",
            desc:
                "No se ha entrenado un usuario con ese nombre, presione entrenar primero",
            context: context,
            buttons: [
              DialogButton(
                child: Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      },
    );
  }

  //Metodo para enviar datos del acelerometro al backend
  Future<http.Response> sendDataNetwork(List data, label) async {
    setState(() {
      _result = "Enviado";
      _validate = false;
    });
    const url = 'https://authentication-backend-pg2021.herokuapp.com/Train';
    var sending = {
      'Accel': data,
      'User': _user.text,
      'Label': label,
      'Length': data.length
    };
    http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sending),
    )
        .then(
      (res) {
        setState(() {
          _result = "Respuesta Obtenida";
          _entrenar = false;
          _probar = false;
        });
      },
    );
  }

  //Metodo que se llama para verificar si el campo de texto para el nombre de usuario esta vacio
  void preSend(String label) {
    setState(() {
      _user.text.isEmpty ? _validate = true : _validate = false;
      //Si esta vacio se muestra dvertencia en la pantalla, si no, continua a la siguiente verificacion
      if (!_validate) {
        checkUserDatabase(label);
      } else {
        _result = "Sin Enviar";
        _entrenar = false;
        _probar = false;
      }
    });
  }

  //Metodo para verificar conexion de internet y mostrar mensaje de advertencia si no hay conexion
  void getConn(BuildContext context, String label) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      //Dependiendo de cual boton fue presionado, se desactiva
      if (label == _realLabel) {
        _entrenar = true;
      } else {
        _probar = true;
      }
    });

    // Si no hay conexion, se vuelven a activar los botones y se muestra una notificacion
    // de lo contrario se continua a verificar si el nombre de usuario esta vacio o no
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _result = "Sin Enviar";
        _entrenar = false;
        _probar = false;
      });
      Alert(
        title: "Sin Conexión a Internet",
        desc:
            "Se necesita conexión a internet para enviar la información, revise su conexión e intente de nuevo",
        context: context,
        buttons: [
          DialogButton(
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    } else if (connectivityResult == ConnectivityResult.mobile) {
      preSend(label);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      preSend(label);
    }
  }
}
