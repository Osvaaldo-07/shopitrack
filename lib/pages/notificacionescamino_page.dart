import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class NotificacionesCaminoPage extends StatefulWidget {
  static const routeName = "notificacionescamino";
  final String nombre;
  final String token;
  final String imagen;
  final String imageUrl;
  final String orden;
  final String direccion;
  final String idnotif;
  final String idorden;
  final String hora;

  NotificacionesCaminoPage({Key? key, required this.token, required this.imagen, required this.imageUrl, required this.nombre, required this.orden, required this.direccion, required this.idnotif, required this.idorden, required this.hora}) : super(key: key);

  @override
  _NotificacionesCaminoPageState createState() => _NotificacionesCaminoPageState();
}

class _NotificacionesCaminoPageState extends State<NotificacionesCaminoPage> /*with AfterLayoutMixin*/ {
  /*Map<String, dynamic>? response = null;

  @override
  void afterFirstLayout(BuildContext context) {
    this._init();
  }

  _init() async {
    print('entro al _init de Mapa');
    response = await Services.instance.enviaSolicitud('getDatosEntrega', {'userId': widget.token}, context);
    if (response != null) {
      print('response $response');
      _googlemaps = response!['mensaje'];
      final geocoding = gec.GoogleMapsGeocoding(apiKey: _googlemaps);
      await geocoding.searchByAddress(widget.direccion).then((value) {
        if (value.results.length > 0) {
          //setState(() {
          cor.Location coord = value.results.first.geometry.location;
          print('lt:$coord');
          _destinationPosition = Position(latitude:coord.lat, longitude:coord.lng, heading:0, accuracy:0, speed:0, altitude:0, speedAccuracy:0, timestamp:null);
          //});
        }
      });
      //String urlDist = distance.buildUrl(origin:[cor.Location(19.368673, -99.292264)].toList(), destination:[cor.Location(19.457351, -99.1179468)].toList(), travelMode:cor.TravelMode.driving, departureTime:'now');
      //print(urlDist);
      //_getCurrentLocation();
      setState(() {});
    }
  }*/

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
                  'Orden camino a tu casa',
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
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Tu entrega ya está camino a tu dirección',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white60),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(2)),
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
                        'Tu orden ${widget.orden} llegará ${widget.hora}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.white60),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(1.5)),
                IconContainer(
                  width: responsive.wp(90),
                  height: responsive.wp(90)*0.58,
                  typeImg: 'url',
                  image: '${Services.baseUrl}/uploads/googlemaps/ord${widget.idorden}_notif${widget.idnotif}.png',
                  radio: 0.03,
                ),
                SizedBox(height: responsive.dp(2)),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: responsive.wp(100),
                      //alignment: Alignment.left,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Por favor está pendiente para recibirlo',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.white60),
                      ),
                    ),
                  ],
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
