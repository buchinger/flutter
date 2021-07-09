import 'package:flutter/material.dart';

/*
L3E1. Crie uma tela contendo dois botões (utilize a classe que quiser para um botão),
  um deles deve exibir uma caixa de diálogo contendo o número de vezes que a
  caixa de diálogo foi aberta e o outro contendo a data atual (utilize o construtor
  da classe DateTime.now());
*/

class Tela6 extends StatefulWidget {
  const Tela6({Key? key}) : super(key: key);
  static instantiate() => Tela6();

  @override
  _Tela6State createState() => _Tela6State();
}

class _Tela6State extends State<Tela6> {
  int clicks = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Tela 6 - Exercício L3#1")),
        body: Column(children: [botaoContador(), botaoHora()]));
  }

  Widget botaoContador() {
    return Expanded(
        child: Center(
            child: ElevatedButton(
                child: Text("Botão Contador"),
                onPressed: () => contadorPressed())));
  }

  Future<void> contadorPressed() async {
    setState(() {
      clicks++;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Contador de pressionamento:"),
              content: Text("Você clicou $clicks vezes neste botão"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Fechar"),
                ),
              ]);
        });
  }

  Widget botaoHora() {
    return Expanded(
        child: Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text("Ver Hora"),
                onPressed: () => showHora())));
  }

  void showHora() {
    DateTime agora = DateTime.now();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Hora de Brasília"),
              content: Text(
                  "${agora.day}/${agora.month}/${agora.year} - ${agora.hour}:${agora.minute}:${agora.second}"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Fechar"),
                ),
              ]);
        });
  }
}
