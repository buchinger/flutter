import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_exercicios_1/trabalho/models/foto.dart';
import 'package:flutter_exercicios_1/trabalho/models/foto_repository.dart';
import 'package:flutter_exercicios_1/trabalho/models/banco_dados_galeria.dart';

class GaleriaController {
  static GaleriaController? _instance;
  List<Foto> fotos = [];
  FotoRepository repositorio = FotoRepository();
  Base64Encoder encoder = Base64Encoder();
  Base64Decoder decoder = Base64Decoder();

  GaleriaController._internal();

  /* Retorna uma instancia do controller do sub aplicativo da Galeria */
  static GaleriaController get instance {
    if (_instance == null) _instance = GaleriaController._internal();
    return _instance!;
  }

  // Controlador do campo textual de cadastro
  TextEditingController inputTitulo = TextEditingController();
  TextEditingController inputComentario = TextEditingController();

  Future<void> abrirBD() async {
    await BancoDadosGaleria.instance.openDB();
  }

  Future<void> buscarFotos() async {
    List<Foto> fotos = await repositorio.selectAll();
    // print("*** Found ${fotos.length} fotos");
    this.fotos = fotos;
  }

  /// Cadastro um novo registro de foto. Caso algum dado não seja válido,
  /// o cadastro não é concluído e uma Exception com mensagem de erro é
  /// arremessada.
  Future<void> cadastrar(
      Uint8List imagem, double latitude, double longitude) async {
    try {
      DateTime agora = DateTime.now();
      String imagemEncoded = encoder.convert(imagem);
      Foto foto = Foto(imagemEncoded, inputTitulo.text, inputComentario.text,
          agora, latitude, longitude);
      await repositorio.insertFoto(foto);
      this.fotos.add(foto);
      inputTitulo.clear();
      inputComentario.clear();
    } on FormatException catch (err) {
      throw Exception(err.message);
    }
  }

  /* Remove uma foto em um determinado índice 'index' da lista de fotos.
    Se o 'index' for inválido/inexistente, uma string de erro é retornada */
  Future<String?> remover(int index) async {
    if (index < 0 || index > fotos.length)
      return "Registro de foto inexistente";
    await repositorio.deleteFoto(fotos[index]);
    this.fotos.removeAt(index);
  }
}
