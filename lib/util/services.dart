import 'package:shopitrack/util/dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class Services {
  //static const baseUrl = "http://192.168.1.73:8084/";
  static const baseUrl = "https://gnsystems.com.mx/";
  //static const baseUrl = "http://162.214.184.150:8080/";//Shopitrack
  //static const baseUrl = "http://localhost/";

  Services._internal();
  static Services _instance = Services._internal();
  static Services get instance => _instance;

  final Dio _dio = Dio(
      BaseOptions(baseUrl: baseUrl)
  );

  Future<Map<String, dynamic>?> enviaSolicitud(String metodo, Map<String, dynamic> data, [BuildContext? context]) async {
    late ProgressDialog progressDialog;
    try {
      if (context != null) {
        progressDialog = ProgressDialog(context);
        progressDialog.show();
      }
      final Response response = await this._dio.post('shopitrackws/$metodo.gns', data: data);
      //final Response response = await this._dio.post('ShopitrackWS/$metodo.gns', data: data);
      if (context != null)
        progressDialog.dismiss();
      if (response.statusCode == 200)
        return response.data;
      if (context != null)
        Dialogs.dialog(context, title: 'Error', content: 'Ocurrio un error inesperado');
      return null;
    }
    catch (e) {
      if (context != null) {
        progressDialog.dismiss();
        Dialogs.dialog(context, title: 'Error', content: e.toString());
      }
      return null;
    }
  }
}
