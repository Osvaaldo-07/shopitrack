import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shopitrack/pages/home_page.dart';
import 'package:shopitrack/pages/login_page.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/util.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

import 'hometransp_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = "splash";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with AfterLayoutMixin {
  late Timer _timer;

  @override
  void afterFirstLayout(BuildContext context) {
    _timer = Timer(const Duration(seconds: 2), _check);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _check() async {
    //await Auth.instance.logOut(context);
    Util.detectPlatform();
    Session? session = await Auth.instance.accessToken;
    //print('_check_${session.nombre}');
    if (session != null) {
      if (session.token.endsWith("U"))
        //Navigator.pushReplacementNamed(context, HomePage.routeName, arguments:{session.nombre, session.token, session.imagen});
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      else if (session.token.endsWith("T"))
        Navigator.pushReplacementNamed(context, HomeTranspPage.routeName);
    }
    else
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double sizeLogo = responsive.wp(25);
    double sizeText = responsive.wp(80);
    double widthScreen = responsive.width;
    /*print('width:${responsive.width}');
    print('width80:${responsive.wp(80)}');
    print('sizeLogo: ${sizeLogo}');*/
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: UtilWidgets.getGradientSys()
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget> [
            Positioned(
              right: -sizeLogo,
              child: FadeInLeft(
                child: Container(
                  width: sizeLogo,
                  height: sizeLogo,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo.gif'),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                duration:Duration(seconds: 1),
                from: 1200//widthScreen+sizeLogo+5,//-responsive.width (414+103+5)
              ),
            ),
            Positioned(
              left: (widthScreen-sizeText)/2,//responsive.width/2,
              child: ZoomIn(
                child: Container(
                  width: sizeText,//responsive.wp(80),
                  height: sizeText*0.22,//responsive.wp(80) * 0.22,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    //borderRadius: BorderRadius.circular(this.width*0.1),
                      image: DecorationImage(
                        image: AssetImage('assets/shopitrack.png'),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                duration: Duration(seconds: 1),
                delay: Duration(seconds: 1),
              )
            ),
          ],
        ),
      ),
    );
  }
}
