import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/pages/tusentregas_page.dart';
import 'package:shopitrack/pages/tusentregasfuturas_page.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:shopitrack/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeTranspPage extends StatefulWidget {
  static const routeName = "hometransp";

  const HomeTranspPage({Key? key}): super(key: key);

  @override
  _HomeTranspPageState createState() => _HomeTranspPageState();
}

class _HomeTranspPageState extends State<HomeTranspPage> with AfterLayoutMixin, SingleTickerProviderStateMixin {
  late TabController ordenesMenuController;
  Session? session = null;

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  @override
  void initState() {
    super.initState();
    ordenesMenuController = TabController(length: 2, vsync: this);
  }

  _init() async {
    session = await Auth.instance.accessToken;
    //print("ors"+session.token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //params = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: IconContainer(
            width: 145,//responsive.dp(s28),
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
            controller: ordenesMenuController,
            tabs: <Widget> [
              Tab(
                child: Text('TUS ENTREGAS'),
              ),
              Tab(
                child: Text('ENTREGAS FUTURAS'),
              )
            ],
          ),
        ),
        //drawer: MenuLateral(nombre: params.elementAt(0), imagen: params.elementAt(2)),
        drawer: session==null ? MenuLateral(nombre:'', imagen:'foto.png', tipo:'T') : MenuLateral(nombre:session!.nombre, imagen:session!.imagen, tipo:'T'),
        body: session==null ? Center() : TabBarView(
          controller: ordenesMenuController,
          children: <Widget>[
            //MisentregasPage(nombre:params.elementAt(0), token:params.elementAt(1), imagen:params.elementAt(2)),
            TusEntregasPage(token:session!.token),
            TusEntregasFuturasPage(token:session!.token)
          ],
        )
    );
  }

  void dispose(){
    super.dispose();
  }
}
