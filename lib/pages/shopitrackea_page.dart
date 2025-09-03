import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class ShopitrackeaPage extends StatefulWidget {
  static const routeName = "home";

  const ShopitrackeaPage({Key? key}): super(key: key);

  @override
  _ShopitrackeaPageState createState() => _ShopitrackeaPageState();
}

class _ShopitrackeaPageState extends State<ShopitrackeaPage> with AfterLayoutMixin {

  Session? session = null;
  Map<String, dynamic>? response = null;

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  _init() async {
    session = await Auth.instance.accessToken;
    //print(session.code);
    response = Map<String, dynamic>();
    //response = await Services.instance.enviaSolicitud('getDatosIni', {'userId':params.elementAt(1)}, context);
    //print(response);
    setState(() {});
  }

//   _shopitraAmigo() async {
// //final RenderBox box = context.findRenderObject() as RenderBox;
//     await Share.share('Esta es la mejor manera de controlar días y horarios de entrega en todas tus compras y servicios a domicilio.\nControla sin estar esperando.\nNo olvides capturar mi ID: ${session!.code} en tu registro\nApp Store https://apps.apple.com/mx/app/shopitrack/id1618649469\nGoogle Play https://play.google.com/store/apps/details?id=com.shopitrack.shopitrack', subject: 'Registra tu empresa y prueba sin costo.');
//     //sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
//   }

//   _shopitraCliente() async {
//     await Share.share('Esta es la mejor manera de controlar días y horarios de tus entrega en todas tus ventas y potenciando el servicios a clientes.\nControla y eficienta tu logistica.\nhttp://www.shopitrack.com:8080/shopitrack-erp/', subject: 'No puedes perderte esta excelente recomendación.');
//   }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Shopitrackealo'),
        backgroundColor: Color(0xFF1846E8),
        leading: Builder(
          builder: (context) {
            return IconButton(
              //icon: Icon(Icons.menu),
              icon: Image.asset('assets/menu/settings.png', width:30, height:30),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        /*actions: <Widget> [
          Builder(
            builder: (context) {
              return IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            }
          ),
        ],*/
      ),
      //drawer: response == null ? null : MenuLateral(nombre: params.elementAt(0)),
      drawer: session==null ? MenuLateral(nombre:'', imagen:'foto.png', tipo:'U') : MenuLateral(nombre:session!.nombre, imagen:session!.imagen, tipo:'U'),*/
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: responsive.isTablet ? 430 : responsive.width,
              minHeight: responsive.height - heightAppBar - 48
            ),
            decoration: BoxDecoration(
              gradient: UtilWidgets.getGradientSys()
            ),
            width: double.infinity,
            child: response == null ? Container(
              //width: double.infinity,
              //height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              )
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: responsive.dp(3)),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: <TextSpan>[
                            //TextSpan(text:'Shopitrackea', style:TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 18, fontWeight:FontWeight.bold, color: Color(0xFF1EE545))),
                            TextSpan(text:'Comparte Shopitrack con tus amistades.\n\n', style:TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 18, color: Color(0xFFEEEEEE))),
                            TextSpan(text:'Tu ganas puntos por cada descarga y activación y a quien invites, le brindas la oportunidad de controlar sus entregas y su tiempo con certeza.', style:TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 18, color: Color(0xFFEEEEEE))),
                          ]
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(3)),
                Row(
                  children: <Widget> [
                    SizedBox(width: responsive.wp(8)),
                    Expanded(
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Color(0xFF1EE545))
                          ),
                          color: Color(0xFF1EE545),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          onPressed: () {}, //_shopitraAmigo(),
                          child: Text(
                            'Comparte Shopitrack',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                          )
                      ),
                    ),
                    SizedBox(width: responsive.wp(8)),
                  ]
                ),
                SizedBox(height: responsive.dp(3)),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text:'Ahora puedes controlar cualquier entrega.', style:TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 18, color: Color(0xFFEEEEEE))),
                              TextSpan(text:'Invita a tu vendedor o proveedor de servicios a utilizar Shopitrack gratis en tu sigueinte entrega.', style:TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 18, color: Color(0xFFEEEEEE))),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(3)),
                Row(
                  children: <Widget> [
                    SizedBox(width: responsive.wp(8)),
                    Expanded(
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Color(0xFF1EE545))
                          ),
                          color: Color(0xFF1EE545),
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          onPressed: () {}, //_shopitraCliente(),
                          child: Text(
                            'Solicita Shopitrack\nen tu siguiente entrega',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                            textAlign: TextAlign.center,
                          )
                      ),
                    ),
                    SizedBox(width: responsive.wp(8)),
                  ]
                ),
                SizedBox(height: responsive.dp(1)),
              ],
            )
          ),
        )
      ),
    );
  }

  void dispose(){
    super.dispose();
  }
}
