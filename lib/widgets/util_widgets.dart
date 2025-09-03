import 'package:flutter/material.dart';

class UtilWidgets {

  static String _mainFont = 'Montserrat';

  static String get mainFont => _mainFont;

  static LinearGradient getGradientSys(){
    return LinearGradient(
      colors: [Color(0xFF1846E8), Color(0xFF182F9F), Colors.black45],
      //colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF), Colors.white],
      begin: Alignment.center,
      end: Alignment.bottomCenter,
      stops: [0.33,0.67,1.0],
      tileMode: TileMode.clamp
    );
  }

  static InputDecoration maskDecoration(String hintText, IconData icon, String msgError, bool statusError){
    return InputDecoration(
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(25)),
            borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none
            )
        ),
        filled: true,
        fillColor: Colors.white,
        //labelText: 'OOOOOO',//this.label,
        hintStyle: TextStyle(
          fontSize: 16,
          fontFamily: UtilWidgets.mainFont,
        ),
        prefixIcon: Padding(
          padding:const EdgeInsets.all(0),
          child:Icon(
            icon,
            size: 20.0,
            color: Color(0xFF1846E8)
          )
        ),
        isDense: true,
        contentPadding: EdgeInsets.all(0),
        hintText: hintText,
        counterText: '',
        errorText: !statusError ? msgError : null
    );
  }
}