import 'pessoa.dart';
import '../controllers/banco_dados.dart';

class PessoaRepository {
  static const String SELECT_ALL = 'SELECT * FROM pessoas;';
  static const String INSERT = 'INSERT INTO pessoas (nome) VALUES (?);';
  static const String UPDATE = 'UPDATE pessoas SET nome=? WHERE id=?;';
  static const String DELETE = 'DELETE FROM pessoas WHERE id=?;';

  Future<List<Pessoa>> selectAll() async {
    List<Pessoa> pessoas = [];
    if (BancoDados.instance.db == null)
      throw Exception("Banco de dados não está acessível");
    BancoDados.instance.db!.rawQuery(SELECT_ALL).then((value) {
      value.forEach((element) {
        pessoas.add(Pessoa.fromMap(element));
      });
    });
    return pessoas;
  }

  Future<void> insertPessoa(Pessoa pessoa) async {
    await BancoDados.instance.db!.rawInsert(INSERT, [pessoa.nome]);
  }

  Future<void> updatePessoa(Pessoa pessoa) async {
    await BancoDados.instance.db!.rawUpdate(UPDATE, [pessoa.nome, pessoa.id]);
  }

  Future<void> deletePessoa(Pessoa pessoa) async {
    await BancoDados.instance.db!.rawDelete(DELETE, [pessoa.id]);
  }
}
