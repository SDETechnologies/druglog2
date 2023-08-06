import 'package:druglog2/models/DatabaseHelper.dart';

class ROA {
  int? id;
  String? value;

  static Future<List<ROA>> getROAs() async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> rows =
        await db.rawQuery('select id, value from roa order by value asc');

    return List.generate(rows.length, (index) {
      ROA roa = ROA();
      roa.id = rows[index]['id'];
      roa.value = rows[index]['value'];
      return roa;
    });
  }

  static Future<ROA> getById(int id) async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> rows =
        await db.rawQuery('select value from roa where id = ?', [id]);

    ROA roa = ROA();
    roa.id = id;
    roa.value = rows.first['value'] as String;

    return roa;
  }
}
