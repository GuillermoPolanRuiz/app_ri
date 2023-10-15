import 'dart:convert';

import 'package:flutter/widgets.dart';

class Maquina {
  final int id;
  final String nombre;
  final int idSitio;
  final String nombreTabla;

  Maquina({
    required this.id,
    required this.nombre,
    required this.idSitio,
    required this.nombreTabla,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'idSitio': idSitio,
      'nombreTabla': nombreTabla,
    };
  }

  factory Maquina.fromMap(Map<String, dynamic> map) {
    return Maquina(
      id: map['id']?.toInt() ?? 0,
      nombre: map['nombre'] ?? '',
      idSitio: map['idSitio'] ?? 0,
      nombreTabla: map['nombreTabla'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory Maquina.fromJson(String source) => Maquina.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Maquina(id: $id, nombre: $nombre, idSitio: $idSitio, nombreTabla: $nombreTabla)';
  }
}