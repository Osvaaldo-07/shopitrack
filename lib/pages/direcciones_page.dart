import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/models/Parametros.dart';
import 'package:shopitrack/models/catalogos.dart';
import 'package:shopitrack/pages/agregadireccion_page.dart';
import 'package:shopitrack/pages/editadireccion_page.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/util/dialogs.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class DireccionesPage extends StatefulWidget {
  //static const routeName = "home";
  final String token;

  DireccionesPage({Key? key, required this.token}): super(key: key);

  @override
  _DireccionesPageState createState() => _DireccionesPageState();
}

class _DireccionesPageState extends State<DireccionesPage> with AfterLayoutMixin {
  Map<String, dynamic>? response = null;
  late List<dynamic> lstDirecciones;
  late List<Direccion> direcciones;
  late String? respPop;

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  _init() async {
    response = await Services.instance.enviaSolicitud('getIniDirecciones', {'userId':widget.token}, null);
    //print('response:${response}');
    if (response != null) {
      lstDirecciones = response!['direcciones'];
      //print('lst:${lstDirecciones}');
      direcciones = lstDirecciones.map((json) => Direccion.fromJson(json)).toList();
      //print('direcciones:${direcciones}');
      //print('direcciones:${direcciones[0].imagen}lll');
      setState(() {});
    }
  }

  _agregaDireccion(String token) async {
    respPop = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) => AgregaDireccionPage(token: token)));
    print(respPop);
    if (respPop == 'OK'){
      response = await Services.instance.enviaSolicitud('getIniDirecciones', {'userId':widget.token}, context);
      if (response != null) {
        lstDirecciones = response!['direcciones'];
        //print(lstDirecciones);
        direcciones = lstDirecciones.map((json) => Direccion.fromJson(json)).toList();
        setState(() {});
      }
    }
  }

  _actualizaDireccion(String token, String id, String calle, String exterior, String interior, String colonia, String cp, String ciudad, String municipio, String alias, String imagen) async {
    respPop = (await Navigator.push(context, MaterialPageRoute<String>(builder: (context) => EditaDireccionPage(token: token, id: id, calle: calle, exterior: exterior, interior: interior, colonia: colonia, cp: cp, ciudad: ciudad, municipio: municipio, alias: alias, imagen: imagen))))!;
    print(respPop);
    if (respPop == 'OK'){
      response = await Services.instance.enviaSolicitud('getIniDirecciones', {'userId':widget.token}, context);
      if (response != null) {
        lstDirecciones = response!['direcciones'];
        direcciones = lstDirecciones.map((json) => Direccion.fromJson(json)).toList();
        setState(() {});
      }
    }
  }

  _eliminaDireccion(String id) async {
    Dialogs.dialog(
      context,
      title: 'Aviso',
      content: '¿Esta seguro de elimainar esta dirección de su lista?:',
      actions: [
        ParamDialog(
          text: 'Sí',
          onPresed: () async {
            Navigator.pop(context);
            response = await Services.instance.enviaSolicitud('eliminaDireccion', {'userId':widget.token, 'id':id}, context);
            if (response != null) {
              lstDirecciones = response!['direcciones'];
              direcciones = lstDirecciones.map((json) => Direccion.fromJson(json)).toList();
              setState(() {});
            }
          }
        ),
        ParamDialog(
          text: 'Cancelar',
          onPresed: () => Navigator.pop(context)
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
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
            child: Center(
              child: CircularProgressIndicator(),
            )
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Column(
                children: <Widget> [
                  SizedBox(height: responsive.dp(1.5)),
                  Text(
                    'Mis Direcciones',
                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF1EE545)),
                  ),
                ]
              ),
              lstDirecciones.length==0 ?
              Text(
                'No tiene direcciones registradas',
                style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
              ) :
              Expanded(
                child: dataBody(),
              ),
              SizedBox(height: responsive.dp(1.5)),
              Column(
                children: <Widget> [
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
                          onPressed: () => _agregaDireccion(widget.token),
                          child: Text(
                            'AGREGAR DIRECCIÓN',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                          )
                        ),
                      ),
                      SizedBox(width: responsive.wp(8)),
                    ]
                  ),
                  SizedBox(height: responsive.dp(1.5)),
                ]
              )
            ],
          )
        ),
      ),
    );
  }

  SingleChildScrollView dataBody() {
    final Responsive responsive = Responsive.of(context);
    int index = 0;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        showBottomBorder: true,
        horizontalMargin: 5,
        headingRowHeight: 10,
        dataRowHeight: 86,
        columnSpacing: 2,
        dataTextStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.white),
        columns: [
          DataColumn(label: Text("")),
          DataColumn(label: Text("")),
          DataColumn(label: Text("")),
          DataColumn(label: Text("")),
        ],
        rows: direcciones.map((dir) {
          index++;
          return DataRow(
            cells: [
              DataCell(
                IconContainer(
                  width: responsive.wp(26),
                  height: responsive.wp(20),
                  typeImg: dir.imagen.contains('//') ?  'url' : '',
                  image: dir.imagen,
                  radio: 0.1,
                ),
                onTap: () => _actualizaDireccion(widget.token, dir.id, dir.calle, dir.exterior, dir.interior, dir.colonia, dir.cp, dir.ciudad, dir.municipio, dir.alias, dir.imagen),
              ),
              DataCell(
                Container(
                  child: Center(child: Text(dir.municipio)),
                  width: responsive.wp(30),
                  height: responsive.wp(20),
                  decoration: BoxDecoration(color: index%2==0?Color(0xFF3E68FD):Color(0xFF182F9F)),
                ),
                onTap: () => _actualizaDireccion(widget.token, dir.id, dir.calle, dir.exterior, dir.interior, dir.colonia, dir.cp, dir.ciudad, dir.municipio, dir.alias, dir.imagen),
              ),
              DataCell(
                Container(
                  child: Center(child: Text(dir.alias)),
                  width: responsive.wp(30),
                  height: responsive.wp(20),
                  decoration: BoxDecoration(color: index%2==0?Color(0xFF3E68FD):Color(0xFF182F9F)),
                ),
                onTap: () => _actualizaDireccion(widget.token, dir.id, dir.calle, dir.exterior, dir.interior, dir.colonia, dir.cp, dir.ciudad, dir.municipio, dir.alias, dir.imagen),
              ),
              DataCell(
                Container(
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white, size: 25), onPressed: () {  },
                    ),
                  ),
                  width: responsive.wp(10),
                  height: responsive.wp(20),
                  decoration: BoxDecoration(color: index%2==0?Color(0xFF3E68FD):Color(0xFF182F9F)),
                ),
                onTap: () => _eliminaDireccion(dir.id),
              )
            ]);
          }
        ).toList()
      ),
    );
  }
}
