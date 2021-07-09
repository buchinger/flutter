import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/models/contato.dart';

class ListaTelefonicaController {
  List<Contato> _listaContatos = [
    Contato(nome: 'Diego Buchinger', telefone: '99989 3589')
  ];

  TextEditingController caixaNome = TextEditingController();
  TextEditingController caixaTelefone = TextEditingController();

  List<Contato> get listaContatos => _listaContatos;

  Contato getContato(int index) => _listaContatos[index];

  void addContato() {
    Contato contato =
        Contato(nome: caixaNome.text, telefone: caixaTelefone.text);
    caixaNome.clear();
    caixaTelefone.clear();
    _listaContatos.add(contato);
  }

  void removeContato(int index) {
    if (index < 0 || index >= _listaContatos.length)
      throw Exception("Contato inexistente");
    _listaContatos.removeAt(index);
  }
}
