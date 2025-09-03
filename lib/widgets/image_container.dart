import 'package:flutter/material.dart';

class ImageContainer extends StatefulWidget {
  final double width;
  final double? height;
  final String? typeImg;
  final String image;
  final Color? color;
  final double padding;
  final void Function()? onTap;
  final double? radio;

  ImageContainer({Key? key, required this.width, this.height, this.typeImg, required this.image, this.color, this.padding=10, this.onTap, this.radio}) :
        assert(width>0), super(key: key);

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {

  late String imageUrl;

  @override
  void initState(){
    imageUrl = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(imageUrl+'   IconCont');
    return InkWell(
      child: Container(
        width: widget.width,
        height: widget.height!=null && widget.height!>0 ? widget.height : widget.width,
        decoration: BoxDecoration(
          color: widget.color!=null ? widget.color : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.width*(widget.radio==null ? 0 : widget.radio!)),
          image: DecorationImage(
            image: widget.typeImg!=null && widget.typeImg=='url' ? imageUrl.contains('//') ? NetworkImage(imageUrl) : AssetImage('assets/$imageUrl') as ImageProvider : AssetImage('assets/${widget.image}'),
            onError: (dynamic, stacktrace){
              //print('osvaldo');
              setState(() {
                imageUrl = 'foto.png';
              });
            },
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 25,
              //spreadRadius: ,
              offset: Offset(0, 10),
            ),
          ]
        ),
      ),
      onTap: widget.onTap
    );
  }
}
