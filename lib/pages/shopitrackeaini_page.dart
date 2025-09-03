import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/pages/rewards_page.dart';
import 'package:shopitrack/pages/shopitrackea_page.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:shopitrack/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShopitrackeaIniPage extends StatefulWidget {

  ShopitrackeaIniPage({Key? key}) : super(key: key);

  @override
  _ShopitrackeaIniPageState createState() => _ShopitrackeaIniPageState();
}

class _ShopitrackeaIniPageState extends State<ShopitrackeaIniPage> with AfterLayoutMixin, SingleTickerProviderStateMixin {
  late TabController ahopitrackeaMenuController;
  Session? session = null;
  String tipo = '';

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  @override
  void initState(){
    super.initState();
    ahopitrackeaMenuController = TabController(length: 2, vsync: this);
  }

  _init() async {
    //print('perfil $session');
    //print('perfil_init');
    session = await Auth.instance.accessToken;
    tipo = session!.token.endsWith("T") ? "T" : "U";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: IconContainer(
          width: 145,//responsive.dp(28),
          height: 32,//responsive.dp(28)*0.3333,
          image: 'shopitrack.png',
        ),
        backgroundColor: Color(0xFF1846E8),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Image.asset('assets/menu/settings.png', width:30, height:30),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        bottom: TabBar(
          controller: ahopitrackeaMenuController,
          tabs: <Widget> [
            Tab(
              child: Text('SHOPITRACKEALO'),
            ),
            Tab(
              child: Text('REWARDS'),
            ),
          ],
        ),
      ),
      //drawer: MenuLateral(nombre: params.elementAt(0), imagen: params.elementAt(2)),
      drawer: session==null ? MenuLateral(nombre:'', imagen:'foto.png', tipo:tipo) : MenuLateral(nombre:session!.nombre, imagen:session!.imagen, tipo:tipo),
      body: session==null ? Center() : TabBarView(
        controller: ahopitrackeaMenuController,
        children: <Widget>[
          ShopitrackeaPage(),
          RewardsPage(),
        ],
      )
    );
  }

  @override
  void dispose(){
    super.dispose();
  }
}
