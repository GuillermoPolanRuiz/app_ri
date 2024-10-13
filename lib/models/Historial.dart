import 'dart:convert';

import 'package:flutter/widgets.dart';

class Historial {
  final int id;
  final String cantidad;

  Historial({
    required this.id,
    required this.cantidad
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cantidad': cantidad
    };
  }

  factory Historial.fromMap(Map<String, dynamic> map) {
    return Historial(
      id: map['id']?.toInt() ?? 0,
      cantidad: map['cantidad'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory Historial.fromJson(String source) => Historial.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Historial(id: $id, cantidad: $cantidad';
  }
}