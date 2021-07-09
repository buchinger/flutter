import 'package:flutter/material.dart';
import 'package:flutter_exercicios_1/controllers/lista_pessoas.dart';

class TelaBD extends StatefulWidget {
  const TelaBD({Key? key}) : super(key: key);
  static TelaBD instantiate() => TelaBD();

  @override
  _TelaBDState createState() => _TelaBDState();
}

class _TelaBDState extends State<TelaBD> {
  ListaPessoasController controller = ListaPessoasController();
  bool loading = true;

  Future<void> carregar() async {
    await controller.buscarBanco();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    controller.abrirBD().whenComplete(carregar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Pessoas"),
        centerTitle: true,
      ),
      body: loading
        ? Center(
          child: CircularProgressIndicator(),
        )
        : _divideTelaEmDuas(),
    );
  }

  Widget _divideTelaEmDuas(){
    return Column( children: [
      _label(),
      _caixa(),
      _botao(),
      _divisor(),
      _lista(),
    ]);
  }

  Widget _label() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20),
      child: Row( children: [Text('Digite o nome:')], ),
    );
  }

  Widget _caixa() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextField( controller: controller.nomeController, ),
      ),
    );
  }

  Widget _botao() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: ElevatedButton(
        onPressed: _cadastrarPessoa,
        child: Text('Salvar'),
      ),
    );
  }

  Widget _divisor() {
    return Divider(
      thickness: 2,
      height: 1,
    );
  }

  Widget _pessoasWidget(int index) {
    return ListTile(
      title: Text(controller.listaPessoas[index].nome!),
      trailing: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () { _removerPessoa(index); },
      ),
    );
  }

  Widget _lista() {
    return controller.listaPessoas.isEmpty
      ? Expanded(
        flex: 7,
        child: Center(
          child: Text("Nao há pessoas na lista"),
        ),
      )
      : Flexible(
        flex: 7,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _pessoasWidget(index);
          },
          itemCount: controller.listaPessoas.length,
        ),
      );
  }

  void _cadastrarPessoa() {
    controller.cadastrar().whenComplete((){
      carregar();
    });
  }

  void _removerPessoa(int index) {
    controller.remover(index).whenComplete(() {
      setState(() {});
    });
  }
}
