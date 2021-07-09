import 'package:sqflite/sqflite.dart';

class BancoDadosGaleria {
  static BancoDadosGaleria? _instance;
  Database? db;

  BancoDadosGaleria._internal();
  final String onCreateSQL = '''CREATE TABLE galeria (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      imagem TEXT,
      titulo TEXT,
      comentario TEXT,
      data TEXT,
      latitude REAL,
      longitude REAL
    );''';

  /* Retorna uma instancia do banco de dados do sub aplicativo da Galeria */
  static BancoDadosGaleria get instance {
    if (_instance == null) _instance = BancoDadosGaleria._internal();
    return _instance!;
  }

  /* Método auxiliar utilizado no método "openDB" */
  void onCreateFunction(Database db, int version) {
    db.execute(onCreateSQL);
  }

  /* Abre uma conexão com o banco de dados local */
  Future<void> openDB() async {
    if (this.db != null) return;
    String path = await getDatabasesPath();
    path += '/galeria_fotos.db';
    this.db = await openDatabase(
      path,
      version: 3,
      // onUpgrade: dropTable
      onCreate: onCreateFunction
    );
  }

  Future<void> dropTable(Database db, int version, int ) async {
    db.execute(" drop table fotos;");
  }
}
