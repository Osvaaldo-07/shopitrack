import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class MisenviosPage extends StatefulWidget {
  final String nombre;
  final String token;
  final String imagen;

  MisenviosPage({Key? key, required this.nombre, required this.token, required this.imagen}) : super(key: key);

  @override
  _MisenviosPageState createState() => _MisenviosPageState();
}

class _MisenviosPageState extends State<MisenviosPage> with AfterLayoutMixin {
   Map<String, dynamic>? response = null;
  String imageUrl = '';

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  _init() async {
    response = await Services.instance.enviaSolicitud('getIniMisentregas', {'userId':widget.token}, context);
    //print(response);
    if (response != null)
      imageUrl = response!['imagen'];
    setState(() {});
  }

  _shopitrackear() {

  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double heightAppBar = MediaQuery.of(context).padding.top + kToolbarHeight + 62;//62:menuAbajo
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: responsive.isTablet ? 430 : responsive.width,
              minHeight: responsive.height - heightAppBar - 90 //90:MenuArriba
            ),
            /*decoration: BoxDecoration(
              gradient: UtilWidgets.getGradientSys()
            ),*/
            width: double.infinity,
            child: response == null ? Container(
              //width: double.infinity,
              //height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              )
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: responsive.dp(0.25)),
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
                IconContainer(
                  width: responsive.hp(15),
                  typeImg: widget.imagen.contains('//') ?  'url' : '',
                  image: imageUrl==''?widget.imagen:imageUrl,
                  radio: 0.5,
                ),
                //SizedBox(height: responsive.hp(0.25)),
                Text(
                  //params.elementAt(0),
                  widget.nombre,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                ),
                //SizedBox(height: responsive.dp(0.5)),
                Text(
                  'Aún no tienes entregas\nprogramadas',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
                //SizedBox(height: responsive.dp(1)),
                Stack(
                  alignment: Alignment(0.49, 0.1),
                  children: <Widget> [
                    IconContainer(
                      width: responsive.wp(100),
                      height: responsive.wp(100)*0.58,
                      image: 'puntos.png',
                    ),
                    Text(
                      '1000',
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                    )
                  ]
                ),
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
                        onPressed: () => _shopitrackear(),
                        child: Text(
                          'SHOPITRACKEALO',
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                        )
                      ),
                    ),
                    SizedBox(width: responsive.wp(8)),
                  ]
                ),
                Text(
                  '¡Y gana más puntos',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: responsive.dp(0.25)),
              ],
            )
          ),
        )
      ),
    );
  }
}
