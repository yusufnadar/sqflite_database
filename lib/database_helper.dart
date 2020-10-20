import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_app/kullanici_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper _databasehelper;
  static Database _database;

  factory DatabaseHelper() {
    if (_databasehelper == null) {
      _databasehelper = DatabaseHelper._internal();
      return _databasehelper;
    } else {
      return _databasehelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "kullanicilar.db"); // dart path

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true); //dart io
      } catch (_) {}

      // Copy from asset
      ByteData data =
      await rootBundle.load(join("assets", "kullanicilar.db")); // dart services
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map>> kullanicilariGetir() async {
    Database db = await _getDatabase();
    List<Map> gelenKullanicilar = await db.query("kullanicilarTablosu");
    return gelenKullanicilar;
  }

  Future<List<Kullanicilar>> kullanicilariListeHalindeGetir() async {
    List kullanicilariTutanMapListesi = await kullanicilariGetir();
    List kullaniciListesi = List<Kullanicilar>();
    for (Map map in kullanicilariTutanMapListesi) {
      kullaniciListesi.add(Kullanicilar.fromMap(map));
    }
    return kullaniciListesi;
  }

  Future<int> kullaniciEkle(Kullanicilar kullanicilar) async {
    Database db = await _getDatabase();
    int sonuc = await db.insert("kullanicilarTablosu", kullanicilar.toMap());
    return sonuc;
  }

  Future<int> kullaniciSil(int gelenKullaniciID) async {
    Database db = await _getDatabase();
    int sonuc = await db
        .delete("kullanicilarTablosu", where: 'kullaniciID = ?', whereArgs: [gelenKullaniciID]);
    return sonuc;
  }

  Future<int> kullaniciGuncelle(Kullanicilar kullanicilar) async {
    Database db = await _getDatabase();
    int sonuc = await db.update("kullanicilarTablosu", kullanicilar.toMap(),
        where: "kullaniciID = ?", whereArgs: [kullanicilar.kullaniciID]);
    return sonuc;
  }

  Future<int> tumKullanicilariSil() async {
    Database db = await _getDatabase();
    int sonuc = await db
        .delete("kullanicilarTablosu");
    return sonuc;
  }
}
