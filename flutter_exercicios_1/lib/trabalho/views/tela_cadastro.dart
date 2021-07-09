import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/trabalho/controllers/galeria_controller.dart';
import 'package:location/location.dart';

class TelaCadastro extends StatefulWidget {
  final Uint8List _imagem;
  const TelaCadastro(this._imagem);

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Nova Foto"),
        centerTitle: true,
      ),
      body: Container(child: _formulario()),
    );
  }

  /// Desenha o formulario do corpo da tela
  Widget _formulario() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Column(
        children: [
          Container(
            height: 250,
            child: Image.memory(widget._imagem),
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              child: Text("Título:")),
          Container(
            child: TextField(
                controller: GaleriaController.instance.inputTitulo,
                maxLength: 255,
                maxLines: 1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2))))),
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              child: Text("Comentário:")),
          Container(
            child: TextField(
              controller: GaleriaController.instance.inputComentario,
              maxLength: 511,
              maxLines: 3,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)))),
            ),
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    child: Text("Salvar"),
                    onPressed: _salvarFoto,
                  )))
        ],
      ),
    );
  }

  /// Salva foto e retorna à tela principal
  Future<void> _salvarFoto() async {
    double latitude = double.nan;
    double longitude = double.nan;
    for (int i = 0; i < 3; i++) {
      LocationData gps = await Location.instance.getLocation();
      if (gps.latitude != null && gps.longitude != null) {
        latitude = gps.latitude!;
        longitude = gps.longitude!;
        break;
      }
    }
    try {
      await GaleriaController.instance
          .cadastrar(widget._imagem, latitude, longitude);
      Navigator.pop(context, true);
    } on Exception {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Erro"),
              content: Text("Não foi possível salvar a foto no banco de dados."),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ]);
        }
      );
    }
  }
}
