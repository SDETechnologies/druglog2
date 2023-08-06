import 'package:druglog2/models/DatabaseHelper.dart';
import 'package:intl/intl.dart';

class Note {
  int? id;
  String? text;
  String? time;
  int? drugLogID;

  static Future<Note> insertNote(String noteText, int drugLogID) async {
    final db = await DatabaseHelper.getDatabase();

    Note note = Note();
    note.text = noteText;
    note.drugLogID = drugLogID;

    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    note.time = formatter.format(DateTime.now());

    List<Object?> parameters = <Object?>[note.text, note.time, note.drugLogID];
    final List<Map<String, dynamic>> rows = await db.rawQuery(
        'insert into notes(note, time, drug_log_id) values (?, ?, ?) returning id',
        parameters);

    var noteID = rows.first['id'] as int;

    note.id = noteID;

    return note;
  }
}
