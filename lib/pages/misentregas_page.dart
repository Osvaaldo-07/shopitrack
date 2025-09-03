import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/models/catalogos.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'misentregasdetalle.dart';

class MisentregasPage extends StatefulWidget {
  final String nombre;
  final String token;
  final String imagen;
  TabController mainMenuController;

  MisentregasPage({Key? key, required this.nombre, required this.token, required this.imagen, required this.mainMenuController}) : super(key: key);

  //static final GlobalKey<_HomePageState> _mainTabController = GlobalKey<_HomePageState>();

  @override
  _MisentregasPageState createState() => _MisentregasPageState();
}

class _MisentregasPageState extends State<MisentregasPage> with AfterLayoutMixin {
  //LinkedHashSet params;
  Map<String, dynamic>? response = null;
  late List<dynamic>? lstOrdenes;
  List<Orden> ordenes = [];
  String imageUrl = '';
  //String puntos = '0';

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  _init() async {
    //print(Util.platform);
    //imageUrl = widget.imagen;
    response = await Services.instance.enviaSolicitud('getIniMisentregas', {'userId':widget.token}, null);
    print(response);
    if (response != null) {
      lstOrdenes = response!['ordenes'];
      //print('lst:${lstDirecciones}');
      if (lstOrdenes != null)
        ordenes = lstOrdenes!.map((json) => Orden.fromJson(json)).toList();
      //puntos = response!['totalPuntos'];
    }
    imageUrl = response!['imagen'];
    //_HomePageState.mainMenuController.toa
    setState(() {});
  }

  _shopitrackear(BuildContext context) async {
    //print('share 6');
    //final _controller = PageController();
    //_controller.jumpToPage(1);
    //DefaultTabController.of(context)?.animateTo(2);
    widget.mainMenuController.animateTo(2);
    //_HomePageState.mainMenuController.toAnimate();
    setState(() {});
    //_tabController.animateTo
  }

  @override
  Widget build(BuildContext context) {
    //params = ModalRoute.of(context).settings.arguments;
    //tabController = TabController(length: 2, vsync: this);
    final Responsive responsive = Responsive.of(context);
    //print('token'+widget.token);
    //print('usuario'+widget.usuario);
    //print("Entro al home"+response.toString());
    //print('img'+widget.imagen);
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
              minHeight: responsive.height - heightAppBar - 90, //90:MenuArriba
              //maxHeight: double.infinity
            ),
            /*decoration: BoxDecoration(
              gradient: UtilWidgets.getGradientSys()
            ),*/
            width: double.infinity,
            //height: double.infinity,
            child: response == null ? Container(
              //width: double.infinity,
              //height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              )
            ) : Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: responsive.dp(1.5)),
                /*Text(
                  '¡Bienvenido!',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF1EE545)),
                ),
                SizedBox(height: responsive.dp(1)),
                //HomeForm(data:response),
                IconContainer(
                  width: responsive.hp(12),
                  typeImg: widget.imagen.contains('//') ?  'url' : '',
                  image: imageUrl==''?widget.imagen:imageUrl,
                  radio: 0.5,
                ),
                SizedBox(height: responsive.hp(1)),
                Text(
                  //params.elementAt(0),
                  widget.nombre,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                ),
                SizedBox(height: responsive.dp(1.5)),*/
                ordenes.length==0 ?
                Text(
                  'Aún no tienes entregas\nprogramadas',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF1EE545)),
                  //style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ) :
                Column(
                  children: [
                    Container(
                      height: responsive.hp(45),
                      child: Column(
                        children: <Widget> [
                          Container(
                            width: responsive.wp(100),
                            height: 25,
                            child: Text(
                              'Entregas para hoy',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF1EE545)),
                              //style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: responsive.wp(28),
                                height: 27,
                                child: Text("Cliente",
                                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF00B050),
                                  border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: responsive.wp(20),
                                height: 27,
                                child: Text("Orden",
                                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF00B050),
                                  border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: responsive.wp(17),
                                height: 27,
                                child: Text("Fecha",
                                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF00B050),
                                  border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: responsive.wp(35),
                                height: 27,
                                child: Text("Dirección",
                                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF00B050),
                                  border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: responsive.hp(45)-72,
                            child: dataBody('1')
                          ),
                        ]
                      ),
                    ),
                    SizedBox(height: responsive.hp(0.5)),
                    Container(
                      height: responsive.hp(37),
                      child: Column(
                          children: <Widget> [
                            Container(
                              width: responsive.wp(100),
                              height: 25,
                              child: Text(
                                'Entregas futuras',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF1EE545)),
                                //style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width: responsive.wp(28),
                                  height: 27,
                                  child: Text("Cliente",
                                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC29E40),
                                    border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: responsive.wp(20),
                                  height: 27,
                                  child: Text("Orden",
                                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC29E40),
                                    border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: responsive.wp(17),
                                  height: 27,
                                  child: Text("Fecha",
                                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC29E40),
                                    border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: responsive.wp(35),
                                  height: 27,
                                  child: Text("Dirección",
                                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC29E40),
                                    border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height: responsive.hp(37)-52,
                                child: dataBody('2')
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: responsive.dp(1)),
                /*Stack(
                  alignment: Alignment(0.49, 0.1),
                  children: <Widget> [
                    IconContainer(
                      width: responsive.wp(100),
                      height: responsive.wp(100)*0.58,
                      image: 'puntos.png',
                    ),
                    Container(
                      width: 65,
                      margin: EdgeInsets.only(left: 3),
                      child: Text(
                        puntos,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ]
                ),
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
                        onPressed: () => _shopitrackear(context),
                        child: Text(
                          'Shopitrackealo',
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                        )
                      ),
                    ),
                    SizedBox(width: responsive.wp(8)),
                  ]
                ),
                Text(
                  'y gana puntos canjeables.',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),*/
                SizedBox(height: responsive.dp(1.5)),
              ],
            )
          ),
        )
      ),
    );
  }

  ListView dataBody(String tipo) {
    final Responsive responsive = Responsive.of(context);
    int index = 0;
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        for(final orden in ordenes)
          if (tipo == orden.posicion)
            Card(
              margin: EdgeInsets.all(0),
              color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
              key: ValueKey(orden),
              elevation: 1,
              child: InkWell(
                onTap: () => orden.status!='Re Programada por Usuario' ? _muestraDetalle(orden.id, orden.usuario, orden.orden, orden.direccion, orden.fechaentrega, orden.estructura!, orden.transportista!, orden.cliente!) : null,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: responsive.wp(28),
                          child: Text(orden.cliente!,
                            style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: responsive.wp(20),
                          child: Text(orden.orden,
                            style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                          decoration: BoxDecoration(
                            color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                            //border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: responsive.wp(17),
                          child: Text(orden.fechaentrega!='01/01/2100' ? orden.fechaentrega : '',
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
                          child: Text(orden.direccion,
                            style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            color: index++ % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  _muestraDetalle(String id, String usuario, String orden, String direccion, String fecha, String estructura, String transportista, String cliente) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MisentregasDetallePage(token:widget.token, id:id, usuario:usuario, imagen:widget.imagen, imageUrl:imageUrl, nombre:widget.nombre, orden:orden, direccion:direccion, fecha:fecha, estructura:estructura, transportista:transportista, cliente:cliente)));
  }
}
