import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/models/Parametros.dart';
import 'package:shopitrack/models/catalogos.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/util/dialogs.dart';
import 'package:shopitrack/util/util.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'mapa_page.dart';

class TusEntregasPage extends StatefulWidget {
	final String token;

	TusEntregasPage({Key? key, required this.token}): super(key: key);

	@override
	_TusEntregasPageState createState() => _TusEntregasPageState();
}

class _TusEntregasPageState extends State<TusEntregasPage> with AfterLayoutMixin {
	bool ordenable = true;
	Map<String, dynamic>? response = null;
	late List<dynamic> lstOrdenes;
	late List<Orden> ordenes;
	late int _btnRuta = Util.INICIA_RUTA;
	late String respPop;

	@override
	void afterFirstLayout(BuildContext context){
		this._init();
	}

	_init() async {
		response = (await Services.instance.enviaSolicitud('getIniOrdenes', {'userId':widget.token}, null))!;
		print('response:$response');
		if (response != null) {
			lstOrdenes = response!['ordenes'];
			ordenes = lstOrdenes.map((json) => Orden.fromJson(json)).toList();
			if (ordenes.isEmpty)
				_btnRuta = Util.FIN_RUTA;
			else {
				if (ordenes.elementAt(0).status == Util.ORDEN_PROGRAMADA)
					_btnRuta = Util.INICIA_RUTA;
				else {
					_btnRuta = Util.FIN_RUTA;
					for (final orden in ordenes)
						if (orden.status == Util.ORDEN_ENRUTA || orden.status == Util.ORDEN_SIGUIENTE || orden.status == Util.ORDEN_FALLIDO || orden.status == Util.ORDEN_REPROGRAMADA || orden.status == Util.ORDEN_RETRASO)
							_btnRuta = Util.EN_RUTA;
				}
			}
			setState(() {});
		}
	}

	_actualizaLista() {
		//print(ordenable);
		setState(() {ordenable = !ordenable;});
	}

	Container _genHeader(String titulo, double ancho){
		final Responsive responsive = Responsive.of(context);
		return Container(
			alignment: Alignment.center,
			width: responsive.wp(ancho),
			height: 27,
			child: Text(titulo,
				style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
				textAlign: TextAlign.center,
			),
			decoration: BoxDecoration(
				color: Color(0xFF00B050),
				border: Border.all(width:0.5, color: Color(0xFF1846E8)),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		print("entra");
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
									Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: <Widget>[
											SizedBox(width:24),
											Text(
												'TUS ENTREGAS',
												style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
											),
											_btnRuta==Util.INICIA_RUTA ? IconContainer(
												width: 24,
												image: ordenable ? 'iconos/ordenar.png' : 'iconos/listo.png',
												margin: EdgeInsets.only(right: 12),
												onTap: (){_actualizaLista();},
											) :
											SizedBox(width:24),
										],
									),
									SizedBox(height: responsive.dp(1.5)),
								]
							),
							Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									_genHeader('Orden', 20),
									_genHeader('Dirección', 35),
									_genHeader('Cliente', 28),
									_genHeader('Status', 17),
								],
							),
							lstOrdenes.length==0 ?
							Text(
								'No tiene entregas registradas',
								style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
							) :
							Expanded(
								child: ordenable ? RefreshIndicator(
									child: dataBody(),
									onRefresh: refreshList,
								) : dataBodySort(),
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
							)
						],
					)
				),
			),
		);
	}

	Future<void> refreshList() async {
		await _init();
	}

	_iniciarRuta() async {
		print('inicia ruta');
		ordenable = true;
		if (ordenes.isNotEmpty) {
			String datos = '';
			var index = 0;
			for (final orden in ordenes) {
				datos += orden.id + '_-,-_' + index.toString() + '_-,-_' + orden.usuario + '-_,_-';
				index++;
			}
			datos = datos.length > 0 ? datos.substring(0, datos.length - 5) : datos;
			print('datos: $datos');
			response = await Services.instance.enviaSolicitud('iniciaRuta', {'userId': widget.token, 'idsPos': datos}, context);
			if (response != null) {
				if (response!['codigo'] == 0) {
					Dialogs.dialog(context, title: "Shopitrack", content: response!["mensaje"]);
					_init();
				}
				else
					Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
			}
		}
		else
			Dialogs.dialog(context, title: "Shopitrack", content:'No cuenta con ordenes en su Ruta');
	}

	_finalizarRuta() async {
		print('fin de ruta');
		String datos = '';
		for (final orden in ordenes){
			if (orden.status!=Util.ORDEN_ENTREGADA && orden.status!=Util.ORDEN_CANCELADA && orden.status!=Util.ORDEN_REPROGRAMADA && orden.status!=Util.ORDEN_RECOGIDA)
				datos += orden.id + '_-,-_' + orden.usuario + '-_,_-';
		}
		datos = datos.length > 0 ? datos.substring(0, datos.length - 5) : datos;
		print('datos: $datos');
		if (datos != '') {
			response = await Services.instance.enviaSolicitud('finalizaRuta', {'userId': widget.token, 'idsPos': datos}, context);
			if (response != null) {
				if (response!['codigo'] == 0) {
					Dialogs.dialog(context, title: "Shopitrack", content: response!["mensaje"]);
					_init();
				}
				else
					Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
			}
		}
		else
			setState(() {});
	}

	void reorderData(int oldindex, int newindex){
		//print('$oldindex - $newindex');
		setState(() {
			if(newindex > oldindex)
				newindex-=1;
			final items = ordenes.removeAt(oldindex);
			ordenes.insert(newindex, items);
		});
	}

	ListView dataBody() {
		return ListView(
			padding: EdgeInsets.all(0),
			children: _generaLista()
		);
	}

	ReorderableListView dataBodySort() {
		return ReorderableListView(
			padding: EdgeInsets.all(0),
			children: _generaLista(),
			onReorder: reorderData,
		);
	}

	List<Widget> _generaLista(){
		final Responsive responsive = Responsive.of(context);
		int index = 0;
		List <Widget> lista = [];
		bool flagHabil = true;
		int contHabil = 0;
		for(final orden in ordenes) {
			print('Habil $flagHabil');
			if (contHabil<=1 && orden.status==Util.ORDEN_ENRUTA){
				if (contHabil == 1)
					flagHabil = false;
				contHabil++;
			}
			lista.add(Card(
				margin: EdgeInsets.all(0),
				color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
				key: ValueKey(orden),
				elevation: 1,
				child: Column(
					children: <Widget>[
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: <Widget>[
								InkWell(
									onTap: flagHabil ? () {
										if (_btnRuta == Util.EN_RUTA && orden.status == Util.ORDEN_SIGUIENTE)
											//if (flagHabil)
											_muestraOpciones(orden);
									} : null,
									child: Container(
										alignment: Alignment.center,
										width: responsive.wp(20),
										child: ordenable ? Text(orden.orden,
											style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
											textAlign: TextAlign.center,
										) :
										Icon(Icons.menu, color: Colors.white,),
										decoration: BoxDecoration(color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
												//border: Border.all(width:0.5, color: Color(0xFF1846E8)),
										),
									),
								),
								Container(
									alignment: Alignment.center,
									width: responsive.wp(35),
									child: Text(orden.direccion,
										style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
										textAlign: TextAlign.left,
									),
									decoration: BoxDecoration(color: index % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
										border: Border.all(width: 0.5, color: Color(0xFF1846E8)),
									),
								),
								Container(
									alignment: Alignment.center,
									width: responsive.wp(28),
									child: Text(
										orden.nombre.trim() == '' ? orden.usuario : orden.nombre,
										style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 12, color: Colors.white),
										textAlign: TextAlign.center,
									),
									decoration: BoxDecoration(
										color: index++ % 2 == 0 ? Color(0xFF3E68FD) : Color(0xFF182F9F),
										border: Border.symmetric(vertical: BorderSide(width: 0.5, color: Color(0xFF1846E8))),
									),
								),
								InkWell(
									onTap: flagHabil ? () {
										if (_btnRuta == Util.EN_RUTA)
											if (orden.status != Util.ORDEN_ENTREGADA && orden.status != Util.ORDEN_RECOGIDA && orden.status != Util.ORDEN_CANCELADA)
												_muestraOpciones(orden);
									} : null,
									child: Container(
										padding: EdgeInsets.only(top: 5, bottom: 5),
										alignment: Alignment.center,
										width: responsive.wp(17),
										child: Text(orden.status,
											style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 11,
												color: orden.status == Util.ORDEN_PROGRAMADA || orden.status == Util.ORDEN_REPROGRAMADA ||
													orden.status == Util.ORDEN_SIGUIENTE || orden.status == Util.ORDEN_ENRUTA ? Colors.black : Colors.white),
											textAlign: TextAlign.center,
										),
										decoration: BoxDecoration(
											color: orden.status == Util.ORDEN_PROGRAMADA ? Color(0xFFD9D9D9) : orden.status == Util.ORDEN_REPROGRAMADA ? Color(0xFFFFC000) :
												orden.status == Util.ORDEN_SIGUIENTE ? Color(0xFF1DE544) : orden.status == Util.ORDEN_FALLIDO ? Color(0xFFC55A11) :
												orden.status == Util.ORDEN_CANCELADA ? Color(0xFF3B3838) : orden.status == Util.ORDEN_ENTREGADA ? Color(0xFF1F4E79) :
												orden.status == Util.ORDEN_ENRUTA ? Color(0xFF9DC3E6) : orden.status == Util.ORDEN_REPROGRAMADA_USUARIO ? Color(0xFFC29E40) :
												orden.status == Util.ORDEN_RETRASO ? Color(0xFFEF0000) : Color(0xFF2E75B6)
										),
									),
								)
							],
						),
						orden.status == Util.ORDEN_SIGUIENTE ?
						Container(
							//child: Text('fdfsdsd'),
						) : Container()
					],
				),
			));
		}
		return lista;
	}

	_muestraOpciones(orden){
		print("Container clicked ${orden.id} - ${orden.posicion} - ${orden.status}");
		print('Eventos0${orden.status} == ${Util.ORDEN_REPROGRAMADA}');
		if (orden.status == Util.ORDEN_ENRUTA){
			Dialogs.dialog(
				context,
				title: 'Shopitrack',
				content: 'SELECCIONA UN ESTATUS:',
				actions: [
					ParamDialog(
						text: 'Siguiente Entrega',
						onPresed: () => _ejecutaSiguienteEntrega(orden.id, orden.usuario, orden.direccion, orden.estructura, 'ER', orden.orden)
					),
					/*ParamDialog(
						text: 'Re Programar',
						onPresed: () => _ejecutaReprogramacion(orden.id, orden.usuario, orden.estructura, orden.orden)
					),*/
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
						onPresed: () => _ejecutaEntregado(orden.id, orden.usuario, orden.estructura, orden.orden)
					),
					ParamDialog(
						text: 'Recolección',
						onPresed: () => _ejecutaRecogido(orden.id, orden.usuario, orden.estructura, orden.orden)
					),
					/*ParamDialog(
						text: 'Re Programar',
						onPresed: () => _ejecutaReprogramacion(orden.id, orden.usuario, orden.estructura, orden.orden)
					),*/
					ParamDialog(
						text: 'Intento Fallido',
						onPresed: () => _ejecutaFallido(orden.id, orden.usuario, orden.estructura, orden.orden)
					),
					ParamDialog(
							text: 'Retraso',
							onPresed: () => _ejecutaRetraso(orden.id, orden.usuario, orden.estructura, orden.orden)
					),
					ParamDialog(
						text: 'Cerrar ventana',
						onPresed: () => Navigator.pop(context)
					),
				]
			);
		}
		//print('Eventos${orden.status} == ${Util.ORDEN_REPROGRAMADA}');
		if (orden.status == Util.ORDEN_REPROGRAMADA) {
			print('reprog');
			Dialogs.dialog(
				context,
				title: 'Shopitrack',
				content: 'SELECCIONA UN ESTATUS:',
				actions: [
					ParamDialog(
						text: 'Siguiente Entrega',
						onPresed: () => _ejecutaSiguienteEntrega(orden.id, orden.usuario, orden.direccion, orden.estructura, 'RE', orden.orden)
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
						onPresed: () => _ejecutaSiguienteEntrega(orden.id, orden.usuario, orden.direccion, orden.estructura, 'IF', orden.orden)
					),
					ParamDialog(
						text: 'Cerrar ventana',
						onPresed: () => Navigator.pop(context)
					),
				]
			);
		}
		if (orden.status == Util.ORDEN_RETRASO) {
			Dialogs.dialog(
					context,
					title: 'Shopitrack',
					content: 'SELECCIONA UN ESTATUS:',
					actions: [
						ParamDialog(
								text: 'Siguiente Entrega',
								onPresed: () => _ejecutaSiguienteEntrega(orden.id, orden.usuario, orden.direccion, orden.estructura, 'RT', orden.orden)
						),
						ParamDialog(
								text: 'Cerrar ventana',
								onPresed: () => Navigator.pop(context)
						),
					]
			);
		}
	}

	_ejecutaReprogramacion(id, correo, estructura, orden) async {
		print('ejecuta reprogramacion');
		String datos = id + '_-,-_' + correo + '_-,-_' + estructura + '_-,-_' + orden;
		print('datos: $datos');
		response = await Services.instance.enviaSolicitud('ejecutaReprogramacion', {'userId': widget.token, 'idsPos': datos}, context);
		Navigator.pop(context);
		if (response != null) {
			if (response!['codigo'] == 0) {
				Dialogs.dialog(context, title: "Shopitrack", content: response!["mensaje"]);
				_init();
			}
			else
				Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
		}
		setState(() {});
	}

	_ejecutaRecogido(id, correo, estructura, orden) async {
		print('ejecuta recogido');
		String datos = id + '_-,-_' + correo + '_-,-_' + estructura + '_-,-_' + orden;
		print('datos: $datos');
		response = await Services.instance.enviaSolicitud('ejecutaRecogido', {'userId': widget.token, 'idsPos': datos}, context);
		Navigator.pop(context);
		if (response != null) {
			if (response!['codigo'] == 0) {
				Dialogs.dialog(
						context, title: "Shopitrack", content: response!["mensaje"]);
				_init();
			}
			else
				Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
		}
		setState(() {});
	}

	_ejecutaFallido(id, correo, estructura, orden) async {
		print('ejecuta fallido');
		String datos = id + '_-,-_' + correo + '_-,-_' + estructura + '_-,-_' + orden;
		print('datos: $datos');
		response = await Services.instance.enviaSolicitud('ejecutaFallido', {'userId': widget.token, 'idsPos': datos}, context);
		Navigator.pop(context);
		if (response != null) {
			if (response!['codigo'] == 0) {
				Dialogs.dialog(context, title: "Shopitrack", content: response!["mensaje"]);
				_init();
			}
			else
				Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
		}
		setState(() {});
	}

	_ejecutaEntregado(id, correo, estructura, orden) async {
		print('ejecuta entregado');
		String datos = id + '_-,-_' + correo + '_-,-_' + estructura + '_-,-_' + orden;
		print('datos: $datos');
		response = await Services.instance.enviaSolicitud('ejecutaEntregado', {'userId': widget.token, 'idsPos': datos}, context);
		Navigator.pop(context);
		if (response != null) {
			if (response!['codigo'] == 0) {
				Dialogs.dialog(context, title: "Shopitrack", content: response!["mensaje"]);
				_init();
			}
			else
				Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
		}
		setState(() {});
	}

	_ejecutaSiguienteEntrega(id, correo, direccion, estructura, statusOrigen, orden) async {
		print('ejecuta siguienteEntrega');
		String datos = id + '_-,-_' + correo + '_-,-_' + estructura + '_-,-_' + orden;
		print('datos: $datos');
		response = await Services.instance.enviaSolicitud('ejecutaSiguienteEntrega', {'userId': widget.token, 'idsPos': datos}, context);
		Navigator.pop(context);
		// if (response != null) {
		// 	if (response!['codigo'] == 0) {
		// 		await this._init();
		// 		Navigator.push(context, MaterialPageRoute(builder: (context) => MapaPage(token:widget.token, direccion:direccion, id:id, correo:correo, estructura:estructura, statusOrigen:statusOrigen, orden:orden)));
		// 	}
		// 	else
		// 		Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
		// }
	}

	_ejecutaRetraso(id, correo, estructura, orden) async {
		print('ejecuta Retraso');
		String datos = id + '_-,-_' + correo + '_-,-_' + estructura + '_-,-_' + orden;
		print('datos: $datos');
		response = await Services.instance.enviaSolicitud('ejecutaRetraso', {'userId': widget.token, 'idsPos': datos}, context);
		Navigator.pop(context);
		if (response != null) {
			if (response!['codigo'] == 0) {
				Dialogs.dialog(context, title: "Shopitrack", content: response!["mensaje"]);
				_init();
			}
			else
				Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
		}
		setState(() {});
	}
}
