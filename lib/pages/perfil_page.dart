import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/pages/direcciones_page.dart';
import 'package:shopitrack/pages/misentregas_page.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:shopitrack/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'miperfil_page.dart';

class PerfilPage extends StatefulWidget {
  TabController mainMenuController;

  PerfilPage({Key? key, required this.mainMenuController}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> with AfterLayoutMixin, SingleTickerProviderStateMixin {
  late TabController perfilMenuController;
  Session? session = null;
  String tipo = '';

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  @override
  void initState(){
    super.initState();
    perfilMenuController = TabController(length: 3, vsync: this);
  }

  _init() async {
    print('perfil $session');
    print('perfil_init');
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
          controller: perfilMenuController,
          tabs: <Widget> [
            Tab(
              child: Text('INICIO'),
            ),
            Tab(
              child: Text('MIS ENTREGAS'),
            ),
            Tab(
              child: Text('DIRECCIONES'),
            ),
          ],
        ),
      ),
      //drawer: MenuLateral(nombre: params.elementAt(0), imagen: params.elementAt(2)),
      drawer: session==null ? MenuLateral(nombre:'', imagen:'foto.png', tipo:tipo) : MenuLateral(nombre:session!.nombre, imagen:session!.imagen, tipo:tipo),
      body: session==null ? Center() : TabBarView(
        controller: perfilMenuController,
        children: <Widget>[
          //MisentregasPage(nombre:params.elementAt(0), token:params.elementAt(1), imagen:params.elementAt(2)),
          MiperfilPage(nombre:session!.nombre, token:session!.token, imagen:session!.imagen, mainMenuController:widget.mainMenuController),
          MisentregasPage(nombre:session!.nombre, token:session!.token, imagen:session!.imagen, mainMenuController:widget.mainMenuController),
          DireccionesPage(token:session!.token),
        ],
      )
    );
  }

  @override
  void dispose(){
    super.dispose();
  }
}
