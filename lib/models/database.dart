import 'dart:io';

import 'package:app_ri/models/salon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Historial.dart';
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
    final path = join(databasePath, 'AppRI.db');
    final exists = await databaseExists(path);
    if (exists) {
      return await openDatabase(
        path,
        version: 1,
        onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      );  
    }else{
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load(join('assets', 'AppRI.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      return await openDatabase(
        path,
        version: 1,
        onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      );  
    }
    
  }

  // Future<dynamic> alterTable() async {
  //   final db = await _databaseService.database;
  //   var count = await db.execute("ALTER TABLE 'Maquinas' ADD COLUMN 'recaudacionParcial' TEXT;");
  //   var count2 = await db.execute("ALTER TABLE 'Maquinas' ADD COLUMN 'recaudacionTotal' TEXT;");
  //   return count;
  // }

  Future<void> limpiarTodo(int idSitio, String nombreTabla) async{
    final db = await _databaseService.database;
    int updateCount = await db.rawUpdate('''
    UPDATE Maquinas 
    SET recaudacion = ?, recaudacionParcial = ?, recaudacionTotal = ?, BCincuenta = ?, BVeinte = ?, BDiez = ?, BCinco = ?
    MDos = ?, MUno = ?, MCincuenta = ?, MVeinte = ?, MDiez = ?
    WHERE idSitio = ? AND nombreTabla = ?
    ''', 
    ['0,00','0,00','0,00', '0', '0', '0', '0', '0', '0', '0', '0', '0', idSitio, nombreTabla]);
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
        nombreTabla TEXT NOT NULL,
        recaudacion TEXT NOT NULL,
        fechaUltimaRec TEXT,
        BCincuenta INTEGER,
        BVeinte INTEGER,
        BDiez INTEGER,
        BCinco INTEGER,
        MDos INTEGER,
        MUno INTEGER,
        MCincuenta INTEGER,
        MVeinte INTEGER,
        MDiez INTEGER
        )''',
    );

    await db.execute(
      '''CREATE TABLE Historial(
        id INTEGER PRIMARY KEY, 
        cantidad INTEGER NOT NULL, 
        fecha TEXT NOT NULL)''',
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

  Future<void> insertHistorial(Historial historial) async {
    final db = await _databaseService.database;
    await db.insert(
      'Historial',
      historial.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getCountMaquina() async {
    final db = await _databaseService.database;
    List<Map> list = await db.rawQuery('SELECT * FROM Maquinas');
    int count = list.length;
    
    return count;
  }

  Future<void> updateSitioRec(int idSitio, String nombreTabla) async{
    final db = await _databaseService.database;
    String fechaActual = DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString();
    double total = 0.00;
    String valor = "";
    List<Map<String, dynamic>> count;
    if (nombreTabla == "Bares") {
      count = await db.rawQuery('''SELECT recaudacionParcial FROM Maquinas 
      WHERE fechaUltimaRec = ? AND idSitio = ? AND nombreTabla = ?''',
      [fechaActual, idSitio, nombreTabla]);
    }else{
      count = await db.rawQuery('''SELECT recaudacionTotal FROM Maquinas 
      WHERE fechaUltimaRec = ? AND idSitio = ? AND nombreTabla = ?''',
      [fechaActual, idSitio, nombreTabla]);
    }
    if (count.isNotEmpty) {
      for (var e in count) {
        total += double.parse(e.values.toString().replaceAll(',', '.').replaceAll('(', '').replaceAll(')', ''));
      }
    }
    valor = total.toStringAsFixed(2).replaceAll('.', ',');
    if (valor.split(',')[1].length == 1) {
      valor += '0';
    }
    valor = fechaActual + ";" + valor;
    if (nombreTabla == "Bares") {
      int updateCount = await db.rawUpdate('''
      UPDATE Bares 
      SET fechRec = ?
      WHERE id = ?
      ''', 
      [valor, idSitio]);
    }else{
      int updateCount = await db.rawUpdate('''
      UPDATE Salones 
      SET fechRec = ?
      WHERE id = ?
      ''', 
      [valor, idSitio]);
    }

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

  Future<List<Bar>> getSitio(int idSitio, String nombreTabla) async {
    final db = await _databaseService.database;
    List<Map<String, dynamic>> maps = List.empty();
    if (nombreTabla == "Bares") {
      maps = await db.rawQuery('''SELECT * FROM Bares 
      WHERE id = ?''',
      [idSitio]);
    }else{
      maps = await db.rawQuery('''SELECT * FROM Salones 
      WHERE id = ?''',
      [idSitio]);
    }
    
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

  Future<List<Historial>> getHistorial() async {
    final db = await _databaseService.database;
    final list = await db.rawQuery("SELECT 0 as id, (SELECT CAST(SUM(CAST(cantidad as decimal)) as TEXT)) AS cantidad FROM Historial UNION ALL SELECT id, cantidad FROM Historial ORDER BY id");
    return List.generate(list.length, (index) => Historial.fromMap(list[index]));
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

  Future<void> deleteHistorialCompleto() async {
    final db = await _databaseService.database;
    await db.delete('Historial');
  }
  
  
}