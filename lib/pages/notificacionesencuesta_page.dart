import 'package:after_layout/after_layout.dart';
import 'package:shopitrack/models/Parametros.dart';
import 'package:shopitrack/models/catalogos.dart';
import 'package:shopitrack/util/dialogs.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'home_page.dart';

class NotificacionesEncuestaPage extends StatefulWidget {
  static const routeName = "notificacionesencuesta";
  final String nombre;
  final String token;
  final String idorden;
  final String orden;
  final String estructura;
  final String idnotif;

  NotificacionesEncuestaPage({Key? key, required this.token, required this.nombre, required this.idorden, required this.orden, required this.estructura, required this.idnotif}) : super(key: key);

  @override
  _NotificacionesEncuestaPageState createState() => _NotificacionesEncuestaPageState();
}

/*enum SingingCharacter1 {Bueno, Regular, Malo}
enum SingingCharacter2 {Si, No}
enum SingingCharacter3 {Si, No}*/

class _NotificacionesEncuestaPageState extends State<NotificacionesEncuestaPage> with AfterLayoutMixin {
  Map<String, dynamic>? response = null;
  late List<dynamic>? lstPreguntas;
  late List<Preguntas>? preguntas = null;

  int _currentStep = 0;
  List<String> opcionesResp = ['rrr', 'rrr', 'rrr'];
  Map<String, List<bool>> _valuesCheck = Map<String, List<bool>>();

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  _init() async {
    response = await Services.instance.enviaSolicitud('getIniPreguntas', {'userId':widget.token, 'estructura':widget.estructura}, null);
    print(response);
    if (response != null) {
      lstPreguntas = response!['preguntas'];
      if (lstPreguntas != null) {
        List<Preguntas> preguntasTmp = lstPreguntas!.map((json) => Preguntas.fromJson(json)).toList();
        preguntas = _armaEncuesta(preguntasTmp);
      }
    }
    setState(() {});
  }

  _armaEncuesta(List<Preguntas> inicial) {
    List<Preguntas> encuesta = <Preguntas>[];
    late List<Respuestas> respuestas;
    Preguntas nuevo;
    Respuestas nuevas;
    String idtmp = '';
    for (Preguntas pregunta in inicial){
      if (idtmp != pregunta.idtmp){
        nuevas = Respuestas(tipo:pregunta.tiporespuesta, respuesta:pregunta.respuesta, resporden:pregunta.resporden);
        respuestas = <Respuestas>[];
        respuestas.add(nuevas);
        nuevo = Preguntas(idpregunta:pregunta.idpregunta, idtmp:pregunta.idtmp, estructura:pregunta.estructura, pregunta:pregunta.pregunta, tiporespuesta:pregunta.tiporespuesta, respuesta:pregunta.respuesta, orden:pregunta.orden, resporden:pregunta.resporden, respuestas:respuestas);
        encuesta.add(nuevo);
      }
      else {
        nuevas = Respuestas(tipo:pregunta.tiporespuesta, respuesta:pregunta.respuesta, resporden:pregunta.resporden);
        respuestas.add(nuevas);
      }
      idtmp = pregunta.idtmp;
    }
    /*for (Preguntas p in encuesta){
      print('${p.pregunta}-${p.orden}-${p.estructura}-${p.idtmp}');
      for (Respuestas r in p.respuestas)
        print('${r.tipo}-${r.respuesta}');
    }*/
    return encuesta;
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
                Row(
                  children: [
                    Container(
                      width: responsive.wp(100),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        '¡Estás a un paso de acreditar tus puntos!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1EE545)),
                      ),
                    ),
                  ],
                ),
                /*Text(
                  'Responde tu encuesta',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1EE545)),
                ),*/
                /*SizedBox(height: responsive.hp(2)),
                Text(
                  'Acumula Puntos',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white60),
                ),*/
                SizedBox(height: responsive.dp(2)),
                Row(
                  children: [
                    Container(
                      width: responsive.wp(100),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Responde ésta breve encuesta de servicio.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.amberAccent),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(1)),
                Row(
                  children: [
                    Container(
                      width: responsive.wp(100),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Te tomará un minuto.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 17, color: Colors.amberAccent),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(2)),
                preguntas==null ? Center(child: CircularProgressIndicator()) : Container(
                  width: responsive.wp(90),
                  height: responsive.hp(50),
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Color(0xFF1EE545),
                      canvasColor: Color(0xFF1846E8),
                      colorScheme: ColorScheme.light(primary: Color(0xFF1EE545)),
                    ),
                    child: /*Center(), */Stepper(
                      type: StepperType.horizontal,
                      physics: ScrollPhysics(),
                      currentStep: _currentStep,
                      onStepTapped: (step) => tapped(step),
                      //controlsBuilder: (BuildContext context, {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
                      controlsBuilder: (BuildContext context, ControlsDetails details) {
                        return Row(
                          children: <Widget>[
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Color(0xFF1EE545))
                              ),
                              color: Color(0xFF1EE545),
                              padding: EdgeInsets.only(top: 2, bottom: 2, left: 12, right: 12),
                              onPressed: () => _currentStep < 2 ? setState(() => _currentStep += 1) : null,
                              child: Text(
                                'SIGUIENTE',
                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                              ),
                            ),
                            SizedBox(width: responsive.wp(4)),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Color(0xFF1EE545))
                              ),
                              color: Color(0xFF1EE545),
                              padding: EdgeInsets.only(top: 2, bottom: 2, left: 12, right: 12),
                              onPressed: () => _currentStep > 0 ? setState(() => _currentStep -= 1) : null,
                              child: Text(
                                'ANTERIOR',
                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                      steps: _generaSteps(context),
                    ),
                  ),
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
                        onPressed: () => _aceptar(),
                        child: Text(
                          'ENVIAR',
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
    bool todas = true;
    String idsPreguntas = '';
    String respuestas = '';
    for (String s in opcionesResp) {
      todas = s == 'rrr' ? false : todas;
      respuestas += s + '_-,-_';
    }
    respuestas = respuestas.length>=5 ? respuestas.substring(0, respuestas.length-5) : respuestas;
    for (Preguntas p in preguntas!)
      idsPreguntas += p.idpregunta + '_-,-_';
    idsPreguntas = idsPreguntas.length>=5 ? idsPreguntas.substring(0, idsPreguntas.length-5) : idsPreguntas;
    if (!todas) {
      Dialogs.dialog(context, title: 'Shopitrack', content: 'Por favor responda todas las preguntas');
      return;
    }
    String datos = widget.idnotif + '_-,-_E';
    print('datos: $datos');
    response = await Services.instance.enviaSolicitud('guardaEncuesta', {'userId':widget.token, 'estructura':widget.estructura, 'preguntas':idsPreguntas, 'respuestas':respuestas, 'idorden':widget.idorden, 'orden':widget.orden}, context);
    if (response != null) {
      if (response!['codigo'] == 0)
        Dialogs.dialog(
          context,
          title: 'Shopitrack',
          content: response!["mensaje"],
          actions: [
            ParamDialog(
              text: 'Finalizar',
              onPresed: () async {
                response = await Services.instance.enviaSolicitud('actualizaNotifVisto', {'userId':widget.token, 'idsPos':datos}, context);
                Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (_)=>false);
              } //Navigator.push(context, MaterialPageRoute(builder: (context) => NotificacionesPage()))
            ),
          ]
        );
      else
        Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
    }
    //Navigator.pop(context);
    //Navigator.pop(context);
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  Radio _addRadio(String respuesta, String orden) {
    int indice = int.tryParse(orden)! - 1;
    return Radio(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: respuesta,
      groupValue: opcionesResp.elementAt(indice),
      onChanged: (value) => setState((){
        opcionesResp.removeAt(indice);
        opcionesResp.insert(indice, value);
      }),
      hoverColor: Colors.white,
    );
  }

  Container _addText(BuildContext context, String orden) {
    final Responsive responsive = Responsive.of(context);
    int indice = int.tryParse(orden)! - 1;
    return Container(
      //height: 1000,
      width: responsive.wp(75),
      child: TextFormField(
        //scrollPadding: EdgeInsets.all(10),
        decoration: const InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: UtilWidgets.mainFont,
          height: 0.9,
        ),
        maxLength: 40,
        onChanged: (text) {
          opcionesResp.removeAt(indice);
          opcionesResp.insert(indice, text);
        },
        //expands: true,
        //maxLines: null,
      ),
    );
  }

  Checkbox _addCheck(String respuesta, String orden, String resporden) {
    int indice = int.tryParse(orden)! - 1;
    int respindice = int.tryParse(resporden)! - 1;
    if (_valuesCheck[orden] == null)
      _valuesCheck[orden] = <bool>[];
    _valuesCheck[orden]!.add(false);
    Checkbox checkbox = Checkbox(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: _valuesCheck[orden]!.elementAt(respindice),
      onChanged: (bool? value) {
        setState(() {
          if (value != null){
            _valuesCheck[orden]!.removeAt(respindice);
            _valuesCheck[orden]!.insert(respindice, value);
            String valor = opcionesResp.elementAt(indice);
            valor = value ? valor += respuesta + '.:.' : valor.replaceAll(respuesta + '.:.', '');
            opcionesResp.removeAt(indice);
            opcionesResp.insert(indice, valor);
          }
        });
      }
    );
    return checkbox;
  }

  List<Step> _generaSteps(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    var pasos = <Step>[];
    for (Preguntas pregunta in preguntas!){
      pasos.add(Step(
        title: new Text(''),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              pregunta.pregunta,
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            for (Respuestas respuesta in pregunta.respuestas)
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  respuesta.tipo!='4' ? respuesta.respuesta : '',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: responsive.width>400?16:15, color: Colors.white),
                ),
                leading: respuesta.tipo=='1' ? _addRadio(respuesta.respuesta, pregunta.orden) : respuesta.tipo=='4' ? _addText(context, pregunta.orden) : _addCheck(respuesta.respuesta, pregunta.orden, respuesta.resporden)
              ),
            SizedBox(height: responsive.dp(2)),
          ]
        ),
        isActive: _currentStep >= 0,
        state: _currentStep >= int.tryParse(pregunta.orden)!-1 ?
        StepState.complete : StepState.disabled,
      )
      );
    }
    return pasos;
  }
}
