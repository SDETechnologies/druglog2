import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    var dbPath = join(await getDatabasesPath(), 'druglog.db');

    print('db path: ' + dbPath);

    return openDatabase(join(await getDatabasesPath(), 'druglog.db'),
        onCreate: (db, version) {
      db.execute('CREATE TABLE drugs(id INTEGER PRIMARY KEY, name TEXT)');
      db.execute(
          'CREATE TABLE entries (id INTEGER PRIMARY KEY, drug_id INTEGER, drug_log_id INTEGER, time TIMESTAMP, notes TEXT, dose TEXT, FOREIGN KEY (drug_log_id) REFERENCES drug_logs(id), FOREIGN KEY (drug_id) REFERENCES drugs(id))');
      db.execute(
          'CREATE TABLE drug_logs (id INTEGER PRIMARY KEY, title STRING, creationTime TIMESTAMP)');
    }, version: 1);
  }
}
