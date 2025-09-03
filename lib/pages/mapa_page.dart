// import 'package:after_layout/after_layout.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:shopitrack/models/Parametros.dart';
// import 'package:shopitrack/models/googlemaps.dart' as adv;
// import 'package:shopitrack/util/dialogs.dart';
// import 'package:shopitrack/util/responsive.dart';
// import 'package:shopitrack/util/services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:shopitrack/widgets/util_widgets.dart';
// import 'package:google_maps_webservice/geocoding.dart' as gec;
// import 'package:google_maps_webservice/src/core.dart' as cor;

// class MapaPage extends StatefulWidget {
//   final String token;
//   final String direccion;
//   final String id;
//   final String correo;
//   final String estructura;
//   final String statusOrigen;
//   final String orden;

//   MapaPage({Key? key, required this.token, required this.direccion, required this.id, required this.correo, required this.estructura, required this.statusOrigen, required this.orden}) : super(key: key);

//   @override
//   _MapaPageState createState() => _MapaPageState();
// }

// class _MapaPageState extends State<MapaPage> with AfterLayoutMixin {
//   Map<String, dynamic>? response = null;
//   late String _googlemaps;
//   late String _distanceMap='';
//   late String _hourMap='';
//   late String _timeMap='';
//   late String _traficMap='';

//   //20.614727, -100.484509 -> Sonterra

//   CameraPosition _initialLocation = CameraPosition(target: LatLng(20.614727, -100.484509), zoom: 13);
//   late GoogleMapController mapController;
//   late Position _currentPosition;
//   late Position _destinationPosition;
//   Set<Marker> markers = {};
//   late Position startCoordinates;
//   late Position destinationCoordinates;
//   late PolylinePoints polylinePoints;
//   List<LatLng> polylineCoordinates = [];
//   Map<PolylineId, Polyline> polylines = {};
//   late Position _northeastCoordinates;
//   late Position _southwestCoordinates;
//   late String _datosSEMapa = "";

//   @override
//   void afterFirstLayout(BuildContext context) {
//     this._init();
//   }

//   _init() async {
//     print('entro al _init de Mapa');
//     response = await Services.instance.enviaSolicitud('getDataFunc', {'userId': widget.token}, context);
//     if (response != null) {
//       print('response $response');
//       _googlemaps = response!['mensaje'];
//       final geocoding = gec.GoogleMapsGeocoding(apiKey: _googlemaps);
//       print('direccion: ${widget.direccion}');
//       await geocoding.searchByAddress(widget.direccion).then((value) {
//         print('search: ${value.results.length}');
//         if (value.results.length > 0) {
//           //setState(() {
//           cor.Location coord = value.results.first.geometry.location;
//           print('lt:$coord');
//           _destinationPosition = Position(latitude:coord.lat, longitude:coord.lng, heading:0, accuracy:0, speed:0, altitude:0, speedAccuracy:0, timestamp:null);
//           _getCurrentLocation().then((val){
//             _getMarkers();
//           });
//           //});
//         }
//         else {
//           Dialogs.dialog(
//             context,
//             title: "Shopitrack",
//             content: 'No fue posible encontrar la dirección',
//             actions: [
//               ParamDialog(
//                 text: 'Regresar',
//                 onPresed: () {
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 }
//               )
//             ]
//           );
//           //Navigator.pop(context);
//         }
//       });
//       //String urlDist = distance.buildUrl(origin:[cor.Location(19.368673, -99.292264)].toList(), destination:[cor.Location(19.457351, -99.1179468)].toList(), travelMode:cor.TravelMode.driving, departureTime:'now');
//       //print(urlDist);
//       //_getCurrentLocation();
//       //setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('ORS: $_datosSEMapa');
//     final Responsive responsive = Responsive.of(context);
//     double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'SIGUIENTE ENTREGA',
//             style: TextStyle(
//               fontFamily: UtilWidgets.mainFont,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Colors.white),
//           ),
//           backgroundColor: Color(0xFF1846E8),
//         ),
//         body: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: responsive.isTablet ? 430 : responsive.width,
//               minHeight: responsive.height - heightAppBar - 48),
//             decoration: BoxDecoration(gradient: UtilWidgets.getGradientSys()),
//             width: double.infinity,
//             child: response==null || _datosSEMapa==""
//               ? Container(
//                   child: Center(
//                   child: CircularProgressIndicator(),
//                 ))
//               : Scaffold(
//                   //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //verticalDirection: VerticalDirection.down,
//                 body: Stack(
//                   children: <Widget>[
//                     GoogleMap(
//                       initialCameraPosition: _initialLocation,
//                       myLocationEnabled: true,
//                       myLocationButtonEnabled: false,
//                       mapType: MapType.normal,
//                       zoomGesturesEnabled: true,
//                       zoomControlsEnabled: false,
//                       onMapCreated: (GoogleMapController controller) async {
//                         mapController = controller;
//                         //setState(() async {
//                           //_getCurrentLocation();
//                         mapController.animateCamera(
//                           CameraUpdate.newLatLngBounds(
//                             LatLngBounds(
//                               northeast: LatLng(
//                                 _northeastCoordinates.latitude,
//                                 _northeastCoordinates.longitude,
//                               ),
//                               southwest: LatLng(
//                                 _southwestCoordinates.latitude,
//                                 _southwestCoordinates.longitude,
//                               ),
//                             ),
//                             40.0, // padding
//                           ),
//                         );
//                         Map<String, dynamic>? resp = await Services.instance.enviaSolicitud('ejecutaSiguienteEntregaMapa', {'userId': widget.token, 'idsPos': _datosSEMapa}, context);
//                         if (resp != null) {
//                           if (resp['codigo'] == 1)
//                             Dialogs.dialog(context, title: "Shopitrack", content: resp["mensaje"]);
//                         }
//                         //});
//                         //_getMarkers();
//                       },
//                       markers: Set<Marker>.from(markers),
//                       polylines: Set<Polyline>.of(polylines.values),
//                     ),
//                     Positioned(
//                       top: 10,
//                       left:0,
//                       right: 0,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         //crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget> [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10.0),
//                             //width: 300,
//                             //height: 150,
//                             child: Container(
//                               width: responsive.wp(75),
//                               height: 75,
//                               color: Color(0xAACCCCCC),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                children: <Widget> [
//                                  Text('Distancia: $_distanceMap', style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
//                                  Text('Hora Estimada\nde Arribo: $_hourMap hrs.', textAlign: TextAlign.center, style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
//                                  //Text('Tiempo: $_timeMap'),
//                                  //Text('Trafico: $_traficMap')
//                                ],
//                               )
//                             ),
//                           )
//                             /*child: Align(
//                               /*alignment: Alignment.topCenter,*/
//                               widthFactor: 0.75,
//                               heightFactor: 0.75,
//                               child: Text('Distancia: ')//Image.network('https://i.ibb.co/1vXpqVs/flutter-logo.jpg'),
//                             ),*/
//                         ],
//                       ),
//                     ),
//                   ],
//                 )),
//           ),
//         ));
//   }

//   _getCurrentLocation() async {
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
//       //setState(() {
//         print('current');
//         _currentPosition = position;
//         //_currentPosition = Position(latitude:19.368673, longitude:-99.292264, heading:0, accuracy:0, speed:0, altitude:0, speedAccuracy:0, timestamp:null);;
//         //_getMarkers();
//       //});
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   _getMarkers() async {
//     Position startCoordinates = _currentPosition;
//     Position destinationCoordinates = _destinationPosition; //Position(latitude: 19.457351, longitude: -99.1179468);
//     Marker startMarker = Marker(
//       markerId: MarkerId('$startCoordinates'),
//       position: LatLng(startCoordinates.latitude, startCoordinates.longitude),
//       infoWindow: InfoWindow(title: 'Shopitrack', snippet: 'Mi ubicación'),
//       icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40)), 'assets/markerS.png')
//     );
//     print(destinationCoordinates);
//     Marker destinationMarker = Marker(
//       markerId: MarkerId('$destinationCoordinates'),
//       position: LatLng(destinationCoordinates.latitude, destinationCoordinates.longitude),
//       infoWindow: InfoWindow(title: 'Entrega', snippet: widget.direccion),
//       //icon: BitmapDescriptor.defaultMarker,
//       //icon: BitmapDescriptor.fromAsset('assets/icon.png')
//       icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40)), 'assets/markerC.png')
//     );
//     markers.add(startMarker);
//     markers.add(destinationMarker);

//     /*Position _northeastCoordinates;
//     Position _southwestCoordinates;*/
//     // Calculating to check that southwest coordinate <= northeast coordinate
//     if (startCoordinates.latitude <= destinationCoordinates.latitude) {
//       _southwestCoordinates = startCoordinates;
//       _northeastCoordinates = destinationCoordinates;
//     } else {
//       _southwestCoordinates = destinationCoordinates;
//       _northeastCoordinates = startCoordinates;
//     }
//     // Accommodate the two locations within the camera view of the map
//     /*mapController.animateCamera(
//       CameraUpdate.newLatLngBounds(
//         LatLngBounds(
//           northeast: LatLng(
//             _northeastCoordinates.latitude,
//             _northeastCoordinates.longitude,
//           ),
//           southwest: LatLng(
//             _southwestCoordinates.latitude,
//             _southwestCoordinates.longitude,
//           ),
//         ),
//         40.0, // padding
//       ),
//     );*/
//     _createPolylines(startCoordinates, destinationCoordinates);
//   }

//   _createPolylines(Position start, Position destination) async {
//     // Initializing PolylinePoints
//     polylinePoints = PolylinePoints();
//     // Generating the list of coordinates to be used for drawing the polylines
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       _googlemaps,
//       PointLatLng(start.latitude, start.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//       travelMode: TravelMode.transit,
//     );
//     // Adding the coordinates to the list
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//     // Defining an ID
//     PolylineId id = PolylineId('poly');
//     // Initializing Polyline
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.blueAccent,
//       points: polylineCoordinates,
//       width: 3,
//     );
//     // Adding the polyline to the map
//     polylines[id] = polyline;
//     final distance = adv.GoogleDistanceMatrixAdvance(apiKey: _googlemaps);
//     //final distance = adv.GoogleDistanceMatrix(apiKey: _googlemaps);
//     //await distance.distanceWithLocation([cor.Location(19.368673, -99.292264)].toList(), [cor.Location(19.457351, -99.1179468)].toList(), travelMode:cor.TravelMode.driving, departureTime:'now');
//     //String urlDist = distance.buildUrl(origin:[cor.Location(19.368673, -99.292264)].toList(), destination:[cor.Location(19.457351, -99.1179468)].toList(), travelMode:cor.TravelMode.driving, departureTime:'now');
//     //print(urlDist);

//     await distance.distanceWithLocationAdvance(
//             [cor.Location(lat:_currentPosition.latitude, lng:_currentPosition.longitude)].toList(),
//             [cor.Location(lat:_destinationPosition.latitude, lng:_destinationPosition.longitude)].toList(),
//             travelMode: cor.TravelMode.driving,
//             departureTime: 'now').then((value) {
//       setState(() {
//         _distanceMap = value.rows.first.elements.first.distance.text;
//         _timeMap = value.results.first.elements.first.duration.text;
//         _traficMap = value.results.first.elements.first.durationInTraffic!.text;
//         int timeMap = value.results.first.elements.first.duration.value.toInt();
//         int traficMap = value.results.first.elements.first.durationInTraffic!.value.toInt();
//         final DateFormat formatter = DateFormat('HH:mm');
//         var now = DateTime.now();
//         //print(now);
//         timeMap = (timeMap/60).round();
//         //print(timeMap);
//         var suma = now.add(Duration(minutes:timeMap));
//         //print(suma);
//         int entre = timeMap + 10;
//         int yentre = entre + 10;
//         _hourMap = formatter.format(suma);
//         //var mas10 = formatter.format(suma.add(Duration(minutes:10)));
//         _datosSEMapa = widget.id + '_-,-_' + widget.correo + '_-,-_' + _distanceMap + '_-,-_' + _traficMap + '_-,-_' + _hourMap + '_-,-_' + widget.estructura + '_-,-_' + _currentPosition.latitude.toString() + '_-,-_' + _currentPosition.longitude.toString() + '_-,-_' + _destinationPosition.latitude.toString() + '_-,-_' + _destinationPosition.longitude.toString() + '_-,-_' + widget.statusOrigen + '_-,-_' + timeMap.toString() + '_-,-_' + widget.orden;
//       });
//       //print(value.originAddress + value.destinationAddress);
//     });
//     /*String *///_datosSEMapa = widget.id + '_-,-_' + widget.correo + '_-,-_' + _distanceMap + '_-,-_' + _traficMap + '_-,-_' + _hourMap + '_-,-_' + widget.estructura + '_-,-_' + _currentPosition.latitude.toString() + '_-,-_' + _currentPosition.longitude.toString() + '_-,-_' + _destinationPosition.latitude.toString() + '_-,-_' + _destinationPosition.longitude.toString();
//     //print('datos: $datos');
//     //response = await Services.instance.enviaSolicitud('ejecutaSiguienteEntregaMapa', {'userId': widget.token, 'idsPos': _datosSEMapa}, context);
//     //setState(() {});
//     print('Gris2');
//   }
// }
