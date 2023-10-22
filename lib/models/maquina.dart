import 'dart:convert';

import 'package:flutter/widgets.dart';

class Maquina {
  final int id;
  final String nombre;
  final int idSitio;
  final String nombreTabla;
  final String recaudacion;
  final String recaudacionParcial;
  final String recaudacionTotal;
  final String fechaUltimaRec;
  final int BCincuenta;
  final int BVeinte;
  final int BDiez;
  final int BCinco;
  final int MDos;
  final int MUno;
  final int MCincuenta;
  final int MVeinte;
  final int MDiez;

  Maquina({
    required this.id,
    required this.nombre,
    required this.idSitio,
    required this.nombreTabla,
    required this.recaudacion,
    required this.fechaUltimaRec,
    required this.BCincuenta,
    required this.BVeinte,
    required this.BDiez,
    required this.BCinco,
    required this.MDos,
    required this.MUno,
    required this.MCincuenta,
    required this.MVeinte,
    required this.MDiez,
    required this.recaudacionParcial,
    required this.recaudacionTotal
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'idSitio': idSitio,
      'nombreTabla': nombreTabla,
      'recaudacion': recaudacion,
      'recaudacionParcial': recaudacionParcial,
      'recaudacionTotal': recaudacionTotal,
      'fechaUltimaRec': fechaUltimaRec,
      'BCincuenta': BCincuenta,
      'BVeinte': BVeinte,
      'BDiez': BDiez,
      'BCinco': BCinco,
      'MDos': MDos,
      'MUno': MUno,
      'MCincuenta': MCincuenta,
      'MVeinte': MVeinte,
      'MDiez': MDiez,
    };
  }

  factory Maquina.fromMap(Map<String, dynamic> map) {
    return Maquina(
      id: map['id']?.toInt() ?? 0,
      nombre: map['nombre'] ?? '',
      idSitio: map['idSitio'] ?? 0,
      nombreTabla: map['nombreTabla'] ?? '',
      recaudacion: map['recaudacion'] ?? '',
      recaudacionParcial: map['recaudacionParcial'] ?? '',
      recaudacionTotal: map['recaudacionTotal'] ?? '',
      fechaUltimaRec: map['fechaUltimaRec'] ?? '',
      BCincuenta: map['BCincuenta'] ?? 0,
      BVeinte: map['BVeinte'] ?? 0,
      BDiez: map['BDiez'] ?? 0,
      BCinco: map['BCinco'] ?? 0,
      MDos: map['MDos'] ?? 0,
      MUno: map['MUno'] ?? 0,
      MCincuenta: map['MCincuenta'] ?? 0,
      MVeinte: map['MVeinte'] ?? 0,
      MDiez: map['MDiez'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Maquina.fromJson(String source) => Maquina.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Maquina(id: $id, nombre: $nombre, idSitio: $idSitio, nombreTabla: $nombreTabla, recaudacion: $recaudacion, fechaUltimaRec: $fechaUltimaRec)';
  }
}