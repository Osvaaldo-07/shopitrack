import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final double width;
  final double? height;
  final String? typeImg;
  final String image;
  final Color? color;
  final double padding;
  final EdgeInsets margin;
  final void Function()? onTap;
  final double? radio;

  IconContainer({Key? key, required this.width, this.height, this.typeImg, required this.image, this.color, this.padding=10, this.margin=const EdgeInsets.all(0), this.onTap, this.radio}) :
        assert(width>0), super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          //padding: EdgeInsets.all(20),
          margin: margin,
          width: this.width,
          height: this.height!=null && this.height!>0 ? this.height : this.width,
          decoration: BoxDecoration(
              color: this.color!=null ? this.color : Colors.transparent,
              borderRadius: BorderRadius.circular(this.width*(this.radio!=null ? this.radio! : 0)),
              image: DecorationImage(
                image: this.typeImg!=null && this.typeImg=='url' ? NetworkImage(this.image) : AssetImage('assets/${this.image}') as ImageProvider,
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: this.color!=null ? this.color! : Colors.black12,
                  blurRadius: 25,
                  //spreadRadius: ,
                  offset: Offset(0, 10),
                ),
              ]
          ),
        ),
        onTap: this.onTap
    );
  }
}
