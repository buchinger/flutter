class Foto {
  static const int MAX_CHARS_COMENTARIO = 255;

  int _id;
  String _imagem;
  String _titulo;
  String _comentario;
  DateTime _data;
  double _latitude;
  double _longitude;

  Foto(this._imagem, this._titulo, this._comentario, this._data, this._latitude,
      this._longitude,
      {int id = 0, String comentario = ""})
      : this._id = id;

  Foto.fromMap(Map<String, dynamic> json)
      : this._id = json['id'],
        this._imagem = json['imagem'],
        this._titulo = json['titulo'],
        this._comentario = json['comentario'],
        this._data = Foto.strToDate(json['data']),
        this._latitude = json['latitude'],
        this._longitude = json['longitude'];

  static DateTime strToDate(String data) {
    List<String> dados = data.split("/");
    int? ano = int.tryParse(dados[2]);
    int? mes = int.tryParse(dados[1]);
    int? dia = int.tryParse(dados[0]);
    return DateTime(
        ano == null ? 0 : ano, mes == null ? 0 : mes, dia == null ? 0 : dia
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'imagem': this.imagem,
      'titulo': this.titulo,
      'comentario': this.comentario,
      'data': this.data,
      'latitude': this.latitude,
      'longitude': this.longitude
    };
  }

  int get id => _id;
  String get imagem => _imagem;
  String get titulo => _titulo;
  String get comentario => _comentario;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get data => "${_data.day}/${_data.month}/${_data.year}";
  set comentario(String valor) {
    if (valor.length > Foto.MAX_CHARS_COMENTARIO)
      throw FormatException("O título deve ter no máximo 255 caracteres");
    this._comentario = comentario;
  }

  set titulo(String valor) {
    if (valor.length > Foto.MAX_CHARS_COMENTARIO)
      throw FormatException("O comentário deve ter no máximo 511 caracteres");
    this._comentario = comentario;
  }
}
