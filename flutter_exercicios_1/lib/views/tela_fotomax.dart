import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/controllers/fotomax.dart';

class TelaFotomax extends StatefulWidget {
  static String _fotoEncoded = "";

  TelaFotomax(String fotoEncoded) {
    TelaFotomax._fotoEncoded = fotoEncoded;
  }

  @override
  _TelaFotomaxState createState() => _TelaFotomaxState();
}

class _TelaFotomaxState extends State<TelaFotomax> {
  Fotomax controller = Fotomax();
  String fotoEncoded = "";

  @override
  void initState() {
    fotoEncoded = TelaFotomax._fotoEncoded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Tela 6 - Exercício L3#1")),
        body: Container(
            margin: EdgeInsets.all(15),
            child: Column(children: [
              Center(
                child: Text("Foto"),
              ),
              getFoto(),
              Center(
                  child: ElevatedButton(
                child: Text("Salvar Foto"),
                onPressed: () {
                  saveFoto(context);
                },
              ))
            ])));
  }

  Widget getFoto() {
    if (fotoEncoded == "") return Text("Ops... nenhuma foto foi encontrada");
    Uint8List bytes = base64Decode(fotoEncoded);
    return Image.memory(bytes);
  }

  Future<void> saveFoto(BuildContext context) async {
    await controller.saveFotoPreferences(fotoEncoded);
    Navigator.pop(context, true);
  }
}
