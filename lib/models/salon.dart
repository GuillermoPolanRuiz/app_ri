import 'dart:convert';

import 'package:flutter/widgets.dart';

class Salon {
  final int id;
  final String nombre;
  final String ubic;
  final String fechRec;

  Salon({
    required this.id,
    required this.nombre,
    required this.ubic,
    required this.fechRec
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'ubic': ubic,
      'fechRec': fechRec
    };
  }

  factory Salon.fromMap(Map<String, dynamic> map) {
    return Salon(
      id: map['id']?.toInt() ?? 0,
      nombre: map['nombre'] ?? '',
      ubic: map['ubic'] ?? '',
      fechRec: map['fechRec'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory Salon.fromJson(String source) => Salon.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Salon(id: $id, nombre: $nombre, ubic: $ubic)';
  }
}