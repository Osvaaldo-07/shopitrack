import 'package:shopitrack/pages/notificaciones_page.dart';
import 'package:shopitrack/pages/perfil_page.dart';
import 'package:shopitrack/pages/promociones_page.dart';
import 'package:shopitrack/pages/rewards_page.dart';
import 'package:shopitrack/pages/shopitrackea_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopitrack/pages/shopitrackeaini_page.dart';
import 'package:shopitrack/util/push_notification_service.dart';
import 'package:shopitrack/util/util.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home";

  const HomePage({Key? key}): super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with /*AfterLayoutMixin,*/ SingleTickerProviderStateMixin {
  static late TabController mainMenuController;
  //LinkedHashSet params;
  //Map<String, dynamic> response;

  /*@override
  void afterFirstLayout(BuildContext context){
    this._init();
  }*/

  @override
  void initState(){
    //params = ModalRoute.of(context).settings.arguments;
    mainMenuController = TabController(length: 4, vsync: this);
    mainMenuController.addListener(_handleTabSelection);
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
        if (mapa['tipo'] == 'confirmacion')
          Util.muestraPregunta(data);
      }
    });*/
  }

  _handleTabSelection(){
    setState(() {

    });
  }
  /*_init() async {
    //print(params);
    print('home form');

    //response = await Services.instance.enviaSolicitud('getDatosIni', {'userId':params.elementAt(1)}, context);
    //print(response);
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    //params = ModalRoute.of(context).settings.arguments;
    print('index ${mainMenuController.index}');
    return Scaffold(
      body: TabBarView(
        controller: mainMenuController,
        children: <Widget>[
          //PerfilPage(nombre:params.elementAt(0), token:params.elementAt(1), imagen:params.elementAt(2)),
          PerfilPage(mainMenuController:mainMenuController),
          ShopitrackeaIniPage(),
          NotificacionesPage(),
          PromocionesPage(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 62,
        child: Material(
          color: Color(0xFF182F9f),
          child: TabBar(
            controller: mainMenuController,
            indicatorWeight: 4,
            labelPadding: EdgeInsets.only(bottom: 5),
            tabs: <Tab> [
              Tab(
                icon: Image.asset(mainMenuController.index==0 ? 'assets/menu/perfil_a.png' : 'assets/menu/perfil.png', width:38, height:48)
              ),
              Tab(
                icon: Image.asset(mainMenuController.index==1 ? 'assets/menu/shopitrackea_a.png' : 'assets/menu/shopitrackea.png', width:88, height:48)
              ),
              Tab(
                icon: Image.asset(mainMenuController.index==2 ? 'assets/menu/notificaciones_a.png' : 'assets/menu/notificaciones.png', width:95, height:48)
              ),
              Tab(
                icon: Image.asset(mainMenuController.index==3 ? 'assets/menu/promociones_a.png' : 'assets/menu/promociones.png', width:58, height:48)
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    mainMenuController.dispose();
    super.dispose();
  }
}
