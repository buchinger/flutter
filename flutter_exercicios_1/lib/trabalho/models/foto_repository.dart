import 'foto.dart';
import 'banco_dados_galeria.dart';

class FotoRepository {
  static const String SELECT_ALL = 'SELECT * FROM galeria;';
  static const String INSERT = '''INSERT INTO galeria
    (imagem, titulo, comentario, data, latitude, longitude)
    VALUES (?,?,?,?,?,?);''';
  static const String UPDATE = "UPDATE galeria SET comentario=? WHERE id=?;";
  static const String DELETE = "DELETE FROM galeria WHERE id=?;";

  Future<List<Foto>> selectAll() async {
    List<Foto> fotos = [];
    await BancoDadosGaleria.instance.db!.rawQuery(SELECT_ALL).then((value) {
      value.forEach((element) {
        fotos.add(Foto.fromMap(element));
      });
    });
    return fotos;
  }

  Future<void> insertFoto(Foto foto) async {
    try{
      await BancoDadosGaleria.instance.db!.rawInsert(
      INSERT, [foto.imagem, foto.titulo, foto.comentario, foto.data,
        foto.latitude, foto.longitude]
      );
    } on Error {
      throw Exception();
    }
  }

  Future<void> updateFoto(Foto foto) async {
    try {
      await BancoDadosGaleria.instance.db!.rawUpdate(UPDATE, [foto.comentario]);
    } on Error {
      throw Exception();
    }
  }

  Future<void> deleteFoto(Foto foto) async {
    try {
      await BancoDadosGaleria.instance.db!.rawDelete(DELETE, [foto.id]);
    } on Error {
      throw Exception();
    }
  }

}
