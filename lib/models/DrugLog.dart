import 'package:druglog2/models/DatabaseHelper.dart';
import 'package:druglog2/models/Drug.dart';
import 'package:druglog2/models/Entry.dart';
import 'package:druglog2/models/ROA.dart';
import 'package:druglog2/models/Unit.dart';
import 'package:intl/intl.dart';

class DrugLog {
  int? id;
  String? title;
  String? creationTime;
  List<Entry>? entries;

  DrugLog({required this.title});

  void delete() async {
    final db = await DatabaseHelper.getDatabase();
    db.delete("drug_logs", where: "id = ?", whereArgs: [id]);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'creationTime': creationTime,
    };
  }

  static Future<DrugLog> insertDrugLog(String title) async {
    final db = await DatabaseHelper.getDatabase();

    DrugLog drugLog = DrugLog(title: title);

    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    drugLog.creationTime = formatter.format(DateTime.now());

    var dbID = await db.insert(
      'drug_logs',
      drugLog.toMap(),
    );

    drugLog.id = dbID;
    return drugLog;
  }

  static Future<List<DrugLog>> getDrugLogs() async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> rows = await db.query('drug_logs');

    return List.generate(rows.length, (i) {
      DrugLog drugLog = DrugLog(
        title: rows[i]['name'],
      );
      drugLog.title = rows[i]['title'];
      drugLog.creationTime = rows[i]['creationTime'];
      drugLog.id = rows[i]['id'];
      return drugLog;
    });
  }

  Future<List<Entry>> getEntries() async {
    final db = await DatabaseHelper.getDatabase();

    List<Object?> parameters = <Object?>[id];

    final List<Map<String, dynamic>> rows = await db.rawQuery('''select 
        id, 
        time,
        dose, 
        drug_id, 
        roa_id,
        unit_id
        from entries
        where drug_log_id = ?
        order by time desc''', parameters);

    List<Entry> entries = [];

    await Future.forEach(rows, (element) async {
      Entry entry = Entry();
      entry.id = element['id'];
      entry.time = element['time'];
      entry.dose = element['dose'];
      entry.drug = await Drug.getDrugById(element['drug_id']);
      entry.roa = await ROA.getById(element['roa_id']);
      entry.unit = await Unit.getById(element['unit_id']);
      entries.add(entry);
    });

    return entries;
  }
}
