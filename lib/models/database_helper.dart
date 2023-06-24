import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> GetDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(join(await getDatabasesPath(), 'druglog2.db'),
        onCreate: (db, version) {
      db.execute('CREATE TABLE drugs(id INTEGER PRIMARY KEY, name TEXT)');
      db.execute(
          'CREATE TABLE logs (id INTEGER PRIMARY KEY, drug_id INTEGER,time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, notes TEXT)');
    }, version: 1);
  }
}
