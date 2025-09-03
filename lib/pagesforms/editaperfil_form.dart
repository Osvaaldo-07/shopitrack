import 'package:after_layout/after_layout.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shopitrack/models/Parametros.dart';
import 'package:shopitrack/pages/home_page.dart';
import 'package:shopitrack/pages/hometransp_page.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/util/dialogs.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/icon_container.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'package:shopitrack/widgets/input_text.dart';
//import 'package:masked_text/masked_text.dart';
import 'dart:io' as io;
import 'package:image/image.dart' as img;

class EditaPerfilForm extends StatefulWidget {
  @override
  _EditaPerfilFormState createState() => _EditaPerfilFormState();
}

enum SingingCharacter {Mujer, Hombre, NA}

class _EditaPerfilFormState extends State<EditaPerfilForm> with AfterLayoutMixin {
  Map<String, dynamic>? response = null;
  String imageUrl = "";
  GlobalKey<FormState> _formKey = new GlobalKey();
  String _nombre = "";
  String _apaterno = "";
  String _amaterno = "";
  SingingCharacter _genero = SingingCharacter.NA;
  TextEditingController _fnacimiento = TextEditingController();
  TextEditingController _telefono = TextEditingController();
  String _user = "";
  String _password = "";
  bool _valFnacimiento = true;
  bool _valTelefono = true;

  @override
  void afterFirstLayout(BuildContext context){
    this._init();
  }

  @override
  void initState(){
    super.initState();
  }

  _init() async {
    Session? session = await Auth.instance.accessToken;
    response = await Services.instance.enviaSolicitud('getDatosPerfil', {'userId':session!.token});
    print(response);
    if (response != null) {
      if (response!['codigo'] == 0) {
        _nombre = response!['nombre'];
        _apaterno = response!['apaterno'];
        _amaterno = response!['amaterno'];
        _fnacimiento.text = response!['fnacimiento'];
        _telefono.text = response!['telefono'];
        _genero = response!['genero'] == 'M' ? SingingCharacter.Hombre : response!['genero'] == 'F' ? SingingCharacter.Mujer : SingingCharacter.NA;
        imageUrl = response!['imagen'];
        _user = response!['usuario'];
        _password = response!['contrasena'];
        setState(() {});
      }
      else
        Dialogs.dialog(context, title: "Error", content: response!["mensaje"]);
    }
  }

  _pickImage(bool fromCamara) async {
    imageCache!.clear();
    imageCache!.clearLiveImages();
    FocusScope.of(context).requestFocus(new FocusNode());
    final XFile? pickedFile = await Util.pickImage(fromCamara);
    if (pickedFile != null) {
      print("Subir imagen. Path: ${pickedFile.path}");
      Uint8List bytes = await io.File(pickedFile.path).readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      img.Image thumbnail = img.copyResize(image!, width:480);
      bytes = img.encodeJpg(thumbnail);
      final Session? session = await Auth.instance.getSession();
      Map<String, dynamic> data = {
        'userId': session!.token,
        'imagenb64': Util.base64Encode(bytes),
      };
      Map<String, dynamic>? responseImg = await Services.instance.enviaSolicitud('saveImagePerfil', data, context);
      if (responseImg != null) {
        if (responseImg['codigo'] == 0) {
          //print(response['imagen']+' responseImg');
          imageUrl = responseImg['imagen'];
          //print(responseImg);
          await Auth.instance.setSession(responseImg);
          setState(() {});
          Dialogs.dialog(context, title: 'Aviso', content: responseImg['mensaje'], actions: [
            ParamDialog(
              text: 'Aceptar',
              onPresed: () => Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (_)=>false)
            )
          ]);
        }
        else
          Dialogs.dialog(context, title: 'Error', content: responseImg['mensaje']);
      }
    }
  }

  _guardarCambios() async {
    Session? session = await Auth.instance.accessToken;
    setState(() {
      //_valFnacimiento = Util.isValidDate(_fnacimiento.text, 'dd/MM/yyyy');
      //_valTelefono = _telefono.text.length!=12 ? false : true;
      if (_fnacimiento.text.length > 0)
        _valFnacimiento = Util.isValidDate(_fnacimiento.text, 'dd/MM/yyyy');
      if (_telefono.text.length > 0)
        _valTelefono = _telefono.text.length!=12 ? false : true;
    });
    if (_formKey.currentState!.validate() && _valFnacimiento && _valTelefono) {
      Map<String, dynamic> data = {
        'nombre': _nombre,
        'apaterno': _apaterno,
        'amaterno': _amaterno,
        'genero': _genero==SingingCharacter.Mujer?'F':_genero==SingingCharacter.Hombre?'M':'N',
        'fnacimiento': _fnacimiento.text,
        'telefono': _telefono.text,
        'usuario': _user,
        'contrasena': _password,
        'userId': session!.token,
        'imagen': session.imagen
      };
      Map<String, dynamic>? responsePerfil = await Services.instance.enviaSolicitud('actualizaPerfil', data, context);
      if (responsePerfil != null) {
        if (responsePerfil['codigo'] == 0) {
          await Auth.instance.setSession(responsePerfil);
          //setState(() {});
          Dialogs.dialog(context, title: "Aviso", content: responsePerfil["mensaje"], actions: [
            ParamDialog(
              text: 'Aceptar',
              onPresed: () {
                if (!_user.contains("@") && Util.intValidator(_user.substring(0,4))!=null && Util.intValidator(_user.substring(5,8))!=null)
                  Navigator.pushNamedAndRemoveUntil(context, HomeTranspPage.routeName, (_)=>false);
                else
                  Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (_) => false);
              }
            )
          ]);
        }
        else
          Dialogs.dialog(context, title: "Error", content: responsePerfil["mensaje"]);
      }
    }
    else
      Dialogs.dialog(context, title: "Error", content: 'Al menos un dato es inválido');
  }

  @override
  Widget build(BuildContext context) {
    print('Usuario');
    /*if(response!=null)
      print(response['imagen']+' - IMagen');
    else
      print('response null');*/
    final Responsive responsive = Responsive.of(context);
    double separacion = responsive.dp(2);
    return Container(
      padding: EdgeInsets.only(left:40, right: 40),
      child: Form(
        key: _formKey,
        child: response==null ? Center(child: CircularProgressIndicator()) : Column(
          children: <Widget>[
            IconContainer(
              width: responsive.hp(15),
              typeImg: imageUrl.contains('//') ?  'url' : '',
              image: imageUrl,
              radio: 0.5,
              onTap: (){
                Dialogs.dialog(
                  context,
                  title: 'Imagen',
                  content: 'Obtener imagen desde:',
                  actions: [
                    ParamDialog(
                      text: 'Camara',
                      onPresed: () {
                        _pickImage(true);
                        Navigator.pop(context);
                      }
                    ),
                    ParamDialog(
                      text: 'Galería',
                      onPresed: () {
                        _pickImage(false);
                        Navigator.pop(context);
                      }
                    ),
                    ParamDialog(
                      text: 'Cancelar',
                      onPresed: () => Navigator.pop(context)
                    ),
                  ]
                );
              },
            ),
            SizedBox(height: separacion),
            InputText(
              label: "Nombre",
              hintText: "Nombre",
              prefixIcon: Icons.account_circle_outlined,
              maxLength: 30,
              onChanged: (text) => _nombre = text!,
              validator: (text) => text!.trim()=='' ? "Nombre inválido" : null,
              initialValue: response!['nombre'],
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: separacion),
            InputText(
              label: "Apellido Paterno",
              hintText: "Apellido Paterno",
              prefixIcon: Icons.account_circle_outlined,
              maxLength: 30,
              onChanged: (text) => _apaterno = text!,
              validator: (text) => text!.trim()=='' ? "Apellido Paterno inválido" : null,
              initialValue: response!['apaterno'],
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: separacion),
            InputText(
              label: "Apellido Materno",
              hintText: "Apellido Materno",
              prefixIcon: Icons.account_circle_outlined,
              maxLength: 30,
              onChanged: (text) => _amaterno = text!,
              initialValue: response!['amaterno'],
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: separacion),
            Row(
              children: <Widget> [
                Text(
                  'Genero',
                  style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ]
            ),
            Container(
              padding: EdgeInsets.all(0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget> [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Mujer',
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: responsive.width>400?16:15, color: Colors.white),
                      ),
                      leading: Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: SingingCharacter.Mujer,
                        groupValue: _genero,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _genero = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Hombre',
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: responsive.width>400?16:15, color: Colors.white),
                      ),
                      leading: Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: SingingCharacter.Hombre,
                        groupValue: _genero,
                        onChanged: (SingingCharacter? value) => setState(() => _genero = value!),
                        hoverColor: Colors.white,
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Column(
              children: <Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    Text(
                      'Fecha de nacimiento',
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 16, color: Colors.white)
                    ),
                  ]
                ),
                TextFormField(
                  controller: _fnacimiento,
                  inputFormatters: [MaskTextInputFormatter(mask: "##/##/####")],
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.always,
                  //validator: validator,
                  decoration: UtilWidgets.maskDecoration('dd/mm/aaaa', Icons.calendar_today, 'Fecha de nacimiento invàlida', _valFnacimiento),
                  maxLength: 10,
                ),
                /*MaskedTextField(
                  maskedTextFieldController: _fnacimiento,
                  escapeCharacter: '#',
                  mask: '##/##/####',
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputDecoration: UtilWidgets.maskDecoration('dd/mm/aaaa', Icons.calendar_today, 'Fecha de nacimiento invàlida', _valFnacimiento),
                ),*/
              ]
            ),
            SizedBox(height: separacion),
            Column(
              children: <Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    Text(
                      'Teléfono',
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 16, color: Colors.white)
                    ),
                  ]
                ),
                TextFormField(
                  controller: _telefono,
                  inputFormatters: [MaskTextInputFormatter(mask: "##-####-####")],
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.always,
                  //validator: validator,
                  decoration: UtilWidgets.maskDecoration('##-####-####', Icons.calendar_today, 'Fecha de nacimiento invàlida', _valTelefono),
                  maxLength: 12,
                ),
                /*MaskedTextField(
                  maskedTextFieldController: _telefono,
                  escapeCharacter: '#',
                  mask: '##-####-####',
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  inputDecoration: UtilWidgets.maskDecoration('##-####-####', Icons.call, 'Teléfono inválido', _valTelefono),
                ),*/
              ]
            ),
            SizedBox(height: separacion),
            Divider(
              color: Colors.white,
            ),
            SizedBox(height: separacion),
            InputText(
              label: "Usuario",
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.alternate_email,
              onChanged: (text){_user = text!;},
              validator: (text) => !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text!) ? "Usuario inválido" : null,
              initialValue: response!['usuario'],
              readOnly: true,
              maxLength: 100,
            ),
            SizedBox(height: separacion),
            InputText(
              label: "Contraseña",
              hintText: "Contraseña",
              prefixIcon: Icons.lock,
              obscureText: true,
              initialValue: response!['contrasena'],
              onChanged: (text) => _password = text!,
              validator: (text) => !RegExp(r"^(?=.*[a-z])(?=.*[A-Z])[A-Za-z\d!@#$%^&*()_+]{8,20}$").hasMatch(text!) ? "8-20 caracteres, una mayúscula y una minúscula" : null,
              maxLength: 25,
            ),
            SizedBox(height: separacion),
            InputText(
              label: "Confirmar contraseña",
              hintText: "Confirmar contraseña",
              prefixIcon: Icons.lock,
              obscureText: true,
              initialValue: response!['contrasena'],
              //onChanged: (text) => _confirmar = text,
              validator: (text) => _password!=text! ? "Las contraseñas no son iguales" : null,
              maxLength: 25,
            ),
            SizedBox(height: separacion),
            Divider(
              color: Colors.white,
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
                    onPressed: () => _guardarCambios(),
                    child: Text(
                      'GUARDAR CAMBIOS',
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
    );
  }

  @override
  void dispose(){
    _fnacimiento.dispose();
    _telefono.dispose();
    super.dispose();
  }
}
