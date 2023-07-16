import 'package:intl/intl.dart';

import 'DatabaseHelper.dart';

class Entry {
  int? id;
  int? drugId;
  String? time;
  String? notes;
  String? dose;
  String? drugName;
  int? drugLogID;

  void delete() async {
    final db = await DatabaseHelper.getDatabase();
    db.delete("logs", where: "id = ?", whereArgs: [id]);
  }

  static Future<Entry> insertLog(String notes, int drugLogID) async {
    final db = await DatabaseHelper.getDatabase();

    Entry entry = Entry();
    entry.notes = notes;

    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    entry.time = formatter.format(DateTime.now());

    List<Object?> parameters = <Object?>[entry.time, entry.notes, drugLogID];

    final List<Map<String, dynamic>> rows = await db.rawQuery(
        'insert into entries(time, notes, drug_log_id) values (?, ?, ?) returning id',
        parameters);

    var entryID = rows.first['id'] as int;

    entry.drugLogID = drugLogID;
    entry.id = entryID;
    return entry;
  }

  static Future<Entry> insertLogWithDrug(
      String notes, int drugId, String dose, int drugLogID) async {
    final db = await DatabaseHelper.getDatabase();

    Entry entry = Entry();
    entry.notes = notes;
    entry.drugId = drugId;
    entry.dose = dose;
    entry.drugLogID = drugLogID;

    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    entry.time = formatter.format(DateTime.now());

    List<Object?> parameters = <Object?>[
      entry.time,
      entry.notes,
      entry.dose,
      entry.drugId
    ];

    final List<Map<String, dynamic>> rows = await db.rawQuery(
        'insert into entries(time, notes, dose, drug_id, drug_log_id) values (?, ?, ?, ?, ?) returning id',
        parameters);

    var logID = rows.first['id'] as int;

    entry.id = logID;
    return entry;
  }

  static Future<List<Entry>> getLogs() async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> rows = await db.rawQuery(
        'select e.id id, d.id drug_id, e.time time, e.notes notes, e.dose dose, d.name drug_name from entries e left join drugs d on e.drug_id = e.id order by e.time desc');

    return List.generate(rows.length, (i) {
      Entry entry = Entry();
      entry.id = rows[i]['id'];
      entry.time = rows[i]['time'];
      entry.dose = rows[i]['dose'];
      entry.notes = rows[i]['notes'];
      entry.drugId = rows[i]['drug_id'];
      entry.drugName = rows[i]['drug_name'];
      return entry;
    });
  }
}
