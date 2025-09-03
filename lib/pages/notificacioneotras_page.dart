import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'notificacionesencuesta_page.dart';

class NotificacionesOtrasPage extends StatefulWidget {
  static const routeName = "notificacionesotras";
  final String nombre;
  final String token;
  final String imagen;
  final String imageUrl;
  final String idorden;
  final String orden;
  final String direccion;
  final String visto;
  final String estructura;
  final String idnotif;
  final String titulo;
  final String mensaje;

  NotificacionesOtrasPage({Key? key, required this.token, required this.imagen, required this.imageUrl, required this.nombre, required this.idorden, required this.orden, required this.direccion, required this.visto, required this.estructura, required this.idnotif, required this.titulo, required this.mensaje}) : super(key: key);

  @override
  _NotificacionesOtrasPageState createState() => _NotificacionesOtrasPageState();
}

class _NotificacionesOtrasPageState extends State<NotificacionesOtrasPage> {

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        title: IconContainer(
          width: 145,//responsive.dp(s28),
          height: 32,//responsive.dp(28)*0.3333,
          image: 'shopitrack.png',
        ),
        backgroundColor: Color(0xFF1846E8),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: responsive.isTablet ? 430 : responsive.width,
              minHeight: responsive.height - heightAppBar
            ),
            decoration: BoxDecoration(
              gradient: UtilWidgets.getGradientSys()
            ),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: responsive.dp(2)),
                Text(
                  widget.titulo,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1EE545)),
                ),
                /*SizedBox(height: responsive.dp(1)),
                IconContainer(
                  width: responsive.hp(12),
                  typeImg: widget.imagen.contains('//') ?  'url' : '',
                  image: widget.imageUrl==''?widget.imagen:widget.imageUrl,
                  radio: 0.5,
                ),*/
                SizedBox(height: responsive.hp(1)),
                Text(
                  //params.elementAt(0),
                  widget.nombre,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.normal, fontSize: 21, color: Colors.white),
                ),
                SizedBox(height: responsive.dp(1)),
                Container(
                  width: responsive.wp(75),
                  child: Text(
                    widget.mensaje,
                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.amberAccent),
                  ),
                ),
                SizedBox(height: responsive.dp(0.5)),
                /*IconContainer(
                  width: responsive.wp(100),
                  height: responsive.wp(100)*0.58,
                  image: 'fiesta.png',
                ),*/
                /*SizedBox(height: responsive.dp(1)),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Finaliza acumulando puntos por tu entrega y obten grandes productos',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),*/
                /*SizedBox(height: responsive.dp(1.5)),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Evalúa el servicio que recibiste en tu entrega para ganar puntos rewards.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(widget.visto != 'E' ? 1.5 : 0)),
                widget.visto != 'E' ?
                Row(
                    children: <Widget> [
                      SizedBox(width: responsive.wp(8)),
                      Expanded(
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(color: Color(0xFF1EE545))
                            ),
                            color: Color(0xFF1EE545),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            onPressed: () => _encuesta(),
                            child: Text(
                              'ACUMULAR PUNTOS',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                            )
                        ),
                      ),
                      SizedBox(width: responsive.wp(8)),
                    ]
                ) : Container(),*/
                /*SizedBox(height: responsive.dp(0.5)),
                Row(
                  children: <Widget> [
                    SizedBox(width: responsive.wp(8)),
                    Expanded(
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Color(0xFF1EE545))
                          ),
                          color: Color(0xFF1EE545),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          onPressed: () => _aceptar(),
                          child: Text(
                            'ACEPTAR',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                          )
                      ),
                    ),
                    SizedBox(width: responsive.wp(8)),
                  ]
                ),*/
                SizedBox(height: responsive.dp(5)),
              ],
            )
          ),
        )
      ),
    );
  }

  _encuesta(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificacionesEncuestaPage(token:widget.token, nombre:widget.nombre, idorden:widget.idorden, orden:widget.orden, estructura:widget.estructura, idnotif:widget.idnotif)));
  }

  _aceptar(){
    Navigator.pop(context);
  }
}
