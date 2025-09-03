import 'package:flutter/material.dart';
import 'package:shopitrack/widgets/util_widgets.dart';

class InputText extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool borderEnabled;
  final double fontSize;
  final String hintText;
  final IconData? icon;
  final void Function(String? text)? onChanged;
  final void Function(String? text)? onSaved;
  final String? Function(String? text)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int maxLength;
  final String initialValue;
  final bool readOnly;
  final EdgeInsetsGeometry? contentPadding;
  final textCapitalization;
  InputText({
    Key? key,
    this.label = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.borderEnabled = true,
    this.fontSize = 15,
    this.hintText = '',
    this.icon,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    required this.maxLength,
    this.initialValue = '',
    this.readOnly = false,
    this.contentPadding,
    this.textCapitalization,
  }) : super(key: key);

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {

  late bool _passwordVisible;

  @override
  void initState(){
    super.initState();
    _passwordVisible = widget.obscureText ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Text(
              widget.label,
              style: TextStyle(
                fontFamily: UtilWidgets.mainFont,
                fontSize: 16,
                color: Colors.white
              )
            ),
          ]
        ),
        TextFormField(
          keyboardType: widget.keyboardType,
          obscureText: !_passwordVisible,
          onChanged: widget.onChanged,
          validator: widget.validator,
          onSaved: widget.onSaved,
          maxLength: widget.maxLength,
          textCapitalization: widget.textCapitalization!=null ? widget.textCapitalization : TextCapitalization.none,
          style: TextStyle(
            fontSize: 16,
            fontFamily: UtilWidgets.mainFont,
          ),
          decoration: InputDecoration(
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
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontFamily: UtilWidgets.mainFont,
            ),
            icon: widget.icon!=null ? Icon(widget.icon, size: 27.0, color: Color(0xFF1846E8)): null,
            prefixIcon: widget.prefixIcon!=null ? Padding(padding:const EdgeInsets.all(0),child:Icon(widget.prefixIcon, size: 20.0, color: Color(0xFF1846E8))): null,
            suffixIcon: _verPassword(),//this.suffixIcon!=null ? Icon(this.suffixIcon, size: 27.0, color: Color(0xFF1846E8)): null,
            isDense: true,
            contentPadding: widget.contentPadding==null ? EdgeInsets.all(0) : widget.contentPadding,
            counterText: '',
          ),
          initialValue: widget.initialValue,
          readOnly: widget.readOnly,
        ),
      ]
    );
  }

  _verPassword(){
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _passwordVisible ? Icons.visibility : Icons.visibility_off,
          size: 20,
          color: Color(0xFF1846E8)
        ),
        onPressed: (){
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
      );
    }
    return null;
  }
}
