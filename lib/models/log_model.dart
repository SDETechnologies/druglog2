import 'package:druglog2/models/drug_model.dart';
import 'package:intl/intl.dart';

import 'database_helper.dart';

class Log {
  int? id;
  int? drugId;
  String? time;
  String? notes;
  String? dose;
  String? drugName;

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'drug_id': drugId,
  //     'time': time,
  //     'notes': notes,
  //     'dose': dose,
  //     'drugName': drugName,
  //   };
  // }

  void Delete() async {
    final db = await DatabaseHelper.GetDatabase();
    db.delete("logs", where: "id = ?", whereArgs: [id]);
  }

//          'select l.id, d.drug_id, l.timestamp, l.notes, l.dose, d.name from logs l left join drugs d on l.drug_id = l.id order by l.timestamp desc');

  static Future<Log> insertLog(String notes) async {
    final db = await DatabaseHelper.GetDatabase();

    Log log = Log();
    log.notes = notes;

    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    log.time = formatter.format(DateTime.now());

    List<Object?> parameters = <Object?>[log.time, log.notes];

    final List<Map<String, dynamic>> rows = await db.rawQuery(
        'insert into logs(time, notes) values (?, ?) returning id', parameters);

    var logID = rows.first['id'] as int;

    log.id = logID;
    return log;
  }

  static Future<Log> insertLogWithDrug(
      String notes, int drugId, String dose) async {
    final db = await DatabaseHelper.GetDatabase();

    Log log = Log();
    log.notes = notes;
    log.drugId = drugId;
    log.dose = dose;

    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    log.time = formatter.format(DateTime.now());

    List<Object?> parameters = <Object?>[
      log.time,
      log.notes,
      log.dose,
      log.drugId
    ];

    final List<Map<String, dynamic>> rows = await db.rawQuery(
        'insert into logs(time, notes, dose, drug_id) values (?, ?, ?, ?) returning id',
        parameters);

    var logID = rows.first['id'] as int;

    log.id = logID;
    return log;
  }

  static Future<List<Log>> getLogs() async {
    final db = await DatabaseHelper.GetDatabase();
    final List<Map<String, dynamic>> rows = await db.rawQuery(
        'select l.id id, d.id drug_id, l.time time, l.notes notes, l.dose dose, d.name drug_name from logs l left join drugs d on l.drug_id = l.id order by l.time desc');

    return List.generate(rows.length, (i) {
      Log log = Log();
      log.id = rows[i]['id'];
      log.time = rows[i]['time'];
      log.dose = rows[i]['dose'];
      log.notes = rows[i]['notes'];
      log.drugId = rows[i]['drug_id'];
      log.drugName = rows[i]['drug_name'];
      return log;
    });
  }
}
