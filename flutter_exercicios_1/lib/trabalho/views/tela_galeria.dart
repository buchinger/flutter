import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/trabalho/controllers/galeria_controller.dart';
import 'package:flutter_exercicios_1/trabalho/views/tela_cadastro.dart';
import 'package:flutter_exercicios_1/trabalho/views/tela_foto.dart';
import 'package:flutter_exercicios_1/trabalho/models/foto.dart';
import 'package:image_picker/image_picker.dart';

class TelaGaleria extends StatefulWidget {
  const TelaGaleria({Key? key}) : super(key: key);
  static TelaGaleria instantiate() => TelaGaleria();

  @override
  _TelaGaleriaState createState() => _TelaGaleriaState();
}

class _TelaGaleriaState extends State<TelaGaleria> {
  bool loading = true;

  Future<void> carregar() async {
    await GaleriaController.instance.buscarFotos();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    GaleriaController.instance.abrirBD().whenComplete(carregar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Galeria de Fotos"),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _listaFotos(),
      floatingActionButton: FloatingActionButton(
        onPressed: _tirarFoto,
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _fotosListTile(int index) {
    Foto foto = GaleriaController.instance.fotos[index];
    return Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: InkWell(
            onTap: () {
              _gotoFoto(foto, index);
            },
            child: ListTile(
              title: Text(foto.titulo),
              subtitle: Text(
                  "Data: ${foto.data}\nLatitude: ${foto.latitude}\n" +
                      "Longitude: ${foto.longitude}"),
            )));
  }

  Widget _listaFotos() {
    return GaleriaController.instance.fotos.isEmpty
        ? Center(
            child: Text("Nao há fotos salvas ainda"),
          )
        : Container(
            margin: EdgeInsets.all(15),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _fotosListTile(index);
              },
              itemCount: GaleriaController.instance.fotos.length,
            ));
  }

  Future<void> _tirarFoto() async {
    ImagePicker picker = ImagePicker();
    PickedFile? novaFoto = await picker.getImage(source: ImageSource.camera);
    if (novaFoto != null) {
      Uint8List bytes = await novaFoto.readAsBytes();
      bool? retorno =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TelaCadastro(bytes);
      }));

      if (retorno != null && retorno) {
        setState(() {});
        SnackBar snackBar = SnackBar(
          content: Text("Nova foto adicionada"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> _gotoFoto(Foto foto, int index) async {
    bool? removed =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TelaFoto(foto, index);
      }));

      if (removed != null && removed) {
        setState(() {});
        SnackBar snackBar = SnackBar(
          content: Text("Foto removida com sucesso"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
  }
}
