import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/models/tarefa.dart';

class ListaTarefaController {
  List<Tarefa> _tarefas = [Tarefa('Acordar cedo')];
  Tarefa getTarefa(int index) => _tarefas[index];
  int tarefasLenght() => _tarefas.length;

  TextEditingController caixaTarefa = TextEditingController();
  bool switchCompleta = false;

  void addTarefa() {
    Tarefa tarefa = Tarefa(caixaTarefa.text, concluida: switchCompleta);
    caixaTarefa.clear();
    switchCompleta = false;
    _tarefas.add(tarefa);
  }

  void removeTarefa(int index) {
    _checkIndex(index);
    _tarefas.removeAt(index);
  }

  concluirTarefa(int index) {
    _checkIndex(index);
    _tarefas[index].setConcluida();
  }

  reativarTarefa(int index) {
    _checkIndex(index);
    _tarefas[index].setPendente();
  }

  _checkIndex(int index) {
    if (index < 0 || index >= _tarefas.length)
      throw Exception("Tarefa inexistente");
  }
}
