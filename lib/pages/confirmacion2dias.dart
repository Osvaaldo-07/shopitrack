import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/models/Parametros.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/util/dialogs.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'home_page.dart';

class Confirmacion2DiasPage extends StatefulWidget {
  static const routeName = "confirmacio2dias";
  final String nombre;
  final String token;
  final String id;
  final String usuario;
  final String orden;
  final String direccion;
  String fecha;
  final String estructura;
  String transportista;
  final String cliente;

  Confirmacion2DiasPage({Key? key, required this.token, required this.id, required this.usuario, required this.nombre, required this.orden, required this.direccion, required this.fecha, required this.estructura, required this.transportista, required this.cliente}) : super(key: key);
  //Confirmacion2DiasPage({Key? key, required this.id, required this.usuario, required this.nombre, required this.orden, required this.direccion, required this.fecha, required this.transportista, required this.cliente}) : super(key: key);

  @override
  _Confirmacion2DiasPageState createState() => _Confirmacion2DiasPageState();
}

class _Confirmacion2DiasPageState extends State<Confirmacion2DiasPage> with AfterLayoutMixin {

  Session? session = null;
  Map<String, dynamic>? response = null;
  String _statusOrden = '';

  void afterFirstLayout(BuildContext context){
    this._init();
  }

  _init() async {
    print('transportista:${widget.transportista} - fecha:${widget.fecha}');
    if (widget.transportista == '' && widget.fecha == '') {
      session = await Auth.instance.accessToken;
      response = await Services.instance.enviaSolicitud('validaNotifConfirm2Dias', {'userId': session!.token, 'idsPos': widget.id}, null);
      //print(response);
      if (response != null) {
        _statusOrden = response!['status'];
        widget.transportista = response!['transportista'];
        widget.fecha = response!['fecha'];
      }
      setState(() {});
    }
  }

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
                  'Confirmación de Entrega',
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
                        'Tu orden ${widget.orden} - ${widget.cliente}, con dirección de entrega ${widget.direccion}, estará en ruta el próximo ${widget.fecha}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                _statusOrden!='RU' ? SizedBox(height: responsive.dp(3)) : SizedBox(height: responsive.dp(0)),
                _statusOrden!='RU' ? Row(
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
                        onPressed: () => _confirmar(),
                        child: Text(
                          'CONFIRMAR',
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                        )
                      ),
                    ),
                    SizedBox(width: responsive.wp(8)),
                  ]
                ) : SizedBox(height: responsive.dp(0)),
                _statusOrden!='RU' ? SizedBox(height: responsive.dp(1.5)) : SizedBox(height: responsive.dp(0)),
                _statusOrden!='RU' ? Row(
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
                        onPressed: () => _reprogramar(),
                        child: Text(
                          'REPROGRAMAR',
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                        )
                      ),
                    ),
                    SizedBox(width: responsive.wp(8)),
                  ]
                ) : SizedBox(height: responsive.dp(0)),
                SizedBox(height: responsive.dp(5)),
              ],
            )
          ),
        )
      ),
    );
  }

  _reprogramar() async {
    String datos = widget.id + '_-,-_' + widget.usuario+ '_-,-_' + widget.estructura+ '_-,-_' + widget.orden+ '_-,-_' + widget.transportista + '_-,-_' + widget.cliente;
    //String datos = widget.id + '_-,-_' + widget.usuario+ '_-,-_' + widget.estructura+ '_-,-_' + widget.orden+ '_-,-_' + widget.transportista + '_-,-_' + widget.cliente;
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
              onPresed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              } //Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (_) => false)
            ),
          ]
        );
      }
      else
        Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    }
  }

  _confirmar(){
    Navigator.pop(context);
  }
}
