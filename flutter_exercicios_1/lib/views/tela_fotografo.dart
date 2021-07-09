import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/controllers/fotomax.dart';
import 'package:image_picker/image_picker.dart';
import 'tela_fotomax.dart';

/*
L1E1. Crie uma aplicativo usando o pacote Image Picker que possua duas telas, na
  primeira delas deve haver um botão que permita o usuário tirar uma foto e vê-la
  na tela. Além da foto, deve haver um botão de navegar para outra tela. Tal
  botão deve fazer o encode da imagem para uma String e passar para o
  construtor da outra tela tal String. Nessa outra tela, ao entrar nela, a String
  passada no construtor deve sofrer decode e a imagem deve ser exibida na tela.
L1E2. Adicione ao código do item anterior, um botão na segunda tela que permita o
  usuário salvar a foto usando o Shared Preferences. Faça com que o aplicativo
  exiba a foto salva na primeira tela sempre que o aplicativo for aberto
*/

class TelaFotografo extends StatefulWidget {
  const TelaFotografo({Key? key}) : super(key: key);
  static instantiate() => TelaFotografo();

  @override
  _TelaFotografoState createState() => _TelaFotografoState();
}

class _TelaFotografoState extends State<TelaFotografo> {
  Fotomax controller = Fotomax();
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Tela 6 - Exercício L3#1")),
        body: Column(children: [
          showFotoSalva(),
          Divider(thickness: 5),
          showFotoAtual(),
          showControlPanel(),
        ]));
  }

  Widget showFotoSalva() {
    return Container(
        child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Foto Salva"),
                getFotoSalva(),
              ],
            )));
  }

  Widget getFotoSalva() {
    return FutureBuilder(
        future: controller.getFotoPreferences(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == "")
              return Center(child: Text("Nenhuma foto salva ainda"));
            else {
              Uint8List bytes = base64Decode(snapshot.data!);
              return Image.memory(bytes, height: 200);
            }
          } else {
            return Center(child: Text("Carregando..."));
          }
        });
  }

  Widget showFotoAtual() {
    return Container(
        child: Container(
            margin: EdgeInsets.all(20),
            child: Column(children: [
              Text("Foto Atual"),
              Container(child: getFotoAtual()),
            ])));
  }

  Widget getFotoAtual() {
    Uint8List? fotoBytes = controller.foto;
    if (fotoBytes != null) {
      return Image.memory(fotoBytes, height: 200, fit: BoxFit.fitHeight);
    }
    return Text("Nenhuma foto foi capturada ainda...");
  }

  Widget showControlPanel() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  child: Text("Câmera"),
                  onPressed: irCamera,
                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                  child: Icon(Icons.send),
                  onPressed: controller.isFotoTirada() ? goToFotomax : null),
            )
          ],
        ));
  }

  Future<void> irCamera() async {
    PickedFile? novaFoto = await picker.getImage(source: ImageSource.camera);
    if (novaFoto != null) {
      Uint8List bytes = await novaFoto.readAsBytes();
      setState(() {
        controller.setFoto(bytes);
      });
    }
  }

  Future<void> goToFotomax() async {
    String? foto = controller.getFotoAsString();
    if (foto == null) return;
    bool? retorno =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TelaFotomax(foto);
    }));

    if (retorno != null && retorno) setState(() {});
  }
}
