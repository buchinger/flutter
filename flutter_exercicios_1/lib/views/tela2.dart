import 'package:flutter/material.dart';

/*
5. Crie uma classe Tela2 contendo um Scaffold com dois IconsButtons na AppBar
  no atributo actions, além de um Text contendo um contador no body do
  Scaffold, um dos botões da AppBar deve incrementar o valor do contador e o
  outro deve decrementar o valor do contador. Altere a classe MaterialApp dos
  exercícios anteriores para que o atributo home agora seja uma instancia da Tela2;
6. Adicione na Tela2 um FloatingActionButton na esquerda que deve zerar o valor
  do contador.
7. Adicione um TextField com um teclado numérico no atributo title da Tela2.
  Altere os botões que incrementam e decrementam, para que usem o valor da
  TextField para aumentar ou reduzir o valor do contador;
*/

class Tela2 extends StatefulWidget {
  const Tela2({Key? key}) : super(key: key);
  static instantiate() => Tela2();

  @override
  _Tela2State createState() => _Tela2State();
}

class _Tela2State extends State<Tela2> {
  int valor = 0;
  Color valorCor = Colors.grey;
  TextEditingController valorAtualizador = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
            controller: valorAtualizador,
            decoration:
                InputDecoration(labelText: "Digite o valor atualizador:"),
            keyboardType: TextInputType.number),
        backgroundColor: Colors.green.shade500,
        actions: [
          IconButton(
              onPressed: _onPlusButtonPressed,
              icon: Icon(Icons.add_circle),
              color: Colors.red.shade200),
          IconButton(
              onPressed: _onMinusButtonPressed,
              icon: Icon(Icons.remove_circle),
              color: Colors.blue.shade200)
        ],
      ),
      body: Container(
          alignment: Alignment.center,
          child: Text(
            "$valor",
            style: TextStyle(color: valorCor, fontSize: 35),
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _onResetButtonPressed,
        tooltip: "Reinicia o contador numérico",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> _onResetButtonPressed() async {
    setState(() {
      valor = 0;
      updateValorLayout();
    });
  }

  Future<void> _onPlusButtonPressed() async {
    setState(() {
      int incrementador = int.parse(valorAtualizador.text);
      valor += incrementador;
      updateValorLayout();
    });
  }

  Future<void> _onMinusButtonPressed() async {
    setState(() {
      int decrementador = int.parse(valorAtualizador.text);
      valor -= decrementador;
      updateValorLayout();
    });
  }

  void updateValorLayout() {
    if (valor < 0)
      valorCor = Colors.blue.shade400;
    else if (valor > 0)
      valorCor = Colors.red.shade400;
    else
      valorCor = Colors.grey;
  }
}
