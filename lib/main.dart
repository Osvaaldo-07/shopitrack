import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shopitrack/pages/aviso_page.dart';
import 'package:shopitrack/pages/home_page.dart';
import 'package:shopitrack/pages/hometransp_page.dart';
import 'package:shopitrack/pages/login_page.dart';
import 'package:shopitrack/pages/register_page.dart';
import 'package:shopitrack/pages/splash_page.dart';
import 'package:shopitrack/pages/terminos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shopitrack/util/push_notification_service.dart';
import 'package:shopitrack/util/util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Util.initPlatformBadger();
  // String firebaseToken = await PushNotificationService.initializeApp();
  // Util.firebase = firebaseToken;
  runApp(Shopitrack());
}

class Shopitrack extends StatefulWidget {

  @override
  _ShopitrackState createState() => _ShopitrackState();
}

class _ShopitrackState extends State<Shopitrack> {

  @override
  void intState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('main');
    Util.initLocalNotification();
    // PushNotificationService.messageStream.listen((mapa) async {
    //   //print('Local: $mapa');
    //   if (mapa['origen'] == 'onMessage')
    //     Util.showLocalNotification(mapa['titulo'], mapa['mensaje'], mapa['data']);
    //   else {
    //     String data = mapa['data'];
    //     if (data.contains('idorden'))
    //       Util.muestraPregunta(data);
    //   }
    // });
    SystemChrome.setPreferredOrientations([//Widget Orientation Builder
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Util.navigatorKey,
      title: 'Shopitrack',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
        //scaffoldBackgroundColor: const Color(0xFF1846E8),
        scaffoldBackgroundColor: const Color(0xFF1846E8),
      ),
      home: SplashPage(),
      routes: {
        LoginPage.routeName: (_) => LoginPage(),
        HomePage.routeName: (_) => HomePage(),
        HomeTranspPage.routeName: (_) => HomeTranspPage(),
        RegisterPage.routeName: (_) => RegisterPage(),
        TerminosPage.routeName: (_) => TerminosPage(),
        AvisoPage.routeName: (_) => AvisoPage(),
        //EditaPerfilPage.routeName: (_) => EditaPerfilPage(),
      },
    );
  }
}

