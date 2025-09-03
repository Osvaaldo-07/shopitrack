import 'package:shopitrack/pages/home_page.dart';
import 'package:shopitrack/pages/hometransp_page.dart';
import 'package:shopitrack/pages/register_page.dart';
import 'package:shopitrack/util/auth.dart';
import 'package:shopitrack/util/dialogs.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:shopitrack/util/services.dart';
import 'package:shopitrack/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';
import 'package:shopitrack/widgets/input_text.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  String _user = "";
  String _password = "";

  _ingresar() async {
    //print('ingresar: ${Util.firebase}');
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'usuario': _user,
        'contrasena': _password,
        'token': Util.getToken(_password + _user),
        'firebase': Util.firebase
      };
      print('data $data');
      Map<String, dynamic>? response = await Services.instance.enviaSolicitud('login', data, context);
      //print(response);
      if (response != null) {
        if (response['codigo'] == 0) {
          await Auth.instance.setSession(response);

          //Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (_)=>false, arguments:{response['nombre'], response['token']});
          if (!_user.contains("@") && Util.intValidator(_user.substring(0,4))!=null && Util.intValidator(_user.substring(5,8))!=null)
            Navigator.pushNamedAndRemoveUntil(context, HomeTranspPage.routeName, (_)=>false);
          else
            Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (_)=>false);
        }
        else
          Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
      }
    }
  }

  _registrar() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  _olvido() async {
    if (_user.length < 8)
      Dialogs.dialog(context, title:'Error', content:'Capturre el usuario del que desea recuperar la contraseña');
    else {
      Map<String, dynamic> data = {
        'usuario': _user,
        'token': Util.getToken(_user)
      };
      Map<String, dynamic>? response = await Services.instance.enviaSolicitud('olvidoContrasena', data, context);
      if (response != null) {
        if (response['codigo'] == 0)
          Dialogs.dialog(context, title: 'Aviso', content: response["mensaje"]);
        else
          Dialogs.dialog(context, title: "Error", content: response["mensaje"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      padding: EdgeInsets.only(left:40, right: 40),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputText(
              label: "Usuario",
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.account_box,
              onChanged: (text) => _user = text!,
              validator: (String? text) { if (text!.length<8) return "Usuario inválido"; else return null;},
              maxLength: 100,
            ),
            SizedBox(height: responsive.dp(1.5)),
            InputText(
              label: "Contraseña",
              hintText: "Contraseña",
              prefixIcon: Icons.lock,
              obscureText: true,
              onChanged: (text) => _password = text!,
              validator: (text) => text!.length<8 ? "Contraseña inválida" : null,
              maxLength: 25,
            ),
            SizedBox(height: responsive.dp(2)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget> [
                Container(
                  height: 38,
                  child: MaterialButton(//FlatButton(
                    child: Text(
                      'Olvide mi contraseña',
                      style: TextStyle(fontFamily: UtilWidgets.mainFont, fontSize: 16, color: Colors.white, decoration: TextDecoration.underline)
                    ),
                    padding: EdgeInsets.all(0),
                    height: 30,
                    onPressed: () => _olvido(),
                  ),
                )
              ]
            ),
            //SizedBox(height: responsive.dp(1)),
            Row(
              children: <Widget> [
                Expanded(
                  child: MaterialButton(//FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.white)
                    ),
                    color: Color(0xFF1846E8),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    onPressed: () => _registrar(),
                    child: Text(
                      'CREAR CUENTA',
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  ),
                ),
              ]
            ),
            SizedBox(height: responsive.dp(2)),
            Divider(
              color: Colors.white,
            ),
            SizedBox(height: responsive.dp(1)),
          ]
        ),
      ),
    );
  }
}
