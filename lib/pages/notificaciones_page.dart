import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/models/catalogos.dart';
import 'package:shopitrack/pages/confirmacion2dias.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/util/util.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:shopitrack/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'notificacioneotras_page.dart';
import 'notificacionescamino_page.dart';
import 'notificacionesentrega_page.dart';
import 'notificacionesruta_page.dart';

class NotificacionesPage extends StatefulWidget {

  const NotificacionesPage({Key? key}): super(key: key);

  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> with AfterLayoutMixin {
 // TabController tabController;
  //LinkedHashSet params;
  Session? session = null;
  String tipo = '';
  Map<String, dynamic>? response = null;
  List<dynamic>? lstNotificaciones;
  List<Notificacion> notificaciones = [];
  String imageUrl = '';

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  /*@override
  void initState(){
    super.initState();
    //tabController = TabController(length: 4, vsync: this);
  }*/

  _init() async {
    session = await Auth.instance.accessToken;
    tipo = session!.token.endsWith("T") ? "T" : "U";
    response = await Services.instance.enviaSolicitud('getIniNotificaciones', {'userId':session!.token}, null);
    //print(response);
    if (response != null) {
      lstNotificaciones = response!['notificaciones'];
      if (lstNotificaciones != null)
        notificaciones = lstNotificaciones!.map((json) => Notificacion.fromJson(json)).toList();
      imageUrl = response!['imagen'];
    }
    Map<String, dynamic>? responseCount = await Services.instance.enviaSolicitud('getCountNotificaciones', {'userId':session!.token}, null);
    // if (responseCount != null) {
    //   if (responseCount['codigo'] == 0) {
    //     //print('OsvaldoNotif: ${responseCount['mensaje']}');
    //     int cont = int.tryParse(responseCount['mensaje'])!;
    //     Util.adminNotificaciones(cont);
    //   }
    // }
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
              //width: double.infinity,
              //height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              )
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: responsive.dp(1.5)),
                Text(
                  'Notificaciones',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF1EE545)),
                ),
                SizedBox(height: responsive.dp(1)),
                IconContainer(
                  width: responsive.hp(12),
                  typeImg: session!.imagen.contains('//') ?  'url' : '',
                  image: imageUrl==''?session!.imagen:imageUrl,
                  radio: 0.5,
                ),
                SizedBox(height: responsive.hp(1)),
                Text(
                  //params.elementAt(0),
                  session!.nombre,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                ),
                SizedBox(height: responsive.dp(2)),
                notificaciones.length==0 ?
                Text(
                  'No tienes Notificaciones',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ) :
                Expanded(
                  child: dataBody(),
                ),
                SizedBox(height: responsive.dp(1.5)),
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
        for(final notificacion in notificaciones)
          Card(
            margin: EdgeInsets.only(bottom: 8),
            color: Color(0xFF3E68FD),//index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
            key: ValueKey(notificacion),
            elevation: 1,
            child: InkWell(
              onTap: () {},
              // notificacion.evento=='1' ? _muestraNotif1(notificacion.idnotif, notificacion.nombre, notificacion.idorden, notificacion.orden, notificacion.direccion, notificacion.visto) :
              //   //notificacion.evento=='2' ? null :
              //   notificacion.evento=='3' ? _muestraNotif3(notificacion.idnotif, notificacion.nombre, notificacion.idorden, notificacion.orden, notificacion.direccion, notificacion.visto, notificacion.mensaje) :
              //   notificacion.evento=='4' ? _muestraNotif4(notificacion.idnotif, notificacion.nombre, notificacion.idorden, notificacion.orden, notificacion.direccion, notificacion.visto, notificacion.estructura) :
              //   notificacion.evento=='5' ? _muestraNotif5(notificacion.idnotif, notificacion.nombre, notificacion.idorden, notificacion.orden, notificacion.direccion, notificacion.visto, notificacion.estructura, notificacion.usuario, notificacion.cliente) :
              //   _muestraNotifX(notificacion.idnotif, notificacion.nombre, notificacion.idorden, notificacion.orden, notificacion.direccion, notificacion.visto, notificacion.estructura, notificacion.titulo, notificacion.mensaje),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconContainer(
                    margin: EdgeInsets.all(8),
                    width: responsive.wp(12),
                    typeImg: '',
                    image: notificacion.visto=='N' ? 'iconos/notifact.png' : 'iconos/notifinac.png',
                    radio: 0.5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        //padding: EdgeInsets.all(5),
                        //alignment: Alignment.bottomRight,
                        width: responsive.wp(82),
                        child: Text(notificacion.titulo,
                          style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                          margin: EdgeInsets.only(bottom: 6, left: 5),
                        /*decoration: BoxDecoration(
                          color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                        ),*/
                      ),
                      Container(
                        //alignment: Alignment.centerLeft,
                          width: responsive.wp(82),
                          child: Text('Orden: ${notificacion.orden}',
                            style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
                            //textAlign: TextAlign.left,
                          ),
                          margin: EdgeInsets.only(left:5)
                        /*decoration: BoxDecoration(
                          color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                          //border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                        ),*/
                      ),
                      Container(
                        //alignment: Alignment.centerLeft,
                        width: responsive.wp(82),
                        child: Text(notificacion.mensaje,
                          style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                          //textAlign: TextAlign.left,
                        ),
                        margin: EdgeInsets.only(left:5)
                        /*decoration: BoxDecoration(
                          color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                          //border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                        ),*/
                      ),
                      /*Container(
                        alignment: Alignment.center,
                        width: responsive.wp(17),
                        child: Text(notificacion.nombre,
                          style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                          color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                          //border: Border.symmetric(vertical: BorderSide(width:0.5, color: Color(0xFF1846E8))),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top:5, bottom:5),
                        alignment: Alignment.center,
                        width: responsive.wp(35),
                        child: Text(notificacion.direccion,
                          style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                          color: index++ % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                        ),*/
                      //),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // _notifVisto(String idnotif, String visto) async {
  //   if (visto == 'N') {
  //     String datos = idnotif + '_-,-_S';
  //     //print('datos: $datos');
  //     response = await Services.instance.enviaSolicitud('actualizaNotifVisto', {'userId':session!.token, 'idsPos':datos}, context);
  //     if (response != null) {
  //       if (response!['codigo'] == 0) {
  //         //print('OsvaldoNotif: ${response!['mensaje']}');
  //         int cont = int.tryParse(response!['mensaje'])!;
  //         Util.adminNotificaciones(cont);
  //       }
  //     }
  //     _init();
  //   }
  // }

  // _muestraNotif1(String idnotif, String nombre, String idorden, String orden, String direccion, String visto) async {
  //   _notifVisto(idnotif, visto).then((value) {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => NotificacionesRutaPage(token:session!.token, imagen:session!.imagen, imageUrl:imageUrl, nombre:nombre, orden:orden, direccion:direccion)));
  //   });
  // }

  // _muestraNotif3(String idnotif, String nombre, String idorden, String orden, String direccion, String visto, String mensaje) async {
  //   _notifVisto(idnotif, visto).then((value) {
  //     mensaje = mensaje.substring(mensaje.indexOf('aproximadamente'));
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => NotificacionesCaminoPage(token:session!.token, imagen:session!.imagen, imageUrl:imageUrl, nombre:nombre, orden:orden, direccion:direccion, idnotif:idnotif, idorden:idorden, hora:mensaje)));
  //   });
  // }

  // _muestraNotif4(String idnotif, String nombre, String idorden, String orden, String direccion, String visto, String estructura) async {
  //   _notifVisto(idnotif, visto).then((value) {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => NotificacionesEntregaPage(token:session!.token, imagen:session!.imagen, imageUrl:imageUrl, nombre:nombre, idorden:idorden, orden:orden, direccion:direccion, visto:visto, estructura:estructura, idnotif:idnotif)));
  //   });
  // }

  // _muestraNotifX(String idnotif, String nombre, String idorden, String orden, String direccion, String visto, String estructura, String titulo, String mensaje) async {
  //   _notifVisto(idnotif, visto).then((value) {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => NotificacionesOtrasPage(token:session!.token, imagen:session!.imagen, imageUrl:imageUrl, nombre:nombre, idorden:idorden, orden:orden, direccion:direccion, visto:visto, estructura:estructura, idnotif:idnotif, titulo:titulo, mensaje:mensaje)));
  //   });
  // }

  // _muestraNotif5(String idnotif, String nombre, String idorden, String orden, String direccion, String visto, String estructura, String usuario, String cliente) async {
  //   _notifVisto(idnotif, visto).then((value) {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => Confirmacion2DiasPage(token:session!.token, nombre:nombre, id:idorden, orden:orden, direccion:direccion, estructura:estructura, usuario:usuario, cliente:cliente, transportista:'', fecha:'')));
  //   });
  // }

  @override
  void dispose(){
    super.dispose();
  }
}
