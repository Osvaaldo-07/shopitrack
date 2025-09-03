import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/models/catalogos.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class TusEntregasFuturasPage extends StatefulWidget {
  final String token;

  TusEntregasFuturasPage({Key? key, required this.token}): super(key: key);

  @override
  _TusEntregasFuturasPageState createState() => _TusEntregasFuturasPageState();
}

class _TusEntregasFuturasPageState extends State<TusEntregasFuturasPage> with AfterLayoutMixin {
  Map<String, dynamic>? response = null;
  late List<dynamic> lstOrdenes;
  late List<Orden> ordenes;

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  _init() async {
    response = await Services.instance.enviaSolicitud('getIniOrdenesFuturas', {'userId':widget.token}, null);
    print('response:$response');
    if (response != null) {
      lstOrdenes = response!['ordenes'];
      ordenes = lstOrdenes.map((json) => Orden.fromJson(json)).toList();
      setState(() {});
    }
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
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Column(
                    children: <Widget> [
                      SizedBox(height: responsive.dp(1.5)),
                      Text(
                        'TUS ENTREGAS FUTURAS',
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: responsive.dp(1.5)),
                    ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                  ],
                ),
                lstOrdenes.length==0 ?
                Text(
                  'No tiene entregas futuras registradas',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ) :
                Expanded(
                  child: dataBody(),
                ),
                SizedBox(height: responsive.dp(1.5)),
                /*Column(
                    children: <Widget> [
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
                                  disabledColor: Colors.grey,
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    _btnRuta==Util.INICIA_RUTA ? 'Iniciar Ruta' : _btnRuta==Util.EN_RUTA ? 'Finalizar Ruta' : 'Ruta finalizada',
                                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                                  ),
                                  onPressed: _btnRuta==Util.INICIA_RUTA ? _iniciarRuta : _btnRuta==Util.EN_RUTA ? _finalizarRuta : null,
                              ),
                            ),
                            SizedBox(width: responsive.wp(8)),
                          ]
                      ),
                      SizedBox(height: responsive.dp(1.5)),
                    ]
                )*/
              ],
            )
        ),
      ),
    );
  }

  /*_iniciarRuta() async {
    print('inicia ruta');
    if (!ordenes.isEmpty) {
      String datos = '';
      var index = 0;
      for (final orden in ordenes) {
        datos += orden.id + '_' + index.toString() + '-';
        index++;
      }
      datos = datos.length > 0 ? datos.substring(0, datos.length - 1) : datos;
      print('datos: ${datos}');
      response = await Services.instance.enviaSolicitud('iniciaRuta', {'userId': widget.token, 'idsPos': datos}, context);
      if (response != null && response['codigo'] == 0) {
        Dialogs.dialog(context, title: "Shopitrack", content: response["mensaje"]);
        _init();
      }
      else
        Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    }
    else {
      Dialogs.dialog(context, title: "Shopitrack", content:'No cuenta con ordenes en su Ruta');
    }
  }*/

  /*_finalizarRuta() async {
    print('fin de ruta');
    String datos = '';
    var index = 0;
    for (final orden in ordenes){
      if (orden.status!=Util.ORDEN_ENTREGADA && orden.status!=Util.ORDEN_CANCELADA && orden.status!=Util.ORDEN_REPROGRAMADA)
        datos += orden.id + '_-,-_' + orden.usuario + '-_,_-';
    }
    datos = datos.length > 0 ? datos.substring(0, datos.length - 5) : datos;
    print('datos: ${datos}');
    if (datos != '') {
      response = await Services.instance.enviaSolicitud('finalizaRuta', {'userId': widget.token, 'idsPos': datos}, context);
      if (response != null && response['codigo'] == 0) {
        Dialogs.dialog(context, title: "Shopitrack", content: response["mensaje"]);
        _init();
      }
      else
        Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    }
    else
      setState(() {});
  }*/

  /*void reorderData(int oldindex, int newindex){
    //print('${oldindex} - ${newindex}');
    setState(() {
      if(newindex > oldindex)
        newindex-=1;
      final items = ordenes.removeAt(oldindex);
      ordenes.insert(newindex, items);
    });
  }*/

  ListView dataBody() {
    final Responsive responsive = Responsive.of(context);
    int index = 0;
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        //for(final items in item)
        for(final orden in ordenes)
          Card(
            margin: EdgeInsets.all(0),
            color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
            key: ValueKey(orden),
            elevation: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: responsive.wp(20),
                  child: Text(orden.orden,
                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                    //border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: responsive.wp(35),
                  child: Text(orden.direccion,
                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                    border: Border.all(width:0.5, color: Color(0xFF1846E8)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: responsive.wp(28),
                  child: Text(orden.nombre.trim()=='' ? orden.usuario : orden.nombre,
                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                    border: Border.symmetric(vertical: BorderSide(width:0.5, color: Color(0xFF1846E8))),
                  ),
                ),
                /*InkWell(
                  onTap: () {
                    if (_btnRuta == Util.EN_RUTA)
                      if (orden.status!=Util.ORDEN_ENTREGADA && orden.status!=Util.ORDEN_RECOGIDA && orden.status!=Util.ORDEN_CANCELADA)
                        _muestraOpciones(orden);
                  },
                  child: */Container(
                    padding: EdgeInsets.only(top:5, bottom:5),
                    alignment: Alignment.center,
                    width: responsive.wp(17),
                    child: Text(orden.fechaentrega,
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 11, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                        color: index++ % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
                      /*color: orden.status==Util.ORDEN_PROGRAMADA ? Colors.grey : orden.status==Util.ORDEN_REPROGRAMADA ? Colors.brown :
                        orden.status==Util.ORDEN_SIGUIENTE ? Colors.green : orden.status==Util.ORDEN_FALLIDO ? Colors.red :
                        orden.status==Util.ORDEN_CANCELADA ? Colors.deepOrange : orden.status==Util.ORDEN_ENTREGADA ? Colors.yellow :
                        orden.status==Util.ORDEN_ENRUTA ? Colors.blueAccent : Colors.amber*/
                    ),
                  ),
                //)
              ],
            ),
          ),
      ],
      //onReorder: reorderData,
    );
  }

  /*_muestraOpciones(orden){
    print("Container clicked ${orden.id} - ${orden.posicion}");
    if (orden.status == Util.ORDEN_ENRUTA){
      Dialogs.dialog(
        context,
        title: 'Shopitrack',
        content: 'SELECCIONA UN ESTATUS:',
        actions: [
          ParamDialog(
              text: 'Siguiente Entrega',
              onPresed: () => _ejecutaSiguienteEntrega(orden.id, orden.usuario, orden.direccion)
              /*onPresed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapaPage(token:widget.token, direccion:orden.direccion)),
                );
              }*/
          ),
          ParamDialog(
              text: 'Re Programar',
              onPresed: () => _ejecutaReprogramacion(orden.id, orden.usuario)
          ),
          ParamDialog(
              text: 'Cerrar ventana',
              onPresed: () => Navigator.pop(context)
          ),
        ]
      );
    }
    if (orden.status == Util.ORDEN_SIGUIENTE) {
      Dialogs.dialog(
          context,
          title: 'Shopitrack',
          content: 'SELECCIONA UN ESTATUS:',
          actions: [
            ParamDialog(
                text: 'Entregado',
                onPresed: () => _ejecutaEntregado(orden.id, orden.usuario)
            ),
            ParamDialog(
                text: 'Recolección',
                onPresed: () => _ejecutaRecogido(orden.id, orden.usuario)
            ),
            ParamDialog(
                text: 'Re Programar',
                onPresed: () => _ejecutaReprogramacion(orden.id, orden.usuario)
            ),
            ParamDialog(
                text: 'Intento Fallido',
                onPresed: () => _ejecutaFallido(orden.id, orden.usuario)
            ),
            ParamDialog(
                text: 'Cerrar ventana',
                onPresed: () => Navigator.pop(context)
            ),
          ]
      );
      if (orden.status == Util.ORDEN_REPROGRAMADA) {
        Dialogs.dialog(
            context,
            title: 'Shopitrack',
            content: 'SELECCIONA UN ESTATUS:',
            actions: [
              ParamDialog(
                  text: 'Siguiente Entrega',
                  onPresed: () => _ejecutaSiguienteEntrega(orden.id, orden.usuario, orden.direccion)
                  /*onPresed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MapaPage(token: widget.token, direccion: orden.direccion)),
                    );
                  }*/
              ),
              ParamDialog(
                  text: 'Cerrar ventana',
                  onPresed: () => Navigator.pop(context)
              ),
            ]
        );
      }
      if (orden.status == Util.ORDEN_FALLIDO) {
        Dialogs.dialog(
            context,
            title: 'Shopitrack',
            content: 'SELECCIONA UN ESTATUS:',
            actions: [
              ParamDialog(
                  text: 'Siguiente Entrega',
                  onPresed: () => _ejecutaSiguienteEntrega(orden.id, orden.usuario, orden.direccion)
                  /*onPresed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MapaPage(token: widget.token, direccion: orden.direccion)),
                    );
                  }*/
              ),
              ParamDialog(
                  text: 'Cerrar ventana',
                  onPresed: () => Navigator.pop(context)
              ),
            ]
        );
      }
    }
  }

  _ejecutaReprogramacion(id, correo) async {
    print('ejecuta reprogramacion');
    String datos = id + '_-,-_' + correo;
    print('datos: ${datos}');
    response = await Services.instance.enviaSolicitud('ejecutaReprogramacion', {'userId': widget.token, 'idsPos': datos}, context);
    Navigator.pop(context);
    if (response != null && response['codigo'] == 0) {
      Dialogs.dialog(context, title: "Shopitrack", content: response["mensaje"]);
      _init();
    }
    else
      Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    setState(() {});
  }

  _ejecutaRecogido(id, correo) async {
    print('ejecuta recogido');
    String datos = id + '_-,-_' + correo;
    print('datos: ${datos}');
    response = await Services.instance.enviaSolicitud('ejecutaRecogido', {'userId': widget.token, 'idsPos': datos}, context);
    Navigator.pop(context);
    if (response != null && response['codigo'] == 0) {
      Dialogs.dialog(context, title: "Shopitrack", content: response["mensaje"]);
      _init();
    }
    else
      Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    setState(() {});
  }

  _ejecutaFallido(id, correo) async {
    print('ejecuta fallido');
    String datos = id + '_-,-_' + correo;
    print('datos: ${datos}');
    response = await Services.instance.enviaSolicitud('ejecutaFallido', {'userId': widget.token, 'idsPos': datos}, context);
    Navigator.pop(context);
    if (response != null && response['codigo'] == 0) {
      Dialogs.dialog(context, title: "Shopitrack", content: response["mensaje"]);
      _init();
    }
    else
      Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    setState(() {});
  }

  _ejecutaEntregado(id, correo) async {
    print('ejecuta entregado');
    String datos = id + '_-,-_' + correo;
    print('datos: ${datos}');
    response = await Services.instance.enviaSolicitud('ejecutaEntregado', {'userId': widget.token, 'idsPos': datos}, context);
    Navigator.pop(context);
    if (response != null && response['codigo'] == 0) {
      Dialogs.dialog(context, title: "Shopitrack", content: response["mensaje"]);
      _init();
    }
    else
      Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    setState(() {});
  }

  _ejecutaSiguienteEntrega(id, correo, direccion) async {
    print('ejecuta siguienteEntrega');
    String datos = id + '_-,-_' + correo;
    print('datos: ${datos}');
    response = await Services.instance.enviaSolicitud('ejecutaSiguienteEntrega', {'userId': widget.token, 'idsPos': datos}, context);
    Navigator.pop(context);
    if (response != null && response['codigo'] == 0) {
      Dialogs.dialog(context, title: "Shopitrack", content: response["mensaje"]);
      _init();
    }
    else
      Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MapaPage(token: widget.token, direccion: direccion)));
    setState(() {});
  }*/

/*SingleChildScrollView dataBody1() {
    final Responsive responsive = Responsive.of(context);
    int index = 0;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
          showBottomBorder: true,
          horizontalMargin: 2,
          headingRowHeight: 35,
          dataRowHeight: 86,
          columnSpacing: 1,
          dataTextStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.white),
          columns: [
            DataColumn(label: Text("Orden")),
            DataColumn(label: Text("Dirección")),
            DataColumn(label: Text("Cliente")),
            DataColumn(label: Text("Status")),
          ],
          rows: ordenes.map((ord) {
            index++;
            return DataRow(
                cells: [
                  DataCell(
                    Container(
                      child: Center(child: Text(ord.orden)),
                      width: responsive.wp(20),
                      height: responsive.wp(20),
                      decoration: BoxDecoration(color: index%2==0?Color(0xFF3E68FD):Color(0xFF182F9F)),
                    ),
                    //onTap: () => _actualizaDireccion(widget.token, dir.id, dir.calle, dir.exterior, dir.interior, dir.colonia, dir.cp, dir.ciudad, dir.municipio, dir.alias, dir.imagen),
                  ),
                  DataCell(
                    Container(
                      child: Center(child: Text(ord.direccion)),
                      width: responsive.wp(35),
                      height: responsive.wp(20),
                      decoration: BoxDecoration(color: index%2==0?Color(0xFF3E68FD):Color(0xFF182F9F)),
                    ),
                    //onTap: () => _actualizaDireccion(widget.token, dir.id, dir.calle, dir.exterior, dir.interior, dir.colonia, dir.cp, dir.ciudad, dir.municipio, dir.alias, dir.imagen),
                  ),
                  DataCell(
                    Container(
                      child: Center(child: Text('Osvaldo')),
                      //child: Center(child: Text(ord.nombre)),
                      width: responsive.wp(30),
                      height: responsive.wp(20),
                      decoration: BoxDecoration(color: index%2==0?Color(0xFF3E68FD):Color(0xFF182F9F)),
                    ),
                    //onTap: () => _actualizaDireccion(widget.token, dir.id, dir.calle, dir.exterior, dir.interior, dir.colonia, dir.cp, dir.ciudad, dir.municipio, dir.alias, dir.imagen),
                  ),
                  DataCell(
                    Container(
                      child: Center(child: Text(ord.status)),
                      /*child: Center(
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white, size: 25),
                        ),
                      ),*/
                      width: responsive.wp(13),
                      height: responsive.wp(20),
                      decoration: BoxDecoration(color: index%2==0?Color(0xFF3E68FD):Color(0xFF182F9F)),
                    ),
                      onTap: (){
                        Dialogs.dialog(
                            context,
                            title: 'Status',
                            content: 'SELECCIONA UN ESTATUS:',
                            actions: [
                              ParamDialog(
                                  text: 'Reprogramar',
                                  onPresed: () {
                                    //_pickImage(true);
                                    Navigator.pop(context);
                                  }
                              ),
                              ParamDialog(
                                  text: 'Siguiente Entrega',
                                  onPresed: () {
                                    //_pickImage(false);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MapaPage(token:widget.token, direccion:ord.direccion)),
                                    );
                                  }
                              ),
                              ParamDialog(
                                  text: 'Entregado',
                                  onPresed: () => Navigator.pop(context)
                              ),
                              ParamDialog(
                                  text: 'Recolección',
                                  onPresed: () => Navigator.pop(context)
                              ),
                              ParamDialog(
                                  text: 'Intento Fallido',
                                  onPresed: () => Navigator.pop(context)
                              ),
                              ParamDialog(
                                  text: 'En Ruta',
                                  onPresed: () => Navigator.pop(context)
                              ),
                              ParamDialog(
                                  text: 'Cancelar',
                                  onPresed: () => Navigator.pop(context)
                              ),
                            ]
                        );
                      }
                    //onTap: () => _eliminaDireccion(dir.id),
                  )
                ]);
          }
          ).toList()
      ),
    );
  }*/
}
