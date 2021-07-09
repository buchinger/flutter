import 'package:flutter/material.dart';

/*
5. Replicar tela da figura do slide
*/

class Tela5 extends StatefulWidget {
  const Tela5({Key? key}) : super(key: key);
  static instantiate() => Tela5();

  @override
  _Tela5State createState() => _Tela5State();
}

class _Tela5State extends State<Tela5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Tela 5 - Exercício L2#5")),
        body: Column(children: [linha1(), linha2(), linha3()]));
  }

  Widget linha1() {
    double hValue = MediaQuery.of(context).size.height * 0.25;
    return Row(
      children: [
        Expanded(child: Container(height: hValue, color: Colors.red[200])),
        Expanded(child: Container(height: hValue, color: Colors.green[100])),
        Expanded(
            child: Container(height: hValue, color: Colors.cyanAccent[100])),
      ],
    );
  }

  Widget linha2() {
    double hValue = MediaQuery.of(context).size.height * 0.25;
    return Row(
      children: [
        Flexible(
            flex: 2,
            child: Container(height: hValue, color: Colors.purple[100])),
        Flexible(
            flex: 1,
            child: Container(height: hValue, color: Colors.orange[200])),
      ],
    );
  }

  Widget linha3() {
    double hValue = MediaQuery.of(context).size.height * 0.5 - 80;
    double wValue = MediaQuery.of(context).size.width * 0.667;
    return Row(children: [
      Flexible(
          flex: 1, child: Container(height: hValue, color: Colors.yellow[200])),
      Flexible(
          flex: 2,
          child: Column(children: [
            Container(
                width: wValue, height: hValue / 2, color: Colors.purple[100]),
            Row(children: [
              Expanded(
                  child:
                      Container(height: hValue / 2, color: Colors.green[100])),
              Expanded(
                  child:
                      Container(height: hValue / 2, color: Colors.orange[100]))
            ])
          ])),
    ]);
  }
}
