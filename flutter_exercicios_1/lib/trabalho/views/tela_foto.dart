import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/trabalho/controllers/galeria_controller.dart';
import 'package:flutter_exercicios_1/trabalho/models/foto.dart';

class TelaFoto extends StatefulWidget {
  final Foto _foto;
  final int _index;

  const TelaFoto(this._foto, this._index);

  @override
  _TelaFotoState createState() => _TelaFotoState();
}

class _TelaFotoState extends State<TelaFoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._foto.titulo),
        centerTitle: true,
      ),
      body: Container(margin: EdgeInsets.all(20), child: _dadosFoto()),
    );
  }

  Widget _dadosFoto() {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(bottom: 10),
          child: _showComentario(),
        ),
        Divider(thickness: 1, color: Colors.grey),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: _showFoto(),
        ),
        Container(
            margin: EdgeInsets.only(top: 25),
            alignment: Alignment.topLeft,
            child: _showData()),
        Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.topLeft,
            child: _showCoordenadas()),
        Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text("Remover"),
                  onPressed: _questionarExclusao,
                )))
      ],
    );
  }

  Widget _showFoto() {
    Uint8List bytes =
        GaleriaController.instance.decoder.convert(widget._foto.imagem);
    return Image.memory(bytes);
  }

  Widget _showComentario() {
    return Column(children: [
      Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Comentário:",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          )),
      Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 7),
          child: Text(widget._foto.comentario)),
    ]);
  }

  Widget _showData() {
    return Row(children: [
      Text("Data: ",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      Text(widget._foto.data),
    ]);
  }

  Widget _showCoordenadas() {
    return Column(children: [
      Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Coordenadas:",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          )),
      Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: 15),
        child: Row(children: [
          Text("Latitude: "),
          Text(widget._foto.latitude.toStringAsFixed(7))
        ]),
      ),
      Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: 15),
        child: Row(children: [
          Text("Longitude: "),
          Text(widget._foto.longitude.toStringAsFixed(7))
        ]),
      ),
    ]);
  }

  Future<void> _questionarExclusao() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Excluir Foto"),
              content:
                  Text("Você realmente deseja excluir este registro de foto?"),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  ),
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text("Remover"),
                  onPressed: () {
                    Navigator.pop(context);
                    _excluirFoto();
                  },
                ),
              ]);
        });
  }

  Future<void> _excluirFoto() async {
    try {
      await GaleriaController.instance.remover(widget._index);
      Navigator.pop(context, true);
    } on Exception {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Erro"),
                content:
                    Text("Não foi possível excluir a foto no banco de dados."),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ]);
          });
    }
  }
}
