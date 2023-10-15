import 'package:app_ri/models/bar.dart';
import 'package:app_ri/models/salon.dart';
import 'package:app_ri/theme/theme.dart';
import 'package:flutter/material.dart';

import '../models/database.dart';


class Mantenimiento extends StatefulWidget {
  final String name;
  final int id;
  final String nombre;
  final String ubic;
  final bool mantenimiento;
  const Mantenimiento({ super.key, required this.name, required this.nombre, required this.ubic, required this.id, required this.mantenimiento});
  @override
  _MantenimientoState createState() => _MantenimientoState();
}

class _MantenimientoState extends State<Mantenimiento> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController locationController = TextEditingController(text: '');
  String name = '';
  String location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mantenimiento ' + widget.name),
        backgroundColor: AppTheme.primary, // Cambia el color de fondo de la barra de navegación
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: nameController,
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
                  name = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa una ubicación';
                  }
                  return null;
                },
                onSaved: (value) {
                  location = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.name == "Bares") {
                      if (widget.mantenimiento) {
                        _db.updateBar(new Bar(id: widget.id, nombre: name, ubic: location));
                      }else{
                        _db.insertBar(new Bar(id: widget.id, nombre: name, ubic: location));
                      }
                    }else{
                      if (widget.mantenimiento) {
                        _db.updateSalon(new Salon(id: widget.id, nombre: name, ubic: location));
                      }else{
                        _db.insertSalon(new Salon(id: widget.id, nombre: name, ubic: location));
                      }
                    }
                    _guardadoDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.primary, // Cambia el color de fondo del botón
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, right: 18, top: 50),
                child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.mantenimiento) {
                      _showMyDialog(widget.id, widget.nombre);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.primary, // Cambia el color de fondo del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Borrar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.nombre);
    locationController = TextEditingController(text: widget.ubic);
  }

  Future<void> _showMyDialog(id, name) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar registro'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('¿Desea eliminar el siguiente registro?'),
              Text("\n"+name),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Sí'),
            onPressed: () {
              setState(() {
                Navigator.of(context).pop();
                  if (widget.name == "Bares") {
                      _db.deleteBar(widget.id);
                      Navigator.pop(context);
                  }else{
                    _db.deleteSalon(widget.id);
                    Navigator.pop(context);
                  }
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

  Future<void> _guardadoDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Guardar'),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListBody(
            children: <Widget>[
              Text("¡Se ha guardado corréctamente!")
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
          ],
        );
      },
    );
  }

}