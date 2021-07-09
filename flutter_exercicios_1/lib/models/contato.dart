class Contato {
  String _nome = "";
  String _telefone = "";

  static final RegExp notNumberRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]');
  static final RegExp numberRegExp = RegExp(r'[0-9]');

  Contato({required String nome, required String telefone}) {
    this.nome = nome;
    this.telefone = telefone;
  }

  set nome(String nome) {
    if (nome.length < 3) throw FormatException("Nome muito pequeno");
    if (nome.contains(numberRegExp))
      throw FormatException("O nome contém um número");
    this._nome = nome;
  }

  String get nome {
    return this._nome;
  }

  set telefone(String telefone) {
    telefone = telefone.replaceAll(" ", "").replaceAll("-", "");
    // print("TELEFONE: $telefone");
    if (telefone.length < 8 || telefone.length > 9)
      throw FormatException("O telefone não possui 8 ou 9 dígitos");
    if (telefone.contains(notNumberRegExp))
      throw FormatException("O telefone possui símbolos que não são números");
    this._telefone = telefone;
  }

  String get telefone {
    int meio = 5;
    if (this._telefone.length == 8) meio = 4;
    return this._telefone.substring(0, meio) +
        "-" +
        this._telefone.substring(meio, this._telefone.length);
  }
}
