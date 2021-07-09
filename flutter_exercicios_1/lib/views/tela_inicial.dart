import 'package:flutter/material.dart';

/*
3. Crie uma classe TelaInicial que estende a classe StatefulWidget (slide 23) e
  contém um Scaffold (slide 37). Adicione ao Scaffold uma AppBar (slide 42)
  contendo uma Text (slide 51) centralizado informando o nome da tela: “Tela
  Inicial”.
4. Na classe TelaInicial do exercício anterior, adicione um IconButton (slide 55),
  contendo um ícone (slide 54) de sua escolha e uma função que faça com que o
  titulo hora apareça, hora desapareça;
*/

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);
  static instantiate() => TelaInicial();

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  bool tituloVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading:
              Icon(Icons.account_balance_outlined, color: Colors.blue[200]),
          title: Text(tituloVisible ? "Tela Inicial" : "")),
      floatingActionButton: IconButton(
        icon: Icon(Icons.swap_horizontal_circle_outlined),
        color: Colors.red,
        onPressed: _onPressSwapButton,
        tooltip: "Faz o título aparecer ou desaparecer",
      ),
    );
  }

  Future<void> _onPressSwapButton() async {
    setState(() {
      tituloVisible = !tituloVisible;
    });
  }
}
