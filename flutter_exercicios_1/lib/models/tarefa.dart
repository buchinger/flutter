class Tarefa {
  String _nome;
  bool _concluida = false;

  Tarefa(this._nome, {bool concluida = false}) : this._concluida = concluida;

  set nome(String nome) {
    if (nome.length < 3)
      throw FormatException("O nome da tarefa deve ter pelo menos 3 letras");
    this._nome = nome;
  }

  String get nome => _nome;
  bool get isConcluida => _concluida;

  void setConcluida() {
    this._concluida = true;
  }

  void setPendente() {
    this._concluida = false;
  }
}
