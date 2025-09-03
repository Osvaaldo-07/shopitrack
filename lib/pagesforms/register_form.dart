import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shopitrack/models/Parametros.dart';
import 'package:shopitrack/pages/aviso_page.dart';
import 'package:shopitrack/pages/home_page.dart';
import 'package:shopitrack/pages/terminos_page.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/util/dialogs.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'package:shopitrack/widgets/input_text.dart';
//import 'package:masked_text/masked_text.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

enum SingingCharacter {Mujer, Hombre, NA}

class _RegisterFormState extends State<RegisterForm> {
  //Future<void> _launched;
  GlobalKey<FormState> _formKey = new GlobalKey();
  String _nombre = "";
  String _apaterno = "";
  String _amaterno = "";
  SingingCharacter _genero = SingingCharacter.NA;
  TextEditingController _fnacimiento = TextEditingController();
  TextEditingController _telefono = TextEditingController();
  String _user = "";
  String _password = "";
  //String _confirmar = "";
  bool _terminos = false;
  bool _valFnacimiento = true;
  bool _valTelefono = true;
  String _codigo = "";

  _ingresar() async {
    setState(() {
      //print('fecha: ${_fnacimiento.text.length}');
      //print('fecha: ${_telefono.text.length}');
      if (_fnacimiento.text.length > 0)
        _valFnacimiento = Util.isValidDate(_fnacimiento.text, 'dd/MM/yyyy');
      if (_telefono.text.length > 0)
        _valTelefono = _telefono.text.length!=12 ? false : true;
    });
    if (_formKey.currentState!.validate() && _valFnacimiento && _valTelefono) {
      if (!_terminos)
        Dialogs.dialog(context, title: "Error", content: 'Debe leer y aceptar los Terminos y condiciones');
      else {
        print('entro');
        Map<String, dynamic> data = {
          'nombre': _nombre,
          'apaterno': _apaterno,
          'amaterno': _amaterno,
          'genero': _genero==SingingCharacter.Mujer?'F':_genero==SingingCharacter.Hombre?'M':'N',
          'fnacimiento': _fnacimiento.text,
          'telefono': _telefono.text,
          'usuario': _user,
          'contrasena': _password,
          'token': Util.getToken(_nombre + _user),
          'codigo': _codigo
        };
        //print('${_nombre}-${_apaterno}-${_amaterno}-${_genero==SingingCharacter.Mujer?'F':'M'}-${_fnacimiento.text}-${_telefono.text}-${_user}-${_password}');
        print(data);
        Map<String, dynamic> dataLogin = {
          'usuario': _user,
          'contrasena': _password,
          'token': Util.getToken(_password + _user)
        };
        if (_codigo == '') {
          Dialogs.dialog(
              context,
              title: 'Aviso',
              content: 'No asigno ID de referencia, ¿Desea hacerlo ahora?',
              actions: [
                ParamDialog(
                    text: 'Si',
                    onPresed: () {
                      Navigator.pop(context);
                      return;
                    }
                ),
                ParamDialog(
                    text: 'No',
                    onPresed: () async {
                      Navigator.pop(context);
                      Map<String, dynamic>? response = await Services.instance.enviaSolicitud('validarRegistro', data, context);
                      if (response != null) {
                        if (response['codigo'] == 0) {
                          Dialogs.dialog(
                              context,
                              title: 'Aviso',
                              content: response["mensaje"],
                              actions: [
                                ParamDialog(
                                    text: 'Validar',
                                    onPresed: () {
                                      _validaRegistro(dataLogin);
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
                          Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
                      }
                    }
                ),
              ]
          );
        }
        else {
          Map<String, dynamic>? response = await Services.instance.enviaSolicitud('validarRegistro', data, context);
          if (response != null) {
            if (response['codigo'] == 0) {
              Dialogs.dialog(
                context,
                title: 'Aviso',
                content: response["mensaje"],
                actions: [
                  ParamDialog(
                      text: 'Validar',
                      onPresed: () {
                        _validaRegistro(dataLogin);
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
              Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
          }
        }
      }
    }
    else
      Dialogs.dialog(context, title: "Error", content: 'Al menos un dato es inválido');
  }

  _validaRegistro(Map<String, dynamic> data) async {
    Map<String, dynamic>? response = await Services.instance.enviaSolicitud('login', data, context);
    if (response != null) {
      if (response['codigo'] == 0) {
        await Auth.instance.setSession(response);
        Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (_)=>false);
        //Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (_)=>false, arguments:{response['nombre'], response['token']});
      }
      else
        Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
    }
  }

  _verTerminos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TerminosPage()),
    );
  }

  _verAviso() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AvisoPage()),
    );
  }

  /*Future<void> _irShopitrack() async {
    if (await canLaunch('http://www.gnsystems.com.mx')) {
      await launch(
        'http://www.gnsystems.com.mx',
        forceSafariVC: false,
        forceWebView: false,
      );
    }
    else
      throw 'Could not launch www.gnsystems.com.mx';
  }*/

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double separacion = responsive.dp(2);
    return Container(
        padding: EdgeInsets.only(left:40, right: 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InputText(
                label: "Nombre",
                hintText: "Nombre",
                prefixIcon: Icons.account_circle_outlined,
                maxLength: 30,
                onChanged: (text) => _nombre = text!,
                validator: (text) => text!.trim()=='' ? "Nombre inválido" : null,
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
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: separacion),
              InputText(
                label: "Apellido Materno",
                hintText: "Apellido Materno",
                prefixIcon: Icons.account_circle_outlined,
                maxLength: 30,
                onChanged: (text) => _amaterno = text!,
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
                    decoration: UtilWidgets.maskDecoration('dd/mm/aaaa', Icons.calendar_today, 'Fecha de nacimiento inválida', _valFnacimiento),
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
                    decoration: UtilWidgets.maskDecoration('##-####-####', Icons.calendar_today, 'Teléfono inválido', _valTelefono),
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
                maxLength: 100,
              ),
              SizedBox(height: separacion),
              InputText(
                label: "Contraseña",
                hintText: "Contraseña",
                prefixIcon: Icons.lock,
                obscureText: true,
                onChanged: (text) => _password = text!,
                validator: (text) => !RegExp(r"^(?=.*[a-z])(?=.*[A-Z])[A-Za-z\d!@#$%^&*()_+]{8,20}$").hasMatch(text!) ? "8-20 caracteres, una mayúscula y una minúscula" : null,//^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d][A-Za-z\d!@#$%^&*()_+]{7,19}$
                maxLength: 25,
              ),
              SizedBox(height: separacion),
              InputText(
                label: "Confirmar contraseña",
                hintText: "Confirmar contraseña",
                prefixIcon: Icons.lock,
                obscureText: true,
                //onChanged: (text) => _confirmar = text,
                validator: (text) => _password!=text! ? "Las contraseñas no son iguales" : null,
                maxLength: 25,
              ),
              SizedBox(height: separacion),
              Divider(
                color: Colors.white,
              ),
              SizedBox(height: separacion),
              InputText(
                label: "ID de referencia",
                hintText: "ID de referencia",
                keyboardType: TextInputType.text,
                prefixIcon: Icons.code,
                onChanged: (text){_codigo = text!;},
                maxLength: 6,
              ),
              SizedBox(height: separacion),
              Divider(
                color: Colors.white,
              ),
              SizedBox(height: responsive.dp(0.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _terminos,
                    onChanged: (bool? value) => setState(() => _terminos = value!)
                  ),
                  Expanded(
                    child: MaterialButton(//FlatButton(
                      child: Text(
                        'Acepto terminos y condiciones',
                        style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: responsive.width>400?16:14, color: Colors.white, decoration: TextDecoration.underline),
                        overflow: TextOverflow.visible,
                      ),
                      onPressed: () => _verTerminos()
                    ),
                  ),
                ],
              ),
              MaterialButton(//FlatButton(
                child: Text(
                    'Aviso de privacidad',
                    style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 16, color: Colors.white, decoration: TextDecoration.underline)
                ),
                onPressed: () => _verAviso()
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
                      onPressed: () => _ingresar(),
                      child: Text(
                        'INGRESAR',
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
