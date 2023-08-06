import 'package:druglog2/models/DatabaseHelper.dart';

class Unit {
  int? id;
  String? value;

  static Future<List<Unit>> getUnits() async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> rows =
        await db.rawQuery('select id, value from units order by value asc');

    return List.generate(rows.length, (index) {
      Unit unit = Unit();
      unit.id = rows[index]['id'];
      unit.value = rows[index]['value'];
      return unit;
    });
  }

  static Future<Unit> getById(int id) async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> rows =
        await db.rawQuery('select value from units where id = ?', [id]);

    Unit unit = Unit();
    unit.id = id;
    unit.value = rows.first['value'] as String;

    return unit;
  }
}
