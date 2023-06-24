import 'package:druglog2/models/database_helper.dart';

class Drug {
  int? id;
  final String name;

  Drug({
    required this.name,
  });

  void DeleteDrug() async {
    final db = await DatabaseHelper.GetDatabase();
    db.delete("drugs", where: "id = ?", whereArgs: [id]);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Future<Drug> insertDrug(String drugName) async {
    final db = await DatabaseHelper.GetDatabase();

    Drug drug = Drug(name: drugName);
    var dbID = await db.insert(
      'drugs',
      drug.toMap(),
    );

    drug.id = dbID;
    return drug;
  }

  static Future<List<Drug>> getDrugs() async {
    final db = await DatabaseHelper.GetDatabase();
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
