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
  final String nombreUbic;
  const ListMaquinas({super.key, required this.nombreSitio, required this.idSitio, required this.nombreTabla, required this.nombreUbic});

  @override
  State<ListMaquinas> createState() => _ListMaquinasState();
}

class _ListMaquinasState extends State<ListMaquinas> {
  final DatabaseService _db = DatabaseService();
  late Future<List<dynamic>> future = _db.getMaquinas(widget.idSitio, widget.nombreTabla);
  late int total = 0;
  Color colorBtn = Color.fromARGB(255, 131, 234, 135);
  Color secondColorBtn = Color.fromARGB(255, 200, 255, 203);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreSitio),
        actions: <Widget>[
          PopupMenuButton<int>(
              onSelected: (item) => handleClick(item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: Text('Limpiar')),
              ],
            ),
        ],
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
                      Color colorBtn = Colors.green;
                      if (sitio.recaudacionTotal.contains('-')) {
                        colorBtn = Color.fromARGB(255, 231, 116, 108);
                        secondColorBtn = Color.fromARGB(255, 255, 195, 195);
                      }else{
                        colorBtn = Color.fromARGB(255, 131, 234, 135);
                        secondColorBtn = Color.fromARGB(255, 200, 255, 203);
                      }
                      return Card(
                            key: ValueKey(sitio.id),
                            margin: const EdgeInsets.all(30),
                            color: Color.fromARGB(255, 255, 251, 251),
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                    Colors.white,
                                    secondColorBtn,
                                    colorBtn,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Row(children: [Text(
                                        sitio.nombre,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ), Expanded(child: Column()),
                                      Container(margin: EdgeInsets.only(bottom: 30),)],),
                                      subtitle: Text(
                                          "Recaudación: " + sitio.recaudacionTotal.toString() + ' €' + "\n" + "Fecha: " + sitio.fechaUltimaRec.toString(),
                                          style: const TextStyle(
                                            fontSize: 14
                                          ),
                                        
                                        ),
                                      trailing: Icon(Icons.navigate_next,size: 30,),
                                      onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                             MantenimientoMaquinas(
                                                id: sitio.id, 
                                                nombre: sitio.nombre,
                                                nombreSitio: widget.nombreUbic,
                                                IdSitio: widget.idSitio, 
                                                NombreTabla: widget.nombreTabla, 
                                                mantenimiento: true,
                                                recaudacion: sitio.recaudacion,
                                                recaudacionParcial: sitio.recaudacionParcial,
                                                recaudacionTotal: sitio.recaudacionTotal,
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
                              ),
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
                      nombreSitio: widget.nombreUbic, 
                      mantenimiento: false,
                      recaudacion: "0,00",
                      recaudacionParcial: "0,00",
                      recaudacionTotal: "0,00",
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
  
  void handleClick(int item) {
    switch (item) {
      case 0:
        break;
    }
  }
}