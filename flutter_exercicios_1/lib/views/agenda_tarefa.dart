import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/controllers/lista_tarefas.dart';
import 'package:flutter_exercicios_1/models/tarefa.dart';

/*
L3E4. Crie um aplicativo usando o padrão MVC para uma lista de tarefas. Cada
  tarefa deve possui um nome e um status de concluído ou não. Crie funções no
  controller para que seja possível adicionar uma tarefa e remover uma tarefa. Na
  view, exiba a lista de tarefas usando o ListTile e o ListView, mostre o nome da
  tarefa e no trailing dois ícons de sua escolha, um para quando a tarefa estiver
  concluida e outro para quando a tarefa estiver pendente;
L3E5. Continuando o item anterior, coloque o ListTile dentro de um widget InkWell,
  utilize apenas o child (um Widget) e o onTap (uma função igual ao onPressed
  de botões), para que ao o usuário tocar na tarefa, ela mude altere seu status;
*/

class AgendaTarefa extends StatefulWidget {
  const AgendaTarefa({Key? key}) : super(key: key);
  static instantiate() => AgendaTarefa();

  @override
  _AgendaTarefaState createState() => _AgendaTarefaState();
}

class _AgendaTarefaState extends State<AgendaTarefa> {
  ListaTarefaController controller = ListaTarefaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Tarefas"),
          centerTitle: true,
        ),
        body: Column(children: [
          inputTarefa(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Divider(thickness: 2),
          ),
          outputTarefas()
        ]));
  }

  Widget inputTarefa() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text("Digite a descrição da tarefa:"),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(controller: controller.caixaTarefa),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(children: [
              Text("Tarefa concluida?   "),
              Switch(
                value: controller.switchCompleta,
                onChanged: (value) {
                  setState(() {
                    controller.switchCompleta = value;
                  });
                },
              )
            ])),
        Container(
            margin: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  try {
                    controller.addTarefa();
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

  Widget outputTarefas() {
    return Expanded(
        child: ListView.builder(
            itemBuilder: (context, index) {
              Tarefa tarefa = controller.getTarefa(index);
              return InkWell(
                child: ListTile(
                  leading: IconButton(
                      icon: Icon(tarefa.isConcluida
                          ? Icons.check_box
                          : Icons.watch_later_outlined),
                      onPressed: () => {}),
                  title: Text("Tarefa: ${tarefa.nome}"),
                  trailing: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        controller.removeTarefa(index);
                      });
                      SnackBar snackbar = SnackBar(
                          content: Text("Tarefa removida!"),
                          action: SnackBarAction(
                              label: "OK",
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                              }));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }),
                ),
                onTap: () => setState(() {
                    if (tarefa.isConcluida)
                      tarefa.setPendente();
                    else
                      tarefa.setConcluida();
                  }
              ));
            },
            itemCount: controller.tarefasLenght()));
  }
}
