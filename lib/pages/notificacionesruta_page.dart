import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class NotificacionesRutaPage extends StatefulWidget {
  static const routeName = "notificacionesruta";
  final String nombre;
  final String token;
  final String imagen;
  final String imageUrl;
  final String orden;
  final String direccion;

  NotificacionesRutaPage({Key? key, required this.token, required this.imagen, required this.imageUrl, required this.nombre, required this.orden, required this.direccion}) : super(key: key);

  @override
  _NotificacionesRutaPageState createState() => _NotificacionesRutaPageState();
}

class _NotificacionesRutaPageState extends State<NotificacionesRutaPage> {

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
                  'Notificación de envío',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1EE545)),
                ),
                SizedBox(height: responsive.dp(1)),
                IconContainer(
                  width: responsive.hp(12),
                  typeImg: widget.imagen.contains('//') ?  'url' : '',
                  image: widget.imageUrl==''?widget.imagen:widget.imageUrl,
                  radio: 0.5,
                ),
                SizedBox(height: responsive.hp(1)),
                Text(
                  //params.elementAt(0),
                  widget.nombre,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                ),
                SizedBox(height: responsive.dp(1)),
                Text(
                  'Tu entrega está en ruta',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white60),
                ),
                SizedBox(height: responsive.dp(3)),
                Text(
                  'Orden - '+widget.orden,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white60),
                ),
                SizedBox(height: responsive.dp(0.5)),
                /*Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        widget.direccion,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(2.5)),*/
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Ponte feliz, tu entrega está en ruta.\nEstimamos que llegue en un lapso de 2 a 4 horas',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.white60),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(1.5)),
                IconContainer(
                  width: responsive.wp(100),
                  height: responsive.wp(100)*0.58,
                  image: 'fiesta.png',
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
                          onPressed: () => _aceptar(),
                          child: Text(
                            'ACEPTAR',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                          )
                      ),
                    ),
                    SizedBox(width: responsive.wp(8)),
                  ]
                ),
                SizedBox(height: responsive.dp(5)),
              ],
            )
          ),
        )
      ),
    );
  }

  _aceptar(){
    Navigator.pop(context);
  }
}
