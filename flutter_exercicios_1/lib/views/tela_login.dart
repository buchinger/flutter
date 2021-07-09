import 'package:flutter/material.dart';
import 'tela_pos_login.dart';

/*
L4E1. Crie duas classes TelaLogin e TelaInicial, a classe TelaLogin deve possuir
  duas caixas de texto (login e senha) e um botão, a ação do botão deve navegar
  para a TelaInicial apenas se o usuário digitar o usuário e a senha correta.
  Utilize o método pushReplacement() para avançar da TelaLogin para a TelaInicial.
L4E2. Modifique o código do item anterior para incluir um botão de logout na
  classe TelaInicial, tal botão deve levar o usuário de volta para a TelaLogin;
*/

class TelaLogin extends StatefulWidget {
  static instantiate() => TelaLogin();

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  TextEditingController inputLogin = TextEditingController();

  TextEditingController inputSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Login"),
        centerTitle: true
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  "Sistema Super Secreto",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )
              ),
            ),
            TextField(
              controller: inputLogin,
              decoration:
                  InputDecoration(labelText: "Digite seu login:"),
              keyboardType: TextInputType.text
            ),
            TextField(
              controller: inputSenha,
              decoration:
                  InputDecoration(labelText: "Digite sua senha:"),
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            ElevatedButton(
              child: Text("Login"),
              onPressed: (){ doLogin(context); },
            )
          ]
        )
      )
    );
  }

  void doLogin(BuildContext context){
    if (inputLogin.text == 'admin' && inputSenha.text == 'admin'){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context){ return TelaPosLogin(); })
      );
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Dados inválidos"),
              content: Text("Combinação de login e senha inválida"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    inputSenha.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ]
          );
        }
      );
    }
  }
}
