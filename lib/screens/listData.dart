import 'dart:convert';
import 'dart:ffi';
import 'package:app_ri/screens/list.dart';
import 'package:app_ri/screens/mantenimiento.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../models/bar.dart';
import '../models/database.dart';
import '../models/maquina.dart';
import '../theme/theme.dart';
import 'listMaquinas.dart';


class ListDataScreen extends StatefulWidget{
  final String name;
  const ListDataScreen({ super.key, required this.name});

  @override
  _ListDataScreen createState() => _ListDataScreen();
}

class _ListDataScreen extends State<ListDataScreen> {
  final DatabaseService _db = DatabaseService();
  late Future<List<dynamic>> future = _db.getData(widget.name);
  List<Maquina> listaRecaudacionHoy = List.empty(); 
  TextEditingController tbBuscar = TextEditingController();
  Color colorRec = Colors.green;
  late int total = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name}"),
      ),
      body: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(25),
                  child: TextField(
                    controller: tbBuscar,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppTheme.primary)
                      )
                    )
                  ),
                )
            ),
            Container(
              margin: EdgeInsets.only(right: 20 ),
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: AppTheme.primary),
                onPressed: (){
                  setState(() {
                    future = _db.getWhere(widget.name, tbBuscar.text);
                  });
                },
                child: Text(style: TextStyle(color: Colors.white),'Buscar')
              ),
            )
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      total = snapshot.data!.length;
                      final sitio = snapshot.data![index];
                      if (sitio.fechRec.contains('-')) {
                         colorRec = Colors.red;
                      }else{
                        colorRec = Colors.green;
                      }
                      String recaudacionDia = "0,00";
                      if (comprobarFechaActual(sitio.fechRec.toString())) {
                        recaudacionDia = sitio.fechRec.toString().split(';')[1];
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
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                    Color.fromARGB(255, 255, 245, 245),
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
                                          fontSize: 18,
                                        ),
                                      ), Expanded(child: Column()),
                                      
                                      Container(margin: EdgeInsets.only(bottom: 30),)],),
                                      subtitle: Text(sitio.ubic),
                                      trailing: Icon(Icons.navigate_next,size: 30,),
                                      onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ListMaquinas(idSitio: sitio.id, nombreTabla: widget.name, nombreSitio: sitio.nombre, nombreUbic: sitio.ubic,)
                                            )
                                        ).then((_){
                                            setState(() {
                                              future = _db.getData(widget.name);
                                            });
                                          }),
                                      }
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "$recaudacionDia €",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: colorRec
                                        ),
                                      ),
                                  ),
                                  TextButton(
                                        style: TextButton.styleFrom(backgroundColor: AppTheme.primary),
                                        onPressed: ()
                                        => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Mantenimiento(name: widget.name, id: sitio.id,nombre: sitio.nombre, ubic: sitio.ubic, fechRec: sitio.fechRec, mantenimiento: true)
                                              )
                                          ).then((_){
                                            setState(() {
                                              future = _db.getData(widget.name);
                                            });
                                          }),
                                        child: const Icon(
                                          color: Colors.white,
                                          Icons.edit),
                                      )
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
          )
        ],
      ),
      floatingActionButton: Align(
          alignment: const Alignment(0.9, 0.9),
          child: FloatingActionButton(
            onPressed: ()
            => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Mantenimiento(name: widget.name,id: total+1,nombre: '', ubic: '', fechRec: '', mantenimiento: false)
                  )
              ).then((_){
                setState(() {
                  future = _db.getData(widget.name);
                });
              }),
            backgroundColor: AppTheme.primary,
            elevation: 5,
            child: const Icon(Icons.add),
            )),
    );
  }

  
  

  
  
  @override
  void initState() {
    super.initState();
  }
  
  bool comprobarFechaActual(String fechRec) {
    var array = fechRec.split(';');
    String fecha = array[0];
    String fechaActual = DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString();
    if (fecha == fechaActual) {
      return true;
    }
    return false;
  }
  
  



  
}
