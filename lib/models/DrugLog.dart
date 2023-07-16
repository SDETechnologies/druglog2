import 'package:druglog2/models/DatabaseHelper.dart';
import 'package:druglog2/models/Entry.dart';
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
      drugLog.id = rows[i]['creationTime'];
      drugLog.id = rows[i]['id'];
      return drugLog;
    });
  }

  Future<List<Entry>> getEntriesForDrugLog() async {
    final db = await DatabaseHelper.getDatabase();
    List<Object?> parameters = <Object?>[id];

    final List<Map<String, dynamic>> rows = await db.rawQuery(
        'select e.id id, d.id drug_id, e.time time, e.notes notes, e.dose dose, d.name drug_name from entries e left join drugs d on e.drug_id = e.id where e.drug_log_id = ? order by e.time desc',
        parameters);

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
