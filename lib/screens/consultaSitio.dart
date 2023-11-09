import 'package:flutter/material.dart';

import '../models/database.dart';

class ConsultaSitio extends StatefulWidget {
  final int idSitio;
  final String nombreTabla;
  const ConsultaSitio({super.key, required this.idSitio, required this.nombreTabla});

  @override
  State<ConsultaSitio> createState() => _ConsultaSitioState();
}

class _ConsultaSitioState extends State<ConsultaSitio> {
  final DatabaseService _db = DatabaseService();
  late Future<List<dynamic>> future = _db.getSitio(widget.idSitio, widget.nombreTabla);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta'),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot){
          if (snapshot.hasData) {
            final sitio = snapshot.data![0];
            return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top:20.0, bottom: 14.0),
                    child: Center(child: Text(sitio.nombre, style: TextStyle(fontSize: 16),)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Datos generales',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                      child: Center(
                        child: Table(
                          columnWidths: const {
                            0:FixedColumnWidth(100),
                            1:FixedColumnWidth(10),
                            2:FixedColumnWidth(100)
                          },
                           children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Text('Ubicacion: ',textAlign:TextAlign.right,)
                                ),
                                TableCell(
                                  child: Text('')
                                ),
                                TableCell(
                                  child: Text(sitio.ubic, style: TextStyle(fontSize: 14),), 
                                
                                )
                              ]
                            )
                           ],
                        ),
                      )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Recaudación',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                      child: Center(
                        child: Table(
                          columnWidths: const {
                            0:FixedColumnWidth(200),
                            1:FixedColumnWidth(10),
                            2:FixedColumnWidth(250)
                          },
                           children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Text('F. Última recaudación: ',textAlign:TextAlign.right,)
                                ),
                                TableCell(
                                  child: Text('')
                                ),
                                TableCell(
                                  child: Text(sitio.fechRec.toString().split(';')[0], style: TextStyle(fontSize: 14),), 
                                
                                )
                              ]
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Text('Recaudación total: ',textAlign:TextAlign.right,),
                                  )
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Text(''),
                                  )
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Text(sitio.fechRec.toString().split(';')[1] + " €", style: TextStyle(fontSize: 14),),
                                  ), 
                                
                                )
                              ]
                            )
                           ],
                        ),
                      )
                    ),
                  )
                ],
              );
          }
          if (snapshot.hasError) return Text("error");
                return CircularProgressIndicator();
        }
        
        )
    );
  }
}