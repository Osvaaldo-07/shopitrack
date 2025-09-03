import 'package:intl/intl.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'misentregasdetallereprog.dart';

class MisentregasDetallePage extends StatefulWidget {
  static const routeName = "misentregasdetalle";
  final String nombre;
  final String token;
  final String id;
  final String usuario;
  final String imagen;
  final String imageUrl;
  final String orden;
  final String direccion;
  final String fecha;
  final String estructura;
  final String transportista;
  final String cliente;

  MisentregasDetallePage({Key? key, required this.token, required this.id, required this.usuario, required this.imagen, required this.imageUrl, required this.nombre, required this.orden, required this.direccion, required this.fecha, required this.estructura, required this.transportista, required this.cliente}) : super(key: key);

  @override
  _MisentregasDetallePageState createState() => _MisentregasDetallePageState();
}

class _MisentregasDetallePageState extends State<MisentregasDetallePage> {

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String fechaHoy = formatter.format(now);
    print('$fechaHoy  ${widget.fecha}');
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
                  'Detalle de Orden',
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
                fechaHoy==widget.fecha ? 'Tu entrega es hoy' : 'Tu entrega es el ${widget.fecha}',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white60),
                ),
                SizedBox(height: responsive.dp(3)),
                Text(
                  'Orden - '+widget.orden,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white60),
                ),
                SizedBox(height: responsive.dp(0.5)),
                Row(
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
                SizedBox(height: responsive.dp(2.5)),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Recuerda que recibiras dos notificaciones',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.white60),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(1.5)),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'La primera será cuando tu orden esté entre 2 y 3 horas',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.white60),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(1.5)),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'La segunda será cuando la orden ya vaya en camino a tu casa y te indicaremos el tiempo aproximado de arribo',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.white60),
                      ),
                    ),
                  ],
                ),
                /*SizedBox(height: responsive.dp(1.5)),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Recuerda estar pendiente y responder tu encuesta para mejorar nuestro servicio',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 18, color: Colors.white60),
                      ),
                    ),
                  ],
                ),*/
                SizedBox(height: responsive.dp(3)),
                if (fechaHoy != widget.fecha)
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
                            'CONFIRMAR',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                          )
                      ),
                    ),
                    SizedBox(width: responsive.wp(8)),
                  ]
                ),
                SizedBox(height: responsive.dp(1.5)),
                if (fechaHoy != widget.fecha)
                Row(
                  children: <Widget> [
                    SizedBox(width: responsive.wp(8)),
                    Expanded(
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Color(0xFFFFED4B))
                          ),
                          color: Color(0xFFFFED4B),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          onPressed: () => _reprogramar(),
                          child: Text(
                            'REPROGRAMAR',
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

  _reprogramar(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MisentregasDetalleReprogPage(token:widget.token, id:widget.id, usuario:widget.usuario, nombre:widget.nombre, orden:widget.orden, direccion:widget.direccion, fecha:widget.fecha, estructura:widget.estructura, transportista:widget.transportista, cliente:widget.cliente)));
  }
}
