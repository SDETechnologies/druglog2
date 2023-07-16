import 'package:druglog2/models/DatabaseHelper.dart';

class Drug {
  int? id;
  final String name;

  Drug({
    required this.name,
  });

  void delete() async {
    final db = await DatabaseHelper.getDatabase();
    db.delete("drugs", where: "id = ?", whereArgs: [id]);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Future<Drug> insertDrug(String drugName) async {
    final db = await DatabaseHelper.getDatabase();

    Drug drug = Drug(name: drugName);
    var dbID = await db.insert(
      'drugs',
      drug.toMap(),
    );

    drug.id = dbID;
    return drug;
  }

  static Future<Drug> getDrugById(int id) async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> rows =
        await db.query('drugs', where: 'id = ?', whereArgs: [id]);

    return Drug(name: rows[0]['name']);
  }

  static Future<List<Drug>> getDrugs() async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> rows = await db.query('drugs');

    return List.generate(rows.length, (i) {
      Drug drug = Drug(
        name: rows[i]['name'],
      );
      drug.id = rows[i]['id'];
      return drug;
    });
  }
}
