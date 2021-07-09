import 'package:flutter/material.dart';
import 'tela_login.dart';

class TelaPosLogin extends StatelessWidget {
  static instantiate() => TelaPosLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Sistema Super Secreto"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: (){ doLogout(context); }
          ),
        ],
      ),
      body:
          Center(child: Text("Bem vindo soldado!")),
    );
  }


  void doLogout(BuildContext context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context){ return TelaLogin(); })
    );
  }
}
