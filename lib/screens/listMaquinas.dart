import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/database.dart';
import '../theme/theme.dart';
import 'mantenimiento.dart';
import 'mantenimientoMaquinas.dart';

class ListMaquinas extends StatefulWidget {
  final int idSitio;
  final String nombreTabla;
  final String nombreSitio;
  const ListMaquinas({super.key, required this.nombreSitio, required this.idSitio, required this.nombreTabla});

  @override
  State<ListMaquinas> createState() => _ListMaquinasState();
}

class _ListMaquinasState extends State<ListMaquinas> {
  final DatabaseService _db = DatabaseService();
  late Future<List<dynamic>> future = _db.getMaquinas(widget.idSitio, widget.nombreTabla);
  late int total = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maquinas ' + widget.nombreSitio),
        backgroundColor: AppTheme.primary, // Cambia el color de fondo de la barra de navegación
      ),
      body: FutureBuilder(
              future: future ,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      total = snapshot.data!.length;
                      final sitio = snapshot.data![index];
                      return Card(
                            key: ValueKey(sitio.id),
                            margin: const EdgeInsets.all(30),
                            color: Color.fromARGB(255, 255, 251, 251),
                            elevation: 5,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Row(children: [Text(
                                      sitio.nombre,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ), Expanded(child: Column()),
                                    
                                    Container(margin: EdgeInsets.only(bottom: 30),)],),
                                    subtitle: Text("Recaudación: " + sitio.recaudacion.toString() + "\n" + "Fecha: " + sitio.fechaUltimaRec.toString()),
                                    trailing: Icon(Icons.navigate_next,size: 30,),
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                           MantenimientoMaquinas(
                                              id: sitio.id, 
                                              nombre: sitio.nombre,
                                              IdSitio: widget.idSitio, 
                                              NombreTabla: widget.nombreTabla, 
                                              mantenimiento: true,
                                              recaudacion: sitio.recaudacion,
                                              BCincuenta: sitio.BCincuenta,
                                              BVeinte: sitio.BVeinte,
                                              BDiez: sitio.BDiez,
                                              BCinco: sitio.BCinco,
                                              MDos: sitio.MDos,
                                              MUno: sitio.MUno,
                                              MCincuenta: sitio.MCincuenta,
                                              MVeinte: sitio.MVeinte,
                                              MDiez: sitio.MDiez
                                            )
                                          )
                                      ).then((_){
                                        setState(() {
                                          future = _db.getMaquinas(widget.idSitio, widget.nombreTabla);
                                        });
                                      }),
                                    }
                                ),
                              ],
                            )
                      );
                    }
                  );
                }

                if (snapshot.hasError) return Text("error");
                return CircularProgressIndicator();
              },
            ), 
          floatingActionButton: Align(
          alignment: const Alignment(0.9, 0.9),
          child: FloatingActionButton.large(
            onPressed: ()
            => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MantenimientoMaquinas(
                      IdSitio: widget.idSitio, 
                      NombreTabla: widget.nombreTabla, 
                      id: total + 1, 
                      nombre: '', 
                      mantenimiento: false,
                      recaudacion: "0",
                      BCincuenta: 0,
                      BVeinte: 0,
                      BDiez: 0,
                      BCinco: 0,
                      MDos: 0,
                      MUno: 0,
                      MCincuenta: 0,
                      MVeinte: 0,
                      MDiez: 0
                    )
                  )
              ).then((_){
                setState(() {
                  future = _db.getMaquinas(widget.idSitio, widget.nombreTabla);
                });
              }),
            backgroundColor: AppTheme.primary,
            elevation: 5,
            child: const Icon(Icons.add),
            )),
    );
  }
}