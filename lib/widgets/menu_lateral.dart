import 'package:shopitrack/pages/editaperfil_page.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class MenuLateral extends StatefulWidget {
  final String nombre;
  final String imagen;
  final String tipo;

  MenuLateral({Key? key, required this.nombre, required this.imagen, required this.tipo}) : super(key: key);

  @override
  _MenuLateralState createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      color: Color(0xFF1846E8),
      width: responsive.wp(80),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              //color: Colors.red,
              child: Column(
                children: <Widget> [
                  SizedBox(height: responsive.dp(0.5)),
                  IconContainer(
                    width: responsive.hp(13),
                    typeImg: widget.imagen.contains('//') ?  'url' : "",
                    image: widget.imagen,
                    radio: 0.5,
                  ),
                  SizedBox(height: responsive.dp(0.75)),
                  Text(
                    widget.nombre,
                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  //SizedBox(height: responsive.dp(0.25)),
                  MaterialButton(//FlatButton(
                    child: Text(
                      'Editar Cuenta',
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async{
                      Navigator.pop(context);
                      /*newImage = await */Navigator.push(context, MaterialPageRoute<String>(builder: (context) => EditaPerfilPage(tipo:widget.tipo)));
                      //setState(() {});
                    },
                  ),
                  //SizedBox(height: responsive.dp(0.25)),
                  Divider(
                    color: Colors.white,
                    height: 1,
                    thickness: 1,
                  ),
                ]
              ),
            ),
            Expanded(
              child: Container(
                //color: Colors.brown,
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    SizedBox(height: responsive.dp(0.5)),
                    Text(
                      'GENERAL',
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                    ),
                    SizedBox(height: responsive.dp(0.5)),
                  ],
                ),
              ),
            ),
            Container(
              //color: Colors.green,
              child: Column(
                children: <Widget> [
                  Divider(
                    color: Colors.white,
                    height: 1,
                    thickness: 1,
                  ),
                  /*ListTile(
                    title: Text(
                      "Cerrar sesión",
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                    ),
                    onTap: () => Auth.instance.logOut(context),
                  )*/
                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(//FlatButton(
                          padding: EdgeInsets.only(left: 0, right: responsive.wp(40)),
                          child: Text(
                            "Cerrar sesión",
                            style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () => Auth.instance.logOut(context),
                        ),
                      ),
                    ],
                  )
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}
