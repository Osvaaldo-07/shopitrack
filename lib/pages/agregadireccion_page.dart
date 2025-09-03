import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopitrack/models/Parametros.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/util/util.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/input_text.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'package:shopitrack/util/dialogs.dart';
import 'dart:io' as io;
import 'package:image/image.dart' as img;

class AgregaDireccionPage extends StatefulWidget {
  //static const routeName = "editaperfil";
  final String token;

  AgregaDireccionPage({Key? key, required this.token}) : super(key: key);
  
  @override
  _AgregaDireccionPageState createState() => _AgregaDireccionPageState();
}

class _AgregaDireccionPageState extends State<AgregaDireccionPage> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  late String _calle;
  late String _exterior;
  late String _interior;
  late String _colonia;
  late String _cp;
  late String _ciudad;
  late String _municipio;
  late String _alias;
  late String imageUrl = 'imagen.jpg';
  
  _guardarDireccion(String token) async {
    if (_formKey.currentState!.validate()){
      Map<String, dynamic> data = {
        'userId': token,
        'calle': _calle,
        'exterior': _exterior,
        'interior': _interior,
        'colonia': _colonia,
        'cp': _cp,
        'ciudad': _ciudad,
        'municipio': _municipio,
        'alias': _alias,
        'imagenb64': ''
      };
      Map<String, dynamic>? responseDir = await Services.instance.enviaSolicitud('guardaDireccion', data, context);
      //print(responseDir);
      if (responseDir != null) {
        if (responseDir['codigo'] == 0) {
          Dialogs.dialog(context, title: 'Aviso', content: responseDir['mensaje'], actions: [
            ParamDialog(
                text: 'Aceptar',
                onPresed: (){
                  Navigator.pop(context);
                  Navigator.pop(context, 'OK');
                }
            ),
          ]);
        }
        else
          Dialogs.dialog(context, title: 'Error', content: responseDir['mensaje']);
      }
    }
    else
      Dialogs.dialog(context, title: 'Error', content: 'Debe capturar los datos obligatorios');
  }

  _pickImage(bool fromCamara, String token) async {
    imageCache!.clear();
    imageCache!.clearLiveImages();
    FocusScope.of(context).requestFocus(new FocusNode());
    final XFile? pickedFile = await Util.pickImage(fromCamara);
    if (pickedFile != null) {
      Uint8List bytes = await io.File(pickedFile.path).readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      img.Image thumbnail = img.copyResize(image!, width:480);
      bytes = img.encodeJpg(thumbnail);
      Map<String, dynamic> data = {
        'userId': token,
        'calle': _calle,
        'exterior': _exterior,
        'interior': _interior,
        'colonia': _colonia,
        'cp': _cp,
        'ciudad': _ciudad,
        'municipio': _municipio,
        'alias': _alias,
        'imagenb64': Util.base64Encode(bytes),
      };
      Map<String, dynamic>? responseDir = await Services.instance.enviaSolicitud('guardaDireccion', data, context);
      print(responseDir);
      if (responseDir != null) {
        if (responseDir['codigo'] == 0) {
          setState(() {imageUrl = responseDir['imagen'];});
          Dialogs.dialog(context, title: 'Aviso', content: responseDir['mensaje'], actions: [
            ParamDialog(
              text: 'Aceptar',
              onPresed: (){
                Navigator.pop(context);
                Navigator.pop(context, 'OK');
              }
            ),
          ]);
        }
        else
          Dialogs.dialog(context, title: 'Error', content: responseDir['mensaje']);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    double separacion = responsive.dp(2);
    double maxWidth = responsive.isTablet ? 430 : responsive.width;
    double maxWidthLessPad = maxWidth - 50;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AGREGAR DIRECCIÓN',
          style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
              maxWidth: maxWidth,
              minHeight: responsive.height - heightAppBar
            ),
            decoration: BoxDecoration(
              gradient: UtilWidgets.getGradientSys()
            ),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left:25, right: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: separacion),
                        Text(
                          'NUEVA DIRECCIÓN',
                          style: TextStyle(fontFamily: UtilWidgets.mainFont, fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(height: separacion),
                        InputText(
                          label: "Calle",
                          hintText: "Calle",
                          maxLength: 100,
                          contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          onChanged: (text) => _calle = text!,
                          validator: (text) => text!.trim()=='' ? "Calle inválida" : null,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: separacion),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                            SizedBox(
                              width: maxWidthLessPad*0.48,
                              child: InputText(
                                label: "No. Exterior",
                                hintText: "No. Exterior",
                                maxLength: 15,
                                contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                onChanged: (text) => _exterior = text!,
                                validator: (text) => text!.trim()=='' ? "No. Exterior inválido" : null,
                              ),
                            ),
                            SizedBox(
                              width: maxWidthLessPad*0.48,
                              child: InputText(
                                label: "No. Interior",
                                hintText: "No. Interior",
                                maxLength: 15,
                                contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                onChanged: (text) => _interior = text!,
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: separacion),
                        InputText(
                          label: "Colonia",
                          hintText: "Colonia",
                          maxLength: 25,
                          contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          onChanged: (text) => _colonia = text!,
                          validator: (text) => text!.trim()=='' ? "Colonia inválida" : null,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: separacion),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                            SizedBox(
                              width: maxWidthLessPad*0.28,
                              child: InputText(
                                label: "C.P.",
                                hintText: "C.P.",
                                maxLength: 5,
                                contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                onChanged: (text) => _cp = text!,
                                validator: (text) => text!.trim()=='' ? "C.P. inválido" : null,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              width: maxWidthLessPad*0.68,
                              child: InputText(
                                label: "Ciudad",
                                hintText: "Ciudad",
                                maxLength: 30,
                                contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                onChanged: (text) => _ciudad = text!,
                                validator: (text) => text!.trim()=='' ? "Ciudad inválida" : null,
                                textCapitalization: TextCapitalization.words,
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: separacion),
                        InputText(
                          label: "Municipio/Alcaldia",
                          hintText: "Municipio/Alcaldia",
                          maxLength: 30,
                          contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          onChanged: (text) => _municipio = text!,
                          validator: (text) => text!.trim()=='' ? "Municipio/Alcaldia inválido" : null,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: separacion),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: maxWidthLessPad*0.38,
                              child: InputText(
                                label: "Alias",
                                hintText: "Alias",
                                maxLength: 15,
                                contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                onChanged: (text) => _alias = text!,
                                validator: (text) => text!.trim()=='' ? "Alias inválido" : null,
                                textCapitalization: TextCapitalization.words,
                              ),
                            ),
                            SizedBox(
                              width: maxWidthLessPad*0.58,
                              child: IconContainer(
                                width: maxWidthLessPad*0.58,
                                typeImg: imageUrl.contains('//') ?  'url' : '',
                                image: imageUrl,
                                radio: 0.1,
                                onTap: (){
                                  if (_formKey.currentState!.validate()){
                                    Dialogs.dialog(
                                      context,
                                      title: 'Imagen',
                                      content: 'Obtener imagen desde:',
                                      actions: [
                                        ParamDialog(
                                          text: 'Camara',
                                          onPresed: () {
                                            _pickImage(true, widget.token);
                                            Navigator.pop(context);
                                          }
                                        ),
                                        ParamDialog(
                                          text: 'Galería',
                                          onPresed: () {
                                            _pickImage(false, widget.token);
                                            Navigator.pop(context);
                                          }
                                        ),
                                        ParamDialog(
                                          text: 'Cancelar',
                                          onPresed: () => Navigator.pop(context)
                                        ),
                                      ]
                                    );
                                  }
                                  else
                                    Dialogs.dialog(context, title: 'Error', content: 'Debe capturar los datos obligatorios');
                                },
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: separacion),
                        Row(
                          children: <Widget> [
                            Expanded(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Color(0xFF1EE545))
                                ),
                                color: Color(0xFF1EE545),
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                onPressed: () => _guardarDireccion(widget.token),
                                child: Text(
                                  'GUARDAR',
                                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1846E8)),
                                )
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: separacion),
                      ]
                    ),
                  ),
                ),
                SizedBox(height: separacion),
              ],
            )
          ),
        )
      ),
    );
  }
}