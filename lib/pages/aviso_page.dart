import 'package:shopitrack/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class AvisoPage extends StatefulWidget {
  static const routeName = "aviso";
  @override
  _AvisoPageState createState() => _AvisoPageState();
}

class _AvisoPageState extends State<AvisoPage> {

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    //double heightAppBar = Scaffold.of(context).appBarMaxHeight;
    double heightAppBar = (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AVISO DE PRIVACIDAD',
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
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: responsive.dp(2)),
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: <TextSpan> [
                      TextSpan(text: 'IDENTIDAD Y DOMICILIO DEL RESPONSABLE.\nEn FRABEL, S.A. DE C.V., (en adelante FRABEL) distribuidor de la marca KIEHL’S (en adelante la “Marca”) con domicilio en Félix Cuevas # 6, Colonia Tlacoquemécatl del Valle, Delegación Benito Juárez, Código Postal 03200 en la Ciudad de México, los datos personales y personales sensibles, de nuestros consumidores y posibles consumidores (en adelante “datos personales”), son tratados de forma estrictamente privada y confidencial, por lo que la obtención, tratamiento, transferencia y ejercicio de los derechos derivados de dichos datos personales, se hace mediante un uso adecuado, legítimo y lícito, salvaguardando permanentemente los principios de licitud, consentimiento, calidad, información, proporcionalidad, responsabilidad, lealtad y finalidad, de conformidad con lo dispuesto por la Ley Federal de Protección de Datos Personales en Posesión de los Particulares, su Reglamento y disposiciones secundarias.\n\n'),
                      TextSpan(text: 'OBTENCIÓN DE DATOS PERSONALES Y FINALIDADES DE SU TRATAMIENTO.\nEn FRABEL estamos comprometidos con salvaguardar la privacidad de sus datos personales y mantener una relación estrecha y activa con nuestros consumidores y posibles consumidores por eso además de éste Aviso, aplicamos nuestra Política de Privacidad, te invitamos a conocerla.\n\n'),
                      TextSpan(text: 'A continuación, señalamos expresa y limitativamente los datos que podremos recabar de usted como consumidor y posible consumidor:\n\n'),
                      TextSpan(text: 'Datos Personales de identificación y contacto:\n\n• Nombre, apellido paterno y materno, género, edad, fecha de nacimiento, domicilio, código postal, número telefónico, número celular y correo electrónico.\n\n                      Con respecto de los datos personales antes mencionados, se garantiza un tratamiento, ya sea directa o indirectamente a través de FRABEL, sus subsidiarias, afiliadas o empresas relacionadas, y sus terceros proveedores de servicios con quienes tiene una relación jurídica; obran y tratan datos personales por cuenta de FRABEL, así como, en su caso, por las autoridades competentes, para las finalidades que dieron origen y son necesarias para la existencia, mantenimiento y cumplimiento de la relación jurídica con sus consumidores, que son las siguientes:\n\n• Para dar cumplimiento a la relación jurídica establecida con usted derivado de la adquisición de alguno de los productos de las Marcas al proveerle información sobre el mismo.\n• Para atender quejas o recomendaciones respecto del uso y aplicación de los productos de las Marcas.\n\n'),
                    ]
                  )
                ),
                //RegisterForm(),
                SizedBox(height: responsive.dp(2)),
              ],
            )
          ),
        )
      ),
    );
  }
}