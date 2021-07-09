import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/controllers/lista_telefonica.dart';
import 'package:flutter_exercicios_1/models/contato.dart';

/*
L3E2. Adapte o código dos exemplos, para que quando o usuário remova um objeto,
  uma Snackbar apareça confirmando que o objeto foi removido;
L3E3. Adapte o código dos exemplos, para que quando o usuário digitar um nome
  contendo algum número, uma exceção seja lançada pelo controller e a view
  trate essa exceção mostrando uma caixa de diálogo informando que o nome não
  pode conter números;
*/

class Agenda extends StatefulWidget {
  const Agenda({Key? key}) : super(key: key);

  @override
  _AgendaState createState() => _AgendaState();
  static instantiate() => Agenda();
}

class _AgendaState extends State<Agenda> {
  ListaTelefonicaController controller = ListaTelefonicaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista Telefonica"),
          centerTitle: true,
        ),
        body: Column(children: [
          inputContato(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Divider(thickness: 2),
          ),
          outputContatos()
        ]));
  }

  Widget inputContato() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text("Digite o nome:"),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(controller: controller.caixaNome),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text("Digite o telefone:"),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
              controller: controller.caixaTelefone,
              keyboardType: TextInputType.phone),
        ),
        Container(
            margin: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  try {
                    controller.addContato();
                  } on FormatException catch (e) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text("Erro"),
                              content: Text(e.message),
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
                });
              },
              child: Text("Cadastrar"),
            )),
      ],
    );
  }

  Widget outputContatos() {
    return Expanded(
        child: ListView.builder(
            itemBuilder: (context, index) {
              Contato contato = controller.getContato(index);
              return ListTile(
                title: Text("Nome: ${contato.nome}"),
                subtitle: Text("Telefone: ${contato.telefone}"),
                trailing: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        controller.removeContato(index);
                      });
                      SnackBar snackbar = SnackBar(
                          content: Text("Contato removido!"),
                          action: SnackBarAction(
                              label: "OK",
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                              }));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }),
              );
            },
            itemCount: controller.listaContatos.length));
  }
}
