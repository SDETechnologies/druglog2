import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(join(await getDatabasesPath(), 'druglog.db'),
        onCreate: (db, version) {
      db.execute('CREATE TABLE drugs(id INTEGER PRIMARY KEY, name TEXT)');
      db.execute(
          'CREATE TABLE notes(id INTEGERY PRIMARY KEY, note TEXT, time TIMESTAMP, drug_log_id INTEGER, FOREIGN KEY(drug_log_id) REFERENCES drug_logs(id))');
      db.execute('''CREATE TABLE entries(
            id INTEGER PRIMARY KEY, 
            drug_id INTEGER, 
            drug_log_id INTEGER,
            roa_id INTEGER,
            unit_id INTEGER,
            time TIMESTAMP, 
            dose TEXT, 
            FOREIGN KEY (drug_id) REFERENCES drugs(id),
            FOREIGN KEY (drug_log_id) REFERENCES drug_logs(id),
            FOREIGN KEY (roa_id) REFERENCES roas(id),
            FOREIGN KEY (unit_id) REFERENCES units(id))
            ''');

      db.execute(
          'CREATE TABLE drug_logs (id INTEGER PRIMARY KEY, title STRING, creationTime TIMESTAMP)');
      db.execute('CREATE TABLE roa(id INTEGER PRIMARY KEY, value STRING)');
      db.execute(
          "INSERT INTO roa(value) values ('Oral'),('Intravaenous'),('Sublingual'),('Intramuscular'),('Intranasal'),('Vaporized'),('Rectal'),('Vaginal'),('Subcataenous')");
      db.execute('CREATE TABLE units(id INTEGER PRIMARY KEY, value STRING)');
      db.execute("INSERT INTO units(value) values ('mg'),('g'),('lb'),('oz')");
    }, version: 1);
  }
}
