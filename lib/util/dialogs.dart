import 'package:shopitrack/models/Parametros.dart';
import 'package:shopitrack/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Dialogs {
  static dialog(BuildContext context, {String title='', String content='', List<ParamDialog>? actions}) {
    final String platform = Util.platform;
    print('plataforma: $platform');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => platform=='ios' ?
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: _genActions(context, actions, platform)
      ) :
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: _genActions(context, actions, platform)
      )
    );
  }

  static List<Widget> _genActions(BuildContext context, List<ParamDialog>? actions, String platform){
    List<Widget> list = <Widget>[];
    //print('acciones: $actions');
    if (actions==null)
      list.add(platform=='ios' ?
        CupertinoDialogAction(
          child: Text("OK"),
          onPressed: () => Navigator.pop(context)
        ) :
        MaterialButton(//FlatButton(
          child: Text("OK"),
          onPressed: () => Navigator.pop(context)
        )
      );
    else
      list = actions.map((param) {
        return platform=='ios' ?
          CupertinoDialogAction(
            child: Text(param.text),
            onPressed: param.onPresed,
          ) :
        MaterialButton(//FlatButton(
            child: Text(param.text),
            onPressed: param.onPresed,
          );
      }).toList();
    return list;
  }
}

class ProgressDialog {
  final BuildContext context;
  ProgressDialog(this.context);

  void show(){
    showCupertinoModalPopup(
      context: this.context,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: CircularProgressIndicator(),
          )
        ),
      )
    );
  }

  void dismiss(){
    Navigator.pop(context);
  }
}