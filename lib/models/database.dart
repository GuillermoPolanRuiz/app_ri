import 'package:app_ri/models/salon.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'bar.dart';
import 'maquina.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'flutter_sqflite_database.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE Bares(
        id INTEGER PRIMARY KEY, 
        nombre TEXT NOT NULL, 
        ubic TEXT NOT NULL)''',
        
    );
    await db.execute(
      '''CREATE TABLE Salones(
        id INTEGER PRIMARY KEY, 
        nombre TEXT NOT NULL, 
        ubic TEXT NOT NULL)''',
    );

    await db.execute(
      '''CREATE TABLE Maquinas(
        id INTEGER PRIMARY KEY, 
        nombre TEXT NOT NULL, 
        idSitio INTEGER NOT NULL,
        nombreTabla TEXT NOT NULL)''',
    );

    await db.execute(
      '''INSERT INTO Bares(
        id, nombre, ubic) VALUES (1, 'Bar Prueba', 'San Juan')''',
    );

    await db.execute(
      '''INSERT INTO Salones(
        id, nombre, ubic) VALUES (1, 'Salón Sarriguren', 'Sarriguren')''',
    );

    await db.execute(
      '''INSERT INTO Maquinas(
        id, nombre, idSitio, nombreTabla) VALUES (1, 'Maquina Prueba', 2, 'Bares')''',
    );
  }


  Future<void> insertBar(Bar bar) async {
    final db = await _databaseService.database;
    await db.insert(
      'Bares',
      bar.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSalon(Salon salon) async {
    final db = await _databaseService.database;
    await db.insert(
      'Salones',
      salon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMaquina(Maquina maquina) async {
    final db = await _databaseService.database;
    await db.insert(
      'Maquinas',
      maquina.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<dynamic>> getData(String text) async {

    final db = await _databaseService.database;
    if (text == "Bares") {
      final List<Map<String, dynamic>> maps = await db.query('Bares');
      return List.generate(maps.length, (index) => Bar.fromMap(maps[index])); 
    }else{
      final List<Map<String, dynamic>> maps = await db.query('Salones');
      return List.generate(maps.length, (index) => Salon.fromMap(maps[index]));
    }
  }


  Future<List<dynamic>> getWhere(String nombreTabla, String text) async{
    final db = await _databaseService.database;
    if (nombreTabla == "Bares") {
      final list = await db.rawQuery("SELECT * FROM Bares WHERE nombre LIKE '"+'%'+text+'%'+"'"); 
      return List.generate(list.length, (index) => Bar.fromMap(list[index]));
    }else{
      final list = await db.rawQuery("SELECT * FROM Salones WHERE nombre LIKE '"+'%'+text+'%'+"'"); 
      return List.generate(list.length, (index) => Salon.fromMap(list[index]));
    }
  }

  Future<List<Bar>> getBares() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Bares');
    return List.generate(maps.length, (index) => Bar.fromMap(maps[index]));
  }

  Future<List<Salon>> getSalones() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Salones');
    return List.generate(maps.length, (index) => Salon.fromMap(maps[index]));
  }

  Future<List<Maquina>> getMaquinas(int idSitio, String nombreTabla) async {
    final db = await _databaseService.database;
    final list = await db.rawQuery("SELECT * FROM Maquinas WHERE idSitio = " + idSitio.toString() + " AND nombreTabla LIKE '"+ nombreTabla +"'");
    return List.generate(list.length, (index) => Maquina.fromMap(list[index]));
  }

  Future<void> updateBar(Bar sitio) async {
    final db = await _databaseService.database;
    await db.update('Bares', sitio.toMap(), where: 'id = ?', whereArgs: [sitio.id]);
  }

  Future<void> updateSalon(Salon sitio) async {
    final db = await _databaseService.database;
    await db.update('Salones', sitio.toMap(), where: 'id = ?', whereArgs: [sitio.id]);
  }

  Future<void> updateMaquina(Maquina sitio) async {
    final db = await _databaseService.database;
    await db.update('Maquinas', sitio.toMap(), where: 'id = ?', whereArgs: [sitio.id]);
  }

  Future<void> deleteBar(int id) async {
    final db = await _databaseService.database;
    await db.delete('Bares', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteSalon(int id) async {
    final db = await _databaseService.database;
    await db.delete('Salones', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteMaquina(int id) async {
    final db = await _databaseService.database;
    await db.delete('Maquinas', where: 'id = ?', whereArgs: [id]);
  }
  
  
}