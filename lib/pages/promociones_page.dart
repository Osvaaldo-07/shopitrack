import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/models/catalogos.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:shopitrack/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class PromocionesPage extends StatefulWidget {

  const PromocionesPage({Key? key}): super(key: key);

  @override
  _PromocionesPageState createState() => _PromocionesPageState();
}

class _PromocionesPageState extends State<PromocionesPage> with AfterLayoutMixin {
  Session? session = null;
  String tipo = '';
  Map<String, dynamic>? response = null;
  late List<dynamic>? lstPromociones;
  List<Promociones> promociones = [];
  //String imageUrl = '';
  //String totalPuntos = '0';

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  @override
  void initState(){
    super.initState();
  }

  _init() async {
    session = await Auth.instance.accessToken;
    tipo = session!.token.endsWith("T") ? "T" : "U";
    response = await Services.instance.enviaSolicitud('getPromociones', {'userId':session!.token}, null);
    print(response);
    if (response != null) {
      lstPromociones = response!['promociones'];
      if (lstPromociones != null)
        promociones = lstPromociones!.map((json) => Promociones.fromJson(json)).toList();
      //imageUrl = response!['imagen'];
      //totalPuntos = response!['totalPuntos'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
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
      ),
      drawer: session==null ? MenuLateral(nombre:'', imagen:'foto.png', tipo:'U') : MenuLateral(nombre:session!.nombre, imagen:session!.imagen, tipo:'U'),
      body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
                height: responsive.hp(80),
                constraints: BoxConstraints(
                    maxWidth: responsive.isTablet ? 430 : responsive.width,
                    minHeight: responsive.height - heightAppBar - 48
                ),
                decoration: BoxDecoration(
                    gradient: UtilWidgets.getGradientSys()
                ),
                width: double.infinity,
                child: response == null ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  )
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    SizedBox(height: responsive.dp(1.5)),
                    Text(
                      'Promociones',
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF1EE545)),
                    ),
                    SizedBox(height: responsive.dp(1)),
                    /*IconContainer(
                      width: responsive.hp(12),
                      typeImg: session!.imagen.contains('//') ?  'url' : '',
                      image: imageUrl==''?session!.imagen:imageUrl,
                      radio: 0.5,
                    ),
                    SizedBox(height: responsive.hp(1)),
                    Text(
                      session!.nombre,
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                    ),
                    SizedBox(height: responsive.dp(2)),*/
                    promociones.length==0 ?
                    Text(
                      'No hay Promociones activas',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ) :
                    Expanded(
                      child: dataBody(),
                    ),
                    SizedBox(height: responsive.dp(2.5)),
                  ],
                )
            ),
          )
      ),
    );
  }

  ListView dataBody() {
    final Responsive responsive = Responsive.of(context);
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        for(final promocion in promociones)
          Container(
            child: Column(
              children: <Widget>[
                IconContainer(
                  width: responsive.wp(60),
                  height: responsive.wp(35),
                  typeImg: 'url',
                  image: promocion.imagen,
                  radio: 0.02,
                  onTap: () => _irShopitrack(promocion.url),
                ),
                SizedBox(height: responsive.hp(1)),
                Container(
                  width: responsive.wp(60),
                  //alignment: Alignment.left,
                  //padding: EdgeInsets.only(left: 20, right: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text:promocion.texto, style:TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 15, color:Colors.white)),
                      ]
                    ),
                  ),
                ),
                /*Text(
                  promocion.texto,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),*/
                SizedBox(height: responsive.dp(3))
              ],
            )
          )
          /*Card(
            margin: EdgeInsets.only(bottom: 8),
            color: Color(0xFF3E68FD),//index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
            key: ValueKey(punto),
            elevation: 1,
            child: InkWell(
              onTap: () => null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconContainer(
                    margin: EdgeInsets.all(8),
                    width: responsive.wp(12),
                    typeImg: '',
                    image: punto.puntos<0 ? 'iconos/puntosMenos.png' : 'iconos/puntosMas.png',
                    radio: 0.5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Text(punto.origen,
                          style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        margin: EdgeInsets.only(bottom: 6, left: 5),
                      ),
                      Container(
                        width: responsive.wp(70),
                        child: Text(punto.foperacion,
                          style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                        ),
                        margin: EdgeInsets.only(left:5)
                      ),
                    ],
                  ),
                  Container(
                    width: responsive.wp(12),
                    child: Text('${punto.puntos}',
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),*/
      ],
    );
  }

  Future<void> _irShopitrack(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    }
    else
      throw 'Could not launch ' + url;
  }

  @override
  void dispose(){
    super.dispose();
  }
}
