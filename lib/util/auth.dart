
import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shopitrack/pages/login_page.dart';
import 'package:shopitrack/util/services.dart';
import 'package:flutter/cupertino.dart';

class Auth {
  Auth ._internal();
  static Auth _instance = Auth._internal();
  static Auth get instance => _instance;

  final _storage = FlutterSecureStorage();
  final key = "SESSIONSHOPITRACK";

  //Completer _completer = Completer();

  Future<Session?> get accessToken async {
    //print('completer $_completer');
    //if (_completer != null)
      //await _completer.future;
    print("AccessToken");
    //_completer = Completer();
    final Session? session = await this.getSession();
    if (session != null){
      final DateTime currentDate = DateTime.now();
      final DateTime createdAt = session.createdAt;
      final int expiresIn = session.expiresIn;
      final int diff = currentDate.difference(createdAt).inSeconds;
      //print("time ${expiresIn - diff}");
      if (expiresIn - diff >= 60) {
        print("token alive");
        //_completer.complete();
        return session;
      }
      else {
        print("refresh token");
        final Map<String, dynamic>? response = await Services.instance.enviaSolicitud('refreshToken', {'userId': session.token});
        if (response != null && response['codigo']==0){
          await this.setSession(response);
          //_completer.complete();
          return Session.fromJson(response);
        }
        //_completer.complete();
        return null;
      }
    }
    //_completer.complete();
    print("session null");
    return null;
  }

  Future<void> setSession(Map<String, dynamic> data) async {
    final Session session = Session(
      nombre: data["nombre"],
      token: data["token"],
      expiresIn: data["expiresIn"],
      createdAt: DateTime.now(),
      imagen: data["imagen"],
      code: data["code"],
    );
    final String value = jsonEncode(session.toJson());
    await this._storage.write(key: key, value: value);
    print("session saved");
  }

  Future<Session?> getSession() async {
    final String? value = await this._storage.read(key: key);
    if (value != null){
      final Map<String, dynamic> json = jsonDecode(value);
      print(json);
      final session = Session.fromJson(json);
      return session;
    }
    return null;
  }

  Future<void> logOut(BuildContext context) async {
    await this._storage.deleteAll();
    Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (_)=>false);
  }
}

class Session {
  final String nombre;
  final String token;
  final int expiresIn;
  final DateTime createdAt;
  final String imagen;
  final String code;

  Session({
    required this.nombre,
    required this.token,
    required this.expiresIn,
    required this.createdAt,
    required this.imagen,
    required this.code,
  });

  static Session fromJson(Map<String, dynamic> json){
    return Session(
        nombre: json["nombre"],
        token: json["token"],
        expiresIn: json["expiresIn"],
        createdAt: json["createdAt"]==null ? DateTime.now() : DateTime.parse(json["createdAt"]),
        imagen: json["imagen"],
        code: json["code"]==null ? "" : json["code"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nombre": this.nombre,
      "token": this.token,
      "expiresIn": this.expiresIn,
      "createdAt": this.createdAt.toString(),
      "imagen": this.imagen,
      "code": this.code,
    };
  }
}
