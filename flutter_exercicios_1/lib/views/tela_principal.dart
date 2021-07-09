import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/models/pair.dart';
import 'package:flutter_exercicios_1/views/tela5.dart';
import 'clicker.dart';
import 'tela_inicial.dart';
import 'tela2.dart';
import 'tela3.dart';
import 'tela4.dart';
import 'tela5.dart';
import 'tela6.dart';
import 'agenda.dart';
import 'agenda_tarefa.dart';
import 'tela_login.dart';
import 'tela_fotografo.dart';
import 'tela_sensores.dart';
import 'tela_bd.dart';
import '../trabalho/views/tela_galeria.dart';


class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  static final List<Pair<String, dynamic>> telas = [
    Pair('Clicker', Clicker.instantiate),
    Pair('Tela Inicial', TelaInicial.instantiate),
    Pair('Personal Clicker', Tela2.instantiate),
    Pair('Tela de Cores', Tela3.instantiate),
    Pair('Lista de Valores', Tela4.instantiate),
    Pair('Mosaico de Cores', Tela5.instantiate),
    Pair('Contador & Hora Agora', Tela6.instantiate),
    Pair('Agenda Telefonica', Agenda.instantiate),
    Pair('Agenda de Tarefas', AgendaTarefa.instantiate),
    Pair('Sistema Super Secreto', TelaLogin.instantiate),
    Pair('Sistema Fotografia', TelaFotografo.instantiate),
    Pair('Painel de Sensores', TelaSensores.instantiate),
    Pair('Exemplo BD', TelaBD.instantiate),
    Pair('Galeria de Fotos', TelaGaleria.instantiate),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplicativos Exemplos/Exercícios"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Pair par = TelaPrincipal.telas[index];
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                child: Text(par.first),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return par.second();
                })),
              ));
        },
        itemCount: telas.length,
      ),
    );
  }
}
