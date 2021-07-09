import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fotomax {
  static const String _SHARED_FOTO = "foto_salva";
  static Fotomax? _instance;

  Uint8List? fotoSalva;
  Uint8List? novaFotoBytes;

  Fotomax._();

  factory Fotomax() {
    return Fotomax._instance ??= Fotomax._();
  }

  void setFoto(Uint8List foto) {
    this.novaFotoBytes = foto;
  }

  Uint8List? get foto => this.novaFotoBytes;

  Image? getFotoAsImage() {
    if (novaFotoBytes == null) return null;
    return Image.memory(novaFotoBytes!);
  }

  String? getFotoAsString() {
    if (novaFotoBytes == null) return null;
    return base64Encode(novaFotoBytes!);
  }

  bool isFotoTirada() => novaFotoBytes != null;

  Future<String> getFotoPreferences() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    if (shared.containsKey(_SHARED_FOTO))
      return shared.getString(_SHARED_FOTO)!;
    return "";
  }

  Future<void> saveFotoPreferences(String fotoString) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString(_SHARED_FOTO, fotoString);
  }
}
