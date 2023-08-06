import 'package:druglog2/models/Drug.dart';
import 'package:druglog2/models/DrugLog.dart';
import 'package:druglog2/models/ROA.dart';
import 'package:druglog2/models/Unit.dart';
import 'package:intl/intl.dart';

import 'DatabaseHelper.dart';

class Entry {
  int? id;
  Drug? drug;
  String? time;
  String? dose;
  ROA? roa;
  Unit? unit;

  void delete() async {
    final db = await DatabaseHelper.getDatabase();
    db.delete("logs", where: "id = ?", whereArgs: [id]);
  }

  static Future<Entry> insertEntry(Drug drug, Unit unit, String dose, ROA roa,
      DateTime timestamp, DrugLog druglog) async {
    final db = await DatabaseHelper.getDatabase();

    Entry entry = Entry();
    entry.drug = drug;
    entry.dose = dose;
    entry.roa = roa;
    entry.unit = unit;

    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    entry.time = formatter.format(timestamp);

    List<Object?> parameters = <Object?>[
      entry.drug!.id,
      entry.unit!.id,
      entry.dose,
      entry.roa!.id,
      entry.time,
      druglog.id!
    ];

    final List<Map<String, dynamic>> rows = await db.rawQuery(
        'insert into entries(drug_id, unit_id, dose, roa_id, time, drug_log_id) values (?, ?, ?, ?, ?, ?) returning id',
        parameters);

    var entryId = rows.first['id'] as int;

    entry.id = entryId;

    return entry;
  }
}
