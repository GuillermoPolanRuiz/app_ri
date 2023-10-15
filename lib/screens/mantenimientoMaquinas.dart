import 'dart:convert';
import 'dart:ffi';

import 'package:app_ri/models/bar.dart';
import 'package:app_ri/models/salon.dart';
import 'package:app_ri/theme/theme.dart';
import 'package:flutter/material.dart';

import '../models/database.dart';


class MantenimientoMaquinas extends StatefulWidget {
  final int id;
  final String nombre;
  final int IdSitio;
  final String NombreTabla;
  final bool mantenimiento;
  const MantenimientoMaquinas({ super.key, required this.nombre, required this.id, required this.mantenimiento, required this.IdSitio, required this.NombreTabla});
  @override
  _MantenimientoMaquinasState createState() => _MantenimientoMaquinasState();
}

class _MantenimientoMaquinasState extends State<MantenimientoMaquinas> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  late TextEditingController controllerNombre = TextEditingController();
  late TextEditingController controllerCantidad = TextEditingController();
  late String nombre;
  int billetes50 = 0;
  int billetes20 = 0;
  int billetes10 = 0;
  int billetes5 = 0;
  int cantidadTotal = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mantenimiento Máquinas'),
        backgroundColor: AppTheme.primary, // Cambia el color de fondo de la barra de navegación
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0, bottom: 20.0),
              child: Form(
                key: _formKey,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: controllerNombre,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa un nombre';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nombre = value!;
                      },
                    )
                  ],
                ) 
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              child: Table(
                      border: TableBorder.symmetric(
                      inside: BorderSide(width: 2, color: AppTheme.primary),
                      outside: BorderSide(width: 2)),
                      defaultColumnWidth: FixedColumnWidth(150),
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        const TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text("TIPO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                              ),
                            ),
                            TableCell(
                              child: Center(child: Text("CANTIDAD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                            ),
                            TableCell(
                              child: Center(child: Text("ACCIONES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("Billetes de 50:", style: TextStyle(fontSize: 18))),
                            ),
                            TableCell(
                              child: Center(child: Text("$billetes50", style: TextStyle(fontSize: 18))),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppTheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                            openDialog("Billetes de 50");
                                        });
                                      },
                                      child: Icon(Icons.add_box_rounded),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("Billetes de 20:", style: TextStyle(fontSize: 18))),
                            ),
                            TableCell(
                              child: Center(child: Text("$billetes20", style: TextStyle(fontSize: 18))),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppTheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          openDialog("Billetes de 20");
                                        });
                                      },
                                      child: Icon(Icons.add_box_rounded),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("Billetes de 10:", style: TextStyle(fontSize: 18))),
                            ),
                            TableCell(
                              child: Center(child: Text("$billetes10", style: TextStyle(fontSize: 18))),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppTheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          openDialog("Billetes de 10");
                                        });
                                      },
                                      child: Icon(Icons.add_box_rounded),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("Billetes de 5:", style: TextStyle(fontSize: 18))),
                            ),
                            TableCell(
                              child: Center(child: Text("$billetes5", style: TextStyle(fontSize: 18))),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppTheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          openDialog("Billetes de 5");
                                        });
                                      },
                                      child: Icon(Icons.add_box_rounded),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Center(child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("TOTAL", style: TextStyle(fontSize: 20)),
                              )),
                            ),
                            TableCell(
                              child: Center(child: Text("$cantidadTotal" + " €", style: TextStyle(fontSize: 20))),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppTheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showMyDialog();
                                        });
                                      },
                                      child: Text('Limpiar', style: TextStyle(fontSize: 20),)
                                    ),
                                  ),
                              ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Limpiar Datos'),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListBody(
            children: <Widget>[
              Text("¿Seguro que desea limpiar los datos?")
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Sí'),
            onPressed: () {
              setState(() {
                  billetes50 = 0;
                  billetes20 = 0;
                  billetes10 = 0;
                  billetes5 = 0;
                  cantidadTotal = 0;
                  Navigator.of(context).pop();
              });
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future openDialog(String billetesText) => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(billetesText),
      content: TextField(
        controller: controllerCantidad,
        keyboardType: TextInputType. number,
        decoration: const InputDecoration(
          hintText: 'Ingresa cantidad'
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              
              if (true) {
                if (billetesText.contains('50')) {
                  billetes50 = int.parse(controllerCantidad.text); 
                }else if(billetesText.contains('20')){
                  billetes20 = int.parse(controllerCantidad.text);
                }else if(billetesText.contains('10')){
                  billetes10 = int.parse(controllerCantidad.text);
                }else if(billetesText.contains('5')){
                  billetes5 = int.parse(controllerCantidad.text);
                }
                cantidadTotal = (billetes5 * 5) + (billetes10 * 10) + (billetes20 * 20) + (billetes50 * 50);
                Navigator.of(context).pop();
              }
            });
          }, 
          child: Text('Aceptar'))
      ],
    ) 
  );

}