import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:vector_math/vector_math.dart' as VecMath;
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:location/location.dart';

/*
L2E1. Implemente um aplicativo contendo apenas uma tela que exiba todos os dados
  do Sensor e GPS;
L2E2. Crie um aplicativo no Flutter usando o pacote Location que exiba a distancia
  percorrida pelo usuário de 1 em 1 minuto. Utilize o método changeSettings()
  para alterar a quantidade tempo que os dados serão reenviados ao Flutter
  (lembre-se de que a API trabalha em milissegundos). Utilize também o
  Future.delayed() para trabalhar assincronamente com o tempo;
*/

class TelaSensores extends StatefulWidget {
  const TelaSensores({Key? key}) : super(key: key);
  static const String TEXT_UNAVAILABLE = "(não disp.)";
  static const int GPS_INTERVAL_MAX = 30000;

  @override
  _TelaSensoresState createState() => _TelaSensoresState();
  static instantiate() => TelaSensores();
}

class _TelaSensoresState extends State<TelaSensores> {
  AccelerometerEvent? acelerometro;
  UserAccelerometerEvent? acelerometroUsuario;
  GyroscopeEvent? giroscopio;
  LocationData? gps;
  List<StreamSubscription> inscricoes = [];
  double distancia = 0.0;
  double deltaDistance = 0.0;
  double? latitude, longitude;
  LocationAccuracy gpsAcuracia = LocationAccuracy.high;
  int gpsIntervalo = 3000;
  int distanciaIntervalo = 15000;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    inscricoes.add(accelerometerEvents.listen((event) {
      escutarAcelerometro(event);
    }));
    inscricoes.add(userAccelerometerEvents.listen((event) {
      escutarAcelerometroUsuario(event);
    }));
    inscricoes.add(gyroscopeEvents.listen((event) {
      escutarGiroscopio(event);
    }));
    inscricoes.add(Location.instance.onLocationChanged.listen((event) {
      escutarGPS(event);
    }));
    _updateConfigGPS();
    Future.delayed(Duration(milliseconds: distanciaIntervalo), updateDistancia);
  }

  void escutarAcelerometro(AccelerometerEvent evt) {
    setState(() {
      acelerometro = evt;
    });
  }

  void escutarAcelerometroUsuario(UserAccelerometerEvent evt) {
    setState(() {
      acelerometroUsuario = evt;
    });
  }

  void escutarGiroscopio(GyroscopeEvent evt) {
    setState(() {
      giroscopio = evt;
    });
  }

  void escutarGPS(LocationData evt) {
    if (evt.latitude != null && evt.longitude != null) {
      double latOld = latitude == null ? evt.latitude! : latitude!;
      double longOld = longitude == null ? evt.longitude! : longitude!;
      latitude = evt.latitude;
      longitude = evt.longitude;
      deltaDistance += calculateDistance(latitude, longitude, latOld, longOld);
    }
    setState(() {
      gps = evt;
    });
  }

  Future<void> updateDistancia() async {
    if (isDisposed) return;
    setState(() {
      distancia += deltaDistance;
      deltaDistance = 0;
    });
    Future.delayed(Duration(milliseconds: distanciaIntervalo), updateDistancia);
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
    for (StreamSubscription inscricao in inscricoes) {
      inscricao.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Painel de Sensores"),
          centerTitle: true,
        ),
        body: Column(children: [
          _telaLinha1(),
          _telaLinha2(),
          _telaLinha3(),
        ]));
  }

  Widget _telaLinha1() {
    return Expanded(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: _dadosAcelerometro()),
                Expanded(child: _dadosAcelerometroUsuario()),
                Expanded(child: _dadosGiroscopio()),
              ],
            )));
  }

  Widget _dadosAcelerometro() {
    AccelerometerEvent? dados = acelerometro;
    return Column(children: [
      Center(
          child: Text("Acelerometro",
              style: TextStyle(fontWeight: FontWeight.bold))),
      dados == null
          ? Center(child: Text("Carregando dados..."))
          : Text("x: ${dados.x.toStringAsFixed(5)}\n" +
              "y: ${dados.y.toStringAsFixed(5)}\n" +
              "z: ${dados.z.toStringAsFixed(5)}")
    ]);
  }

  Widget _dadosAcelerometroUsuario() {
    UserAccelerometerEvent? dados = acelerometroUsuario;
    return Column(children: [
      Center(
          child: Text("Acel. Usuário",
              style: TextStyle(fontWeight: FontWeight.bold))),
      dados == null
          ? Center(child: Text("Carregando dados..."))
          : Text("x: ${dados.x.toStringAsFixed(5)}\n" +
              "y: ${dados.y.toStringAsFixed(5)}\n" +
              "z: ${dados.z.toStringAsFixed(5)}")
    ]);
  }

  Widget _dadosGiroscopio() {
    GyroscopeEvent? dados = giroscopio;
    return Column(children: [
      Center(
          child: Text("Giroscópio",
              style: TextStyle(fontWeight: FontWeight.bold))),
      dados == null
          ? Center(child: Text("Carregando dados..."))
          : Text("x: ${VecMath.degrees(dados.x)}° / ${dados.x.toStringAsFixed(5)}\n" +
              "y: ${VecMath.degrees(dados.y)}° / ${dados.y.toStringAsFixed(5)}\n" +
              "z: ${VecMath.degrees(dados.z)}° / ${dados.z.toStringAsFixed(5)}")
    ]);
  }

  Widget _telaLinha2() {
    return Expanded(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [_dadosGPS()],
            )));
  }

  Widget _dadosGPS() {
    return Column(children: [
      Container(
          width: MediaQuery.of(context).size.width * 0.9,
          alignment: Alignment.center,
          child: Text("GPS", style: TextStyle(fontWeight: FontWeight.bold))),
      gps == null
          ? Center(child: Text("Carregando dados..."))
          : Center(child: Text("Hora local: " + _getTime())),
      Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 1),
              ),
            ),
            child: Text("altitude: ${_getAltitude()}" +
                "\nlatitude: ${_getLatitude()}" +
                "\nlongitude: ${_getLongitude()}" +
                "\nvelocidade: ${_getSpeed()}" +
                "\nac. vel.: ${_getSpeedAccuracy()}"),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Text("acurácia: ${_getAccuracy()}\n" +
                  "ac. vertical: ${_getVerticalAccuracy()}\n" +
                  "direção hor.: ${_getHeading()}\n" +
                  "ac. dir. hor.: ${_getHeadingAccuracy()}"))
        ],
      )
    ]);
  }

  String _getAltitude({int fixedPrecision = 2}) {
    if (gps != null && gps!.altitude != null)
      return gps!.altitude!.toStringAsFixed(fixedPrecision) + "°";
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  String _getLatitude({int fixedPrecision = 2}) {
    if (gps != null && gps!.latitude != null)
      return gps!.latitude!.toStringAsFixed(fixedPrecision) + "°";
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  String _getLongitude({int fixedPrecision = 2}) {
    if (gps != null && gps!.longitude != null)
      return gps!.longitude!.toStringAsFixed(fixedPrecision) + "°";
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  String _getAccuracy({int fixedPrecision = 2}) {
    if (gps != null && gps!.accuracy != null)
      return gps!.accuracy!.toStringAsFixed(fixedPrecision) + "°";
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  String _getTime() {
    if (gps != null && gps!.time != null)
      return DateTime.fromMillisecondsSinceEpoch(gps!.time!.toInt()).toString();
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  String _getVerticalAccuracy({int fixedPrecision = 2}) {
    if (gps != null && gps!.verticalAccuracy != null)
      return gps!.verticalAccuracy!.toStringAsFixed(fixedPrecision) + "°";
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  String _getHeading({int fixedPrecision = 2}) {
    if (gps != null && gps!.heading != null)
      return gps!.heading!.toStringAsFixed(fixedPrecision) + "°";
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  String _getHeadingAccuracy({int fixedPrecision = 2}) {
    if (gps != null && gps!.headingAccuracy != null)
      return gps!.headingAccuracy!.toStringAsFixed(fixedPrecision) + "°";
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  String _getSpeed({int fixedPrecision = 2}) {
    if (gps != null && gps!.speed != null)
      return gps!.speed!.toStringAsFixed(fixedPrecision) + " m/s";
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  String _getSpeedAccuracy({int fixedPrecision = 2}) {
    if (gps != null && gps!.speedAccuracy != null)
      return gps!.speedAccuracy!.toStringAsFixed(fixedPrecision) + " m/s";
    return TelaSensores.TEXT_UNAVAILABLE;
  }

  Widget _telaLinha3() {
    return Expanded(
      child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.amber[100],
          child: Row(
            children: [_painelGPS()],
          )),
    );
  }

  Widget _painelGPS() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        alignment: Alignment.center,
        child: Column(children: [
          Container(
              child: Text("Configurações GPS",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              margin: EdgeInsets.only(bottom: 10)),
          Row(
            children: [
              Expanded(
                  child: Column(children: [
                Text("Acurácia: ${_getGPSAcuracia()}"),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: (() {
                            _updateAcuracia(delta: -1);
                          }),
                          icon: Icon(Icons.remove_circle),
                          iconSize: 35,
                          color: Colors.red),
                      IconButton(
                          onPressed: (() {
                            _updateAcuracia(delta: 1);
                          }),
                          icon: Icon(Icons.add_circle),
                          iconSize: 35,
                          color: Colors.green),
                    ])
              ])),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Intervalo: " +
                                "${(this.gpsIntervalo / 1000.0).toStringAsFixed(2)} ms"),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: (() {
                                      _updateIntervalo(delta: -1);
                                    }),
                                    icon: Icon(Icons.remove_circle),
                                    iconSize: 35,
                                    color: Colors.red),
                                IconButton(
                                    onPressed: (() {
                                      _updateIntervalo(delta: 1);
                                    }),
                                    icon: Icon(Icons.add_circle),
                                    iconSize: 35,
                                    color: Colors.green),
                              ],
                            )
                          ]))),
            ],
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Column(children: [
                Text(
                    "Distância percorrida: ${this.distancia.toStringAsFixed(2)} metros"),
                Text("(Atualizado de 15 em 15 segundos)",
                    style: TextStyle(fontSize: 11)),
              ])),
        ]));
  }

  String _getGPSAcuracia() {
    switch (gpsAcuracia) {
      case LocationAccuracy.low:
        return "LOW";
      case LocationAccuracy.balanced:
        return "BALANCED";
      case LocationAccuracy.high:
        return "HIGH";
      default:
        return "?";
    }
  }

  void _updateAcuracia({required int delta}) {
    if (delta == 0) return;
    switch (gpsAcuracia) {
      case LocationAccuracy.low:
        if (delta > 0) gpsAcuracia = LocationAccuracy.balanced;
        break;
      case LocationAccuracy.balanced:
        if (delta < 0)
          gpsAcuracia = LocationAccuracy.low;
        else
          gpsAcuracia = LocationAccuracy.high;
        break;
      case LocationAccuracy.high:
        if (delta < 0) gpsAcuracia = LocationAccuracy.balanced;
        break;
      default:
        return;
    }
    _updateConfigGPS();
  }

  void _updateIntervalo({required int delta}) {
    if (delta == 0) return;
    if (delta > 0 && gpsIntervalo < TelaSensores.GPS_INTERVAL_MAX)
      gpsIntervalo += 1000;
    else if (delta < 0 && gpsIntervalo > 0) gpsIntervalo -= 1000;
    _updateConfigGPS();
  }

  void _updateConfigGPS() {
    Location.instance.changeSettings(
        accuracy: gpsAcuracia, interval: gpsIntervalo, distanceFilter: 0);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    double p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }
}
