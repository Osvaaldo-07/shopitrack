import 'dart:convert';
import 'dart:io' show Platform;
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:intl/intl.dart';
import 'package:shopitrack/models/Parametros.dart';
// import 'package:shopitrack/pages/confirmacion2dias.dart';
import 'package:shopitrack/util/services.dart';

import '../main.dart';
import 'auth.dart';
import 'dialogs.dart';

class Util {
  static String _platform = 'ios';
  static String firebase = '';
  static bool _badger = false;
  /*static encrypt.Key key1 = encrypt.Key.fromUtf8('0-_GN Systems_-00-_GN Systems_-0');
  static encrypt.Key key2 = encrypt.Key.fromUtf8('-Black  Byte SC--Black  Byte SC-');
  static encrypt.Key key3 = encrypt.Key.fromUtf8('MXD Solutions SCMXD Solutions SC');*/
  static encrypt.Key key1 = encrypt.Key.fromUtf8('0-_GN Systems_-0');
  static encrypt.Key key2 = encrypt.Key.fromUtf8('-Black  Byte SC-');
  static encrypt.Key key3 = encrypt.Key.fromUtf8('MXD Solutions SC');

  static const String ORDEN_PROGRAMADA = 'Programada';
  static const String ORDEN_REPROGRAMADA = 'Re Programada';
  static const String ORDEN_SIGUIENTE = 'Siguiente Entrega';
  static const String ORDEN_ENTREGADA = 'Entregada';
  static const String ORDEN_RECOGIDA = 'Recogida';
  static const String ORDEN_FALLIDO = 'Intento Fallido';
  static const String ORDEN_ENRUTA = 'En Ruta';
  static const String ORDEN_CANCELADA = 'Cancelada';
  static const String ORDEN_REPROGRAMADA_USUARIO = 'Re Programada por Usuario';
  static const String ORDEN_RETRASO = 'Retraso';

  static const int INICIA_RUTA = 1;
  static const int EN_RUTA = 2;
  static const int FIN_RUTA = 3;

  static String get platform => _platform;
  static bool get badger => _badger;

  // static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // ignore: unnecessary_getters_setters
  //static String get firebase => _firebase;
  //static set firebase(String firebase) => _firebase = firebase;

  static Future<XFile?> pickImage(bool fromCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    //final PickedFile? file = await picker.getImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    return file;
  }

  static String getFilename(String path) => basename(path);

  static String base64Encode(List<int> bytes) => base64.encode(bytes);

  static Future<void> detectPlatform() async {
    try {
      //String userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      //print('userAgent detectado: $userAgent');
      //userAgent = userAgent.toUpperCase();
      //_platform = userAgent.contains('ANDROID') ? 'android' : 'ios';
      _platform = Platform.isAndroid ? 'android' : 'ios';
    }
    on PlatformException {
      _platform = 'iOS';
    }
    on MissingPluginException {
      _platform = 'iOS';
    }
  }

  // static Future<void> initPlatformBadger() async {
  //   try {
  //     bool res = await FlutterAppBadger.isAppBadgeSupported();
  //     if (res)
  //       _badger = true; //'Supported';
  //     else
  //       _badger = false; //'Not supported';
  //   }
  //   on PlatformException {
  //     _badger = false; //'Failed to get badge support.';
  //   }
  // }

  static String encripta(String text, int key){
    final iv = encrypt.IV.fromLength(16);
    //final iv = encrypt.IV.fromUtf8('1234567812345678');
    encrypt.Key typeKey = key==1 ? key1 : key==2 ? key2 : key3;
    final encrypter = encrypt.Encrypter(encrypt.AES(typeKey, mode: encrypt.AESMode.cbc));
    return encrypter.encrypt(text, iv:iv).base64;
  }

  static String desencripta(String text, int key){
    final iv = encrypt.IV.fromLength(16);
    encrypt.Key typeKey = key==1 ? key1 : key==2 ? key2 : key3;
    final encrypter = encrypt.Encrypter(encrypt.AES(typeKey, mode: encrypt.AESMode.cbc));
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(text), iv: iv);
  }

  static String getToken(String text) {
    String fecha = DateFormat("yyyyddMM").format(DateTime.now());
    print(text+'_'+fecha);
    var bytes = utf8.encode(text + fecha);
    //print(bytes);
    //return crypto.md5.convert(bytes).toString();
    Hash hasher = md5;
    return hasher.convert(bytes).toString();
  }

  static int? intValidator(String value) {
    //if(value == null)
      //return null;
    final int? num = int.tryParse(value);
    if(num == null)
      return null;
    return num;
  }

  static bool isValidDate(String date, String format) {
    try {
      int day=0, month=0, year=0;
      //Get separator data  10/10/2020, 2020-10-10, 10.10.2020
      String separator = RegExp("([-/.])").firstMatch(date)!.group(0)![0];
      //Split by separator [mm, dd, yyyy]
      var frSplit = format.split(separator);
      //Split by separtor [10, 10, 2020]
      var dtSplit = date.split(separator);
      for (int i = 0; i < frSplit.length; i++) {
        var frm = frSplit[i].toLowerCase();
        var vl = dtSplit[i];
        if (frm == "dd")
          day = int.parse(vl);
        else if (frm == "mm")
          month = int.parse(vl);
        else if (frm == "yyyy")
          year = int.parse(vl);
      }
      //First date check
      //The dart does not throw an exception for invalid date.
      var now = DateTime.now();
      if(month > 12 || month < 1 || day < 1 || day > daysInMonth(month, year) || year < 1810 || (year > now.year && day > now.day && month > now.month))
        throw Exception("Date birth invalid.");
      return true;
    }
    catch (e) {
      return false;
    }
  }

  static int daysInMonth(int month, int year) {
    int days = 28 + (month + (month/8).floor()) % 2 + 2 % month + 2 * (1/month).floor();
    return (isLeapYear(year) && month == 2)? 29 : days;
  }

  static bool isLeapYear(int year) => (( year % 4 == 0 && year % 100 != 0 ) || year % 400 == 0 );

  // static Future<void> adminNotificacionesSession() async {
  //   if (Util.badger){
  //     Session? session = await Auth.instance.accessToken;
  //     int cont = 0;
  //     if (session != null) {
  //       if (session.token.endsWith("U")) {
  //         Map<String, dynamic>? response = await Services.instance.enviaSolicitud('getCountNotificaciones', {'userId': session.token}, null);
  //         print(response);
  //         if (response != null) {
  //           if (response['codigo'] == 0) {
  //             cont = int.tryParse(response['mensaje'])!;
  //             if (cont > 0)
  //               FlutterAppBadger.updateBadgeCount(cont);
  //             else
  //               FlutterAppBadger.removeBadge();
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  // static Future<void> adminNotificaciones(int cont) async {
  //   if (Util.badger) {
  //     if (cont > 0)
  //       FlutterAppBadger.updateBadgeCount(cont);
  //     else
  //       FlutterAppBadger.removeBadge();
  //   }
  // }

  //static Future<void> initLocalNotification(BuildContext context) async {
  static Future<void> initLocalNotification() async {
    print('entro a initLocalNotification');
    // const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    // final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    //   //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    // );
    /*final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false
    );*/
    // final InitializationSettings initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid,
    //     iOS: initializationSettingsIOS,
    //     //macOS: initializationSettingsMacOS
    // );
    // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //   onSelectNotification: (String? payload) async {
    //     print('Abrio notificacion local $payload');
    //     if (payload!.contains('idorden'))
    //       Util.muestraPregunta(payload);
    //       //Util.muestraPregunta(context);
    // }).catchError((e) {
    //   print(e);
    // });
  }

  //static void muestraPregunta(BuildContext context){
  // static void muestraPregunta(String data) async {
  //   print('entra a muestraPregunta - $data');
  //   //navigatorKey.currentState!.pushNamed('aviso');
  //   Map mapa = json.decode(data);
  //   navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => Confirmacion2DiasPage(token:mapa['token'], nombre:mapa['nombre'], id:mapa['idorden'], orden:mapa['orden'], direccion:mapa['direccion'], estructura:mapa['estructura'], usuario:mapa['usuario'], cliente:mapa['cliente'], transportista:mapa['transportista'], fecha:mapa['fechaentrega'])));
  // }

  // static void showLocalNotification(String? title, String? body, String data) async {
  //   print('entro en showLocalNotification');
  //   var android = AndroidNotificationDetails('channelId', 'channelName', 'channelDescription', priority:Priority.high, importance:Importance.max);
  //   var ios = IOSNotificationDetails();
  //   var platform = NotificationDetails(android:android, iOS:ios);
  //   await flutterLocalNotificationsPlugin.show(0, title, body, platform, payload:data);
  // }
}
