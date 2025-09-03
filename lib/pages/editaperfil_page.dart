import 'package:shopitrack/pagesforms/editaperfil_form.dart';
import 'package:shopitrack/pagesforms/editaperfiltransp_form.dart';
import 'package:shopitrack/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class EditaPerfilPage extends StatefulWidget {
  static const routeName = "editaperfil";
  final String tipo;

  EditaPerfilPage({Key? key, required this.tipo}) : super(key: key);

  @override
  _EditaPerfilPageState createState() => _EditaPerfilPageState();
}

class _EditaPerfilPageState extends State<EditaPerfilPage> {

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EDITAR CUENTA',
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
                widget.tipo=='U' ? EditaPerfilForm() : EditaPerfilTranspForm(),
                SizedBox(height: responsive.dp(2)),
              ],
            )
          ),
        )
      ),
    );
  }
}