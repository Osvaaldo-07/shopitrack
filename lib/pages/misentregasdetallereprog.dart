import 'package:shopitrack/models/Parametros.dart';
import 'package:shopitrack/util/dialogs.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'home_page.dart';

class MisentregasDetalleReprogPage extends StatefulWidget {
  static const routeName = "misentregasdetallereprog";
  final String nombre;
  final String token;
  final String id;
  final String usuario;
  final String orden;
  final String direccion;
  final String fecha;
  final String estructura;
  final String transportista;
  final String cliente;

  MisentregasDetalleReprogPage({Key? key, required this.token, required this.id, required this.usuario, required this.nombre, required this.orden, required this.direccion, required this.fecha, required this.estructura, required this.transportista, required this.cliente}) : super(key: key);

  @override
  _MisentregasDetalleReprogPageState createState() => _MisentregasDetalleReprogPageState();
}

class _MisentregasDetalleReprogPageState extends State<MisentregasDetalleReprogPage> {

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
                  'REPROGRAMAR',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1EE545)),
                ),
                SizedBox(height: responsive.hp(1)),
                Text(
                  //params.elementAt(0),
                  widget.nombre,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                ),
                SizedBox(height: responsive.dp(1)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Has pedido REPROGRAMAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(1)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Tu orden ya no será enviada en la fecha popuesta',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(1)),
                Text(
                  'Orden - '+widget.orden,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white60),
                ),
                SizedBox(height: responsive.dp(1)),
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
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        //'Programada para el ' + widget.fecha,
                        'Por favor contacta a tu vendedor para una nueva fecha de entrega',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 20, color: Colors.white),
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
                        'Al aceptar notificaremos a tu proveedor que no envíe hasta confirmar contigo nueva fecha, es importante contactes a tu proveedor y acuerden nueva fecha',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 18, color: Colors.white60),
                      ),
                    ),
                  ],
                ),*/
                SizedBox(height: responsive.dp(3)),
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
                SizedBox(height: responsive.dp(1.5)),
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
                          onPressed: () => _regresar(),
                          child: Text(
                            'REGRESAR',
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

  _aceptar() async {
    String datos = widget.id + '_-,-_' + widget.usuario+ '_-,-_' + widget.estructura+ '_-,-_' + widget.orden+ '_-,-_' + widget.transportista+ '_-,-_' + widget.cliente;
    Map<String, dynamic>? response = await Services.instance.enviaSolicitud('reprogOrdenUsuario', {'userId':widget.token, 'idsPos': datos}, context);
    if (response != null) {
      if (response['codigo'] == 0) {
        Dialogs.dialog(
          context,
          title: 'Shopitrack',
          content: response["mensaje"],
          actions: [
            ParamDialog(
              text: 'Aceptar',
              onPresed: () {
                //Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (_) => false);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            ),
          ]
        );
      }
      else
        Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    }
  }

  _regresar(){
    Navigator.pop(context);
  }
}
