import 'dart:convert';
import 'dart:ffi';

import 'package:app_ri/models/Historial.dart';
import 'package:flutter/material.dart';

import '../models/database.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final DatabaseService _db = DatabaseService();
  late Future<List<Historial>> future = _db.getHistorial();
  TextEditingController controllerCantidad = TextEditingController();
  late int totalHistorial = 0;
  late int primerResultado = 0;
  late double totalSumaHistorial = 0.00;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Historial')),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.delete
            ),
            backgroundColor: Colors.red,
            onPressed: () {
              openDialogDelete(context);
            },
            heroTag: null,
          ),
          SizedBox(
            height: 15,
          ),
          FloatingActionButton(           
            child: Icon(
              Icons.add
            ),
            onPressed: () {
          setState(() {
              openDialogAdd();
            });
          },
            heroTag: null,
          )
        ]
      ),
      body: FutureBuilder(
              future: future ,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final historial = snapshot.data![index];
                      totalHistorial = snapshot.data!.length;
                      if (totalHistorial == 1) {
                        return Column(
                            children: const [
                              Padding(padding: EdgeInsets.all(20)),
                              Text(
                                "0.00",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              Padding(padding: EdgeInsets.all(20)),
                            ] 
                          );
                      }
                      if (index == 0) {
                        totalSumaHistorial = double.parse(historial.cantidad);
                        return Column(
                            children:[
                              Padding(padding: EdgeInsets.all(20)),
                              Text(
                                historial.cantidad.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              Padding(padding: EdgeInsets.all(20)),
                            ] 
                          );
                      }
                      return Column(
                        children: [
                          Text(historial.cantidad)
                        ],
                      );
                    }
                  );
                }
                if (snapshot.hasError) return Text("error");
                return CircularProgressIndicator();
          }
        )
    );
  }


  Future openDialogAdd() => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text('Añadir'),
      content: TextField(
        autofocus: true,
        controller: controllerCantidad,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa la cantidad:',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              if (controllerCantidad.text.isEmpty || controllerCantidad.text == "") {
                Navigator.of(context).pop();
              }else{
                String cantidad = double.parse(controllerCantidad.text.toString()).toStringAsFixed(2);
                Historial historial = new Historial(id: totalHistorial + 1, cantidad: cantidad);
                _db.insertHistorial(historial);
                Navigator.pop(context);
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
              }
            });
          }, 
          child: Text('Aceptar'))
      ],
    ) 
  );


  Future<bool> openDialogDelete(BuildContext context) async {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text("Cancelar"),
    onPressed: () {
      // returnValue = false;
      Navigator.of(context).pop(false);
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text("Sí"),
    onPressed: () {
      _db.deleteHistorialCompleto();
      Navigator.pop(context);
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => super.widget));
    },
  ); // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("¿Desea borrar todos los registros?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  ); // show the dialog
  final result = await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return result ?? false;
}
  
}



