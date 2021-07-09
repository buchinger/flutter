import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/models/pair.dart';

/*
8. Crie uma classe Tela3, substitua-a no MaterialApp do item anterior. A classe
  Tela3 deve conter apenas um botão e um Container no body do Scaffold, tal
  botão deve alternar a cor do Container a partir de um grupo definido de cores
  (utilize ao menos três cores). No título da AppBar deve-se estar escrito o nome
  da cor que está pintado o body;
*/

class Tela3 extends StatefulWidget {
  const Tela3({Key? key}) : super(key: key);
  static instantiate() => Tela3();

  @override
  _Tela3State createState() => _Tela3State();
}

class _Tela3State extends State<Tela3> {
  int _layoutIndex = 0;
  List<Pair<String, Color>> _layout = [
    Pair('Amber', Colors.amber.shade200),
    Pair('Ciano', Colors.cyan.shade100),
    Pair('Roxo Claro', Colors.purple.shade100),
    Pair('Verde Claro', Colors.lightGreen.shade200),
    Pair('Prata', Color(0xffc0c0c0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela ${_layout[_layoutIndex].first}")),
      body: Container(color: _layout[_layoutIndex].second),
      floatingActionButton: FloatingActionButton(
          onPressed: _changeLayout,
          tooltip: "Altera para o próximo layout",
          child: Icon(Icons.color_lens)),
    );
  }

  Future<void> _changeLayout() async {
    setState(() {
      _layoutIndex++;
      if (_layoutIndex >= _layout.length) _layoutIndex = 0;
    });
  }
}
