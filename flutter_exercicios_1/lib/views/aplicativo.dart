import 'package:flutter/material.dart';
import 'tela_principal.dart';

/*
1. Crie um projeto no Flutter e execute o “Hello World”;
2. Crie uma classe Aplicativo, que estende a classe StatelessWidget (slide 17) e
contém um MaterialApp (slide 34);
*/

class Aplicativo extends StatelessWidget {
  const Aplicativo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaPrincipal(),
      title: 'Aplicativo de Exemplo',
    );
  }
}
