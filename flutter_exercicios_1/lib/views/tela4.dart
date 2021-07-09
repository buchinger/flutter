import 'package:flutter/material.dart';

/*
1. Crie uma aplicação Flutter contendo uma Scaffold que possua uma AppBar
  contendo um título centralizado escrito “Exercício 1” e um body contendo um
  Column exibindo os números de 0 a 10;
2. Altere o item anterior para utilizar um ListView que exiba uma lista
  “valores”, sendo essa lista um atributo da classe. Utilize o contrutor
  ListView.builder() para isso.
3. A partir do item anterior, crie uma função adiciona() que adiciona um valor na
  lista “valores” e redesenha a tela. Adicione um FloatingActionButton ao
  Scaffold contendo a função adiciona()
4. Continuando o item anterior, adicione um TextField acima da ListView (utilize
  um Column no body do Scaffold) e altere a função adiciona() para que ela salve
  o valor digitado do usuário na lista de valores, limpando o TextField ao final.
*/

class Tela4 extends StatefulWidget {
  const Tela4({Key? key}) : super(key: key);
  static instantiate() => Tela4();

  @override
  _Tela4State createState() => _Tela4State();
}

class _Tela4State extends State<Tela4> {
  List<String> valores = ["Exemplo"];
  TextEditingController textController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Tela 4 - Exercício L2#1")),
        body:
            /* Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Center(child: Text("1"))),
            Expanded(child: Center(child: Text("2"))),
            Expanded(child: Center(child: Text("3"))),
            Expanded(child: Center(child: Text("4"))),
            Expanded(child: Center(child: Text("5"))),
          ]),
        */
            Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: valores.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(child: Text("${valores[index]}"));
                  })),
          Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.amber[200],
                  child: Center(
                      child: TextField(
                          decoration: InputDecoration(
                              labelText: "Digite um novo valor para a lista:"),
                          keyboardType: TextInputType.text,
                          controller: textController))))
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_box_rounded),
          onPressed: addValor,
          tooltip: "Adiciona próximo valor",
        ));
  }

  Future<void> addValor() async {
    if (textController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Ops!"),
              content: Text(
                  "Nenhum texto foi digitado. Digite algum valor para adicionar à lista"),
              actions: [
                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return;
    }
    setState(() {
      valores.add(textController.text);
      textController.clear();
      SnackBar snackBar = SnackBar(
          content: Text("Novo valor adicionado!"),
          action: SnackBarAction(
            label: 'ok',
            onPressed: () {},
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
