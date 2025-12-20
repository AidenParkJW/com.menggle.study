import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static DBHelper? _instance;
  static Database? _database;
  static int? _version;

  DBHelper._();

  factory DBHelper.getInstance() {
    _instance ??= DBHelper._();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    _version = await _database!.getVersion();
    
    debugPrint('DB Initialized!!, DB Version : $_version');
    return _database!;
  }

  int get version => _version!;

  Future<Database> _initDatabase() async {
    final String dbDir = await getDatabasesPath();
    final String dbPath = join(dbDir, 'todo.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        return await db.execute(
          "CREATE TABLE TODO"
          "( ID INTEGER PRIMARY KEY AUTOINCREMENT"
          ", ISACTIVE INTEGER"
          ", TITLE TEXT"
          ", CONTENT TEXT"
          ")",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // something do
        }
      },
    );
  }
}