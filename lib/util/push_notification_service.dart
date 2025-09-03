import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shopitrack/util/util.dart';
import 'package:shopitrack/util/services.dart';

import '../firebase_options.dart';
import 'auth.dart';

class PushNotificationService {

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<Map<String, dynamic>> _messageStream = StreamController.broadcast();
  static Stream<Map<String, dynamic>> get messageStream => _messageStream.stream;

  // static Future _onBackgroundHandler(RemoteMessage message) async {
  //   print(message.data['product']);
  //   Map<String, dynamic> mapa = {
  //     'titulo': message.notification!.title,
  //     'mensaje': message.notification!.body,
  //     'data': message.data['product'],
  //     'origen': 'onBackground'
  //   };
  //   Util.adminNotificacionesSession().then((value) {
  //     _messageStream.add(mapa);
  //   });
  //   print('BackgroundHandler: ${message.messageId}');
  // }

  // static Future _onMessageHandler(RemoteMessage message) async {
  //   print(message.data['product']);
  //   Map<String, dynamic> mapa = {
  //     'titulo': message.notification!.title,
  //     'mensaje': message.notification!.body,
  //     'data': message.data['product'],
  //     'origen': 'onMessage'
  //   };
  //   Util.adminNotificacionesSession().then((value) {
  //     _messageStream.add(mapa);
  //   });
  //   print('MessageHandler: ${message.messageId}');
  // }

  // static Future _onMessageOpenedAppHandler(RemoteMessage message) async {
  //   print(message.data['product']);
  //   Map<String, dynamic> mapa = {
  //     'titulo': message.notification!.title,
  //     'mensaje': message.notification!.body,
  //     'data': message.data['product'],
  //     'origen': 'onMessageOpenedApp'
  //   };
  //   Util.adminNotificacionesSession().then((value) {
  //     _messageStream.add(mapa);
  //   });
  //   print('MessageopenedAppHandler: ${message.messageId}');
  // }

  // static Future<String> initializeApp() async {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   await requestPermission();
  //   token = await FirebaseMessaging.instance.getToken();
  //   print('Token: $token');
  //   //Handlers
  //   FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
  //   FirebaseMessaging.onMessage.listen(_onMessageHandler);
  //   FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);
  //   return token!;
  // }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );
    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams(){
    _messageStream.close();
  }
}