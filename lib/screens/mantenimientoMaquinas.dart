import 'dart:convert';
import 'dart:ffi';

import 'package:app_ri/models/bar.dart';
import 'package:app_ri/models/salon.dart';
import 'package:app_ri/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/database.dart';
import '../models/maquina.dart';


class MantenimientoMaquinas extends StatefulWidget {
  final int id;
  final String nombre;
  final String nombreSitio;
  final int IdSitio;
  final String NombreTabla;
  final int BCincuenta;
  final int BVeinte;
  final int BDiez;
  final int BCinco;
  final String recaudacion;
  final String recaudacionParcial;
  final String recaudacionTotal;
  final int MDos;
  final int MUno;
  final int MCincuenta;
  final int MVeinte;
  final int MDiez;
  final bool mantenimiento;
  const MantenimientoMaquinas({ super.key, required this.nombre, required this.id, required this.mantenimiento, required this.IdSitio, required this.NombreTabla, required this.BCincuenta, required this.BVeinte, required this.BDiez, required this.BCinco, required this.recaudacion, required this.MDos, required this.MUno, required this.MCincuenta, required this.MVeinte, required this.MDiez, required this.recaudacionParcial, required this.recaudacionTotal, required this.nombreSitio});
  @override
  _MantenimientoMaquinasState createState() => _MantenimientoMaquinasState();
}

class _MantenimientoMaquinasState extends State<MantenimientoMaquinas> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerCantidad = TextEditingController();
  String nombre = "";
  int BCincuenta = 0;
  int BVeinte = 0;
  int BDiez = 0;
  int BCinco = 0;
  String recaudacion = "";
  String recaudacionParcial = "";
  String recaudacionTotal = "";
  int MDos = 0;
  int MUno = 0;
  int MCincuenta= 0;
  int MVeinte = 0;
  int MDiez = 0;
  int total = 0;

  String pParcial = "";

  double totalPrecio = 0.00;
  Color colorTotal = Colors.green;

  @override
  Widget build(BuildContext context) {
    if (widget.NombreTabla == "Salones") {
      pParcial = "P. Manual";
    }else{
      pParcial = "R. PARCIAL";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Mantenimiento Máquinas'),
        backgroundColor: AppTheme.primary, // Cambia el color de fondo de la barra de navegación
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child:Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
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
                ),
              ) 
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0, left: 8.0, right: 8.0),
                child: Table(
                  border: TableBorder.symmetric(
                  inside: BorderSide(width: 2, color: AppTheme.primary),
                  outside: BorderSide(width: 2)),
                  children:const [ 
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                            child: Center(child: Text("BILLETES", style: TextStyle(fontWeight: FontWeight.bold),)),
                          ),
                        )
                      ],
                    ),
                  ],
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 1, right: 1),
              child: Table(
                      border: TableBorder.symmetric(
                      inside: BorderSide(width: 2, color: AppTheme.primary),
                      outside: BorderSide(width: 2)),
                      columnWidths: {
                        0:FixedColumnWidth(100),
                        1:FixedColumnWidth(90),
                        2:FixedColumnWidth(100)
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        const TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                                child: Center(child: Text("TIPO", style: TextStyle(fontWeight: FontWeight.bold),)),
                              ),
                            ),
                            TableCell(
                              child: Center(child: Text("CANTIDAD", style: TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                            TableCell(
                              child: Center(child: Text("ACCIONES", style: TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("50", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(child: Text("$BCincuenta")),
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
                                        openDialog("Billetes de 50");
                                    });
                                  },
                                  child: Icon(Icons.add_box_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("20", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(child: Text("$BVeinte")),
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
                                      openDialog("Billetes de 20");
                                    });
                                  },
                                  child: Icon(Icons.add_box_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("10", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(child: Text("$BDiez")),
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
                                      openDialog("Billetes de 10");
                                    });
                                  },
                                  child: Icon(Icons.add_box_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("5", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(child: Text("$BCinco")),
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
                                      openDialog("Billetes de 5");
                                    });
                                  },
                                  child: Icon(Icons.add_box_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0, left: 8.0, right: 8.0, top: 8.0),
                child: Table(
                  border: TableBorder.symmetric(
                  inside: BorderSide(width: 2, color: AppTheme.primary),
                  outside: BorderSide(width: 2)),
                  children:const [ 
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                            child: Center(child: Text("MONEDAS", style: TextStyle(fontWeight: FontWeight.bold),)),
                          ),
                        )
                      ],
                    ),
                  ],
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 1, right: 1),
              child: Table(
                      border: TableBorder.symmetric(
                      inside: BorderSide(width: 2, color: AppTheme.primary),
                      outside: BorderSide(width: 2)),
                      columnWidths: {
                        0:FixedColumnWidth(100),
                        1:FixedColumnWidth(90),
                        2:FixedColumnWidth(100)
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        const TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                                child: Center(child: Text("TIPO", style: TextStyle(fontWeight: FontWeight.bold),)),
                              ),
                            ),
                            TableCell(
                              child: Center(child: Text("CANTIDAD", style: TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                            TableCell(
                              child: Center(child: Text("ACCIONES", style: TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("2", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(child: Text("$MDos")),
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
                                        openDialog("Monedas de 2");
                                    });
                                  },
                                  child: Icon(Icons.add_box_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("1", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(child: Text("$MUno")),
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
                                        openDialog("Monedas de 1");
                                    });
                                  },
                                  child: Icon(Icons.add_box_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("50", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(child: Text("$MCincuenta")),
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
                                        openDialog("Monedas de 50");
                                    });
                                  },
                                  child: Icon(Icons.add_box_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("20", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(child: Text("$MVeinte")),
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
                                      openDialog("Monedas de 20");
                                    });
                                  },
                                  child: Icon(Icons.add_box_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(child: Text("10", style: TextStyle(fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(child: Text("$MDiez")),
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
                                      openDialog("Monedas de 10");
                                    });
                                  },
                                  child: Icon(Icons.add_box_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0, left: 8.0, right: 8.0, top: 8.0),
                child: Table(
                  border: TableBorder.symmetric(
                  inside: BorderSide(width: 2, color: AppTheme.primary),
                  outside: BorderSide(width: 2)),
                  children:const [ 
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                            child: Center(child: Text("RECAUDACIÓN", style: TextStyle(fontWeight: FontWeight.bold),)),
                          ),
                        )
                      ],
                    ),
                  ],
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                ),
              ),
            ),
            Table(
              border: TableBorder.symmetric(
              inside: BorderSide(width: 2, color: AppTheme.primary),
              outside: BorderSide(width: 2)),
              columnWidths: const {
                0:FixedColumnWidth(100),
                1:FixedColumnWidth(190)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    const TableCell(
                      child: Center(child: Text("RECAUDACIÓN", style: TextStyle(fontSize: 10),)),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("$recaudacion" + " €")),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.symmetric(
              inside: BorderSide(width: 2, color: AppTheme.primary),
              outside: BorderSide(width: 2)),
              columnWidths: {
                0:FixedColumnWidth(100),
                1:FixedColumnWidth(90),
                2:FixedColumnWidth(100)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Center(child: Text("$pParcial", style: TextStyle(fontSize: 12),)),
                    ),
                    TableCell(
                      child: Center(child: Text("$recaudacionParcial" + " €")),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppTheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  openDialog("Parcial");
                                });
                              },
                              child: Icon(Icons.add_box_rounded),
                            ),
                      ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.symmetric(
              inside: BorderSide(width: 2, color: AppTheme.primary),
              outside: BorderSide(width: 2)),
              columnWidths: {
                0:FixedColumnWidth(100),
                1:FixedColumnWidth(90),
                2:FixedColumnWidth(100)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    const TableCell(
                      child: Center(child: Text("R.TOTAL", style: TextStyle(fontSize: 12),)),
                    ),
                    TableCell(
                      child: Center(child: Text(
                        "$recaudacionTotal" + " €", 
                        style: TextStyle(
                          color: colorTotal,
                          fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppTheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _limpiarDialog();
                                });
                              },
                              child: Text('Limpiar')
                            ),
                      ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // recaudacion = totalPrecio.toString();
                  if (widget.mantenimiento) {
                    _db.updateMaquina(
                    Maquina(
                      id: widget.id,
                      idSitio: widget.IdSitio, 
                      nombre: controllerNombre.text, 
                      nombreTabla: widget.NombreTabla, 
                      recaudacion: recaudacion, 
                      recaudacionParcial: recaudacionParcial,
                      recaudacionTotal: recaudacionTotal,
                      fechaUltimaRec: (DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString()),
                      BCincuenta: BCincuenta,
                      BVeinte: BVeinte,
                      BDiez: BDiez,
                      BCinco: BCinco,
                      MDos: MDos,
                      MUno: MUno,
                      MCincuenta: MCincuenta,
                      MVeinte: MVeinte,
                      MDiez: MDiez
                      ));
                  }else{
                    _db.insertMaquina(
                    Maquina(
                      id: total+1,
                      idSitio: widget.IdSitio, 
                      nombre: controllerNombre.text, 
                      nombreTabla: widget.NombreTabla, 
                      recaudacion: recaudacion, 
                      recaudacionParcial: recaudacionParcial,
                      recaudacionTotal: recaudacionTotal,
                      fechaUltimaRec: (DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString()),
                      BCincuenta: BCincuenta,
                      BVeinte: BVeinte,
                      BDiez: BDiez,
                      BCinco: BCinco,
                      MDos: MDos,
                      MUno: MUno,
                      MCincuenta: MCincuenta,
                      MVeinte: MVeinte,
                      MDiez: MDiez
                      ));
                  }
                  _db.updateSitioRec(widget.IdSitio, widget.NombreTabla);
                  _guardadoDialog();
                }
              },
              style: ElevatedButton.styleFrom(
                primary: AppTheme.primary, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.mantenimiento) {
                  _showMyDialog(widget.id, widget.nombre);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: AppTheme.primary, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Borrar',
                style: TextStyle(fontSize: 18, color: Colors.white),
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
    controllerNombre = TextEditingController(text: widget.nombre);
    nombre = widget.nombre;
    BCincuenta = widget.BCincuenta;
    BVeinte = widget.BVeinte;
    BDiez = widget.BDiez;
    BCinco = widget.BCinco;
    recaudacion = widget.recaudacion;
    if (widget.recaudacionParcial.length == 0) {
      recaudacionParcial = "0,00";  
    }else{
      recaudacionParcial = widget.recaudacionParcial;
    }
    if (widget.recaudacionTotal.length == 0) {
      recaudacionTotal = "0,00";  
    }else{
      recaudacionTotal = widget.recaudacionTotal;
      if (recaudacionTotal.contains('-')) {
        colorTotal = Colors.red;
      }
    }
    MDos = widget.MDos;
    MUno = widget.MUno;
    MCincuenta= widget.MCincuenta;
    MVeinte = widget.MVeinte;
    MDiez = widget.MDiez;
    if (widget.mantenimiento) {
      totalPrecio = double.parse(widget.recaudacion.replaceAll(',', '.'));
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setTotal();
    });
  }

  void setTotal() async{
    total = await _db.getCountMaquina();
  }

  Future<void> _limpiarDialog() async {
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
                  BCincuenta = 0;
                  BVeinte = 0;
                  BDiez = 0;
                  BCinco = 0;
                  MDos = 0;
                  MUno = 0;
                  MCincuenta = 0;
                  MVeinte = 0;
                  MDiez = 0;
                  recaudacion = "0,00";
                  recaudacionParcial = "0,00";
                  recaudacionTotal = "0,00";
                  totalPrecio = 0.00;
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
        autofocus: true,
        controller: controllerCantidad,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa cantidad',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            
            setState(() {
              if (controllerCantidad.text.isEmpty || controllerCantidad.text == "") {
                Navigator.of(context).pop();
              }
              else if(!validarDialog(billetesText, controllerCantidad.text)){

              }
              else{
                if (billetesText.contains("Billetes")) {
                  if (billetesText.contains('50')) {
                    BCincuenta = int.parse(controllerCantidad.text); 
                  }else if(billetesText.contains('20')){
                    BVeinte = int.parse(controllerCantidad.text);
                  }else if(billetesText.contains('10')){
                    BDiez = int.parse(controllerCantidad.text);
                  }else if(billetesText.contains('5')){
                    BCinco = int.parse(controllerCantidad.text);
                  }
                
                }else if(billetesText.contains("Monedas")){
                  if (billetesText.contains('50')) {
                    MCincuenta = int.parse(controllerCantidad.text); 
                  }else if(billetesText.contains('20')){
                    MVeinte = int.parse(controllerCantidad.text);
                  }else if(billetesText.contains('10')){
                    MDiez = int.parse(controllerCantidad.text);
                  }else if(billetesText.contains('2')){
                    MDos = int.parse(controllerCantidad.text);
                  }else if(billetesText.contains('1')){
                    MUno = int.parse(controllerCantidad.text);
                  }
                }
                if (billetesText.contains('Parcial')) {    
                  if (controllerCantidad.text.contains('.')) {
                    controllerCantidad.text = controllerCantidad.text.replaceAll('.',',');
                  }
                  if (!controllerCantidad.text.contains(',')) {
                    controllerCantidad.text += ',00';
                  }
                  if(controllerCantidad.text.split(',')[1].length == 1){
                    controllerCantidad.text += '0';
                  }
                  recaudacionParcial = controllerCantidad.text;
                }
                totalPrecio = (BCinco * 5) + (BDiez * 10) + (BVeinte * 20) + (BCincuenta * 50) + (MDos * 2) + (MUno * 1) + (MCincuenta * 0.50) + (MVeinte * 0.20) + (MDiez * 0.10);
                var array;
                array = totalPrecio.toStringAsFixed(2).split('.');
                if (array[1].length > 2) {
                  recaudacion = array[0] + ',' + array[1].substring(0,2);
                }else if(array[1].length == 1){
                  recaudacion = array[0] + ',' + array[1] + "0";
                }else{
                  recaudacion = array[0] + ',' + array[1];
                }
                var resta = (double.parse(recaudacion.replaceAll(',','.'))) - (double.parse(recaudacionParcial.replaceAll(',', '.')));
                array = resta.toStringAsFixed(2).split('.');
                if (array[1].length > 2) {
                  recaudacionTotal = array[0] + ',' + array[1].substring(0,2);
                }else if(array[1].length == 1){
                  recaudacionTotal = array[0] + ',' + array[1] + "0";
                }else{
                  recaudacionTotal = array[0] + ',' + array[1];
                }
                if (resta < 0) {
                  colorTotal = Colors.red;
                }else{
                  colorTotal = Colors.green;
                }
                if (recaudacionTotal.contains('-') && widget.nombreSitio.toUpperCase().contains('CASTEJ') && widget.NombreTabla == "Salones") {
                  recaudacionTotal = "0,00";
                }
                controllerCantidad.text = "";
                Navigator.of(context).pop();
            }
            });
          }, 
          child: Text('Aceptar'))
      ],
    ) 
  );
  
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
                _db.deleteMaquina(id);
                Navigator.of(context).pop();
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
  
  bool validarDialog(String billetesText, String text) {
    if(controllerCantidad.text.contains(',')){
      if(!billetesText.contains('Parcial')){
        return false;
      }
      if (controllerCantidad.text.split(',')[1].length > 2) {
        return false;
      }
    }
    else if(controllerCantidad.text.contains('-')){
      return false;
    }
    return true;
  }
  
  
}