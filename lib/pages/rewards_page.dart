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

class RewardsPage extends StatefulWidget {

  const RewardsPage({Key? key}): super(key: key);

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> with AfterLayoutMixin {
  Session? session = null;
  String tipo = '';
  Map<String, dynamic>? response = null;
  late List<dynamic>? lstPuntos;
  List<Puntos> puntos = [];
  String imageUrl = '';
  String totalPuntos = '0';

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
    response = await Services.instance.enviaSolicitud('getIniPuntos', {'userId':session!.token}, null);
    print(response);
    if (response != null) {
      lstPuntos = response!['puntos'];
      if (lstPuntos != null)
        puntos = lstPuntos!.map((json) => Puntos.fromJson(json)).toList();
      imageUrl = response!['imagen'];
      totalPuntos = response!['totalPuntos'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    print('heightAppBar ${heightAppBar}');
    return Scaffold(
      /*appBar: AppBar(
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
      drawer: session==null ? MenuLateral(nombre:'', imagen:'foto.png', tipo:'U') : MenuLateral(nombre:session!.nombre, imagen:session!.imagen, tipo:'U'),*/
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
                      'Puntos Shopitrack',
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
                    puntos.length==0 ?
                    Text(
                      'No tienes Puntos',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ) :
                    Container(
                      height: responsive.hp(60),
                      child: dataBody(),
                    ),
                    SizedBox(height: responsive.dp(1.5)),
                    Text(
                      'TOTAL: $totalPuntos puntos',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
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
        for(final punto in puntos)
          Card(
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
          ),
      ],
    );
  }

  @override
  void dispose(){
    super.dispose();
  }
}
