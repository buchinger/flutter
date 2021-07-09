import 'package:flutter/cupertino.dart';
import 'package:flutter_exercicios_1/models/pessoa_repository.dart';
import 'package:flutter_exercicios_1/models/pessoa.dart';
import 'banco_dados.dart';

class ListaPessoasController {
  List<Pessoa> listaPessoas = [];
  PessoaRepository repositorio = PessoaRepository();

  TextEditingController nomeController = TextEditingController();

  Future<void> abrirBD() async {
    await BancoDados.instance.openDB();
  }

  Future<void> buscarBanco() async {
    repositorio.selectAll().then((pessoas) {
      listaPessoas = pessoas;
    });
  }

  Future<void> cadastrar() async {
    Pessoa pessoa = Pessoa(nomeController.text);
    await repositorio.insertPessoa(pessoa);
    nomeController.clear();
  }

  Future<void> remover(int index) async {
    if (index < 0 || index > listaPessoas.length)
      throw Exception("Pessoa inexistente");
    await repositorio.deletePessoa(listaPessoas[index]);
    listaPessoas.removeAt(index);
  }
}
