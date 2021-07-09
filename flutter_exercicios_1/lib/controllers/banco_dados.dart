import 'package:sqflite/sqflite.dart';

class BancoDados {
  Database? db;
  static BancoDados? _instance;
  BancoDados._internal();

  static BancoDados get instance {
    if (_instance == null) _instance = BancoDados._internal();
    return _instance!;
  }

  final String onCreateSQL = '''
    CREATE TABLE pessoas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT);
  ''';

  onCreateFunction(Database db, int version) {
    db.execute(onCreateSQL);
  }

  Future<void> openDB() async {
    if (db != null) return;
    getDatabasesPath().then((value) {
      String path = value + 'exemplo.db';
      openDatabase(path, version: 1, onCreate: onCreateFunction).then((value) {
        this.db = value;
      });
    });
  }
}
