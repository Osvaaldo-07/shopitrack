import 'package:shopitrack/util/push_notification_service.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/util.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:shopitrack/pagesforms/login_form.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState(){
    super.initState();
    /*Util.initLocalNotification(context);
    PushNotificationService.messageStream.listen((mapa) {
      print(mapa);
      if (mapa['origen'] == 'onMessage')
        Util.showLocalNotification(mapa['titulo'], mapa['mensaje'], mapa['tipo']);
      else {
        if (mapa['tipo'] == 'confirmacion')
          Util.muestraPregunta(context);
      }
    });*/
    /*PushNotificationService.messageStream.listen((mapa) async {
      print(mapa);
      if (mapa['origen'] == 'onMessage')
        Util.showLocalNotification(mapa['titulo'], mapa['mensaje'], mapa['tipo']);
      else {
        String data = mapa['tipo'];
        if (data.contains('confirmacion'))
          Util.muestraPregunta(data);
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: responsive.isTablet ? 430 : responsive.width,
                minHeight: responsive.height
            ),
            decoration: BoxDecoration(
              gradient: UtilWidgets.getGradientSys()
            ),
            width: double.infinity,
            //height: responsive.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: responsive.dp(0)),
                IconContainer(
                  width: responsive.dp(19),
                  height: responsive.dp(19)*1.19,
                  image: 'login.png',
                ),
                LoginForm(),
                IconContainer(
                  width: responsive.dp(28),
                  height: responsive.dp(28)*0.3333,
                  image: 'estrellas.png',
                ),
                SizedBox(height: responsive.dp(0)),
              ],
            )
          ),
        )
      ),
    );
  }
}