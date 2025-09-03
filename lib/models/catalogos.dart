class Direccion {
  final String id;
  final String calle;
  final String exterior;
  final String interior;
  final String colonia;
  final String cp;
  final String ciudad;
  final String municipio;
  final String alias;
  final String imagen;

  Direccion({required this.id, required this.calle, required this.exterior, required this.interior, required this.colonia, required this.cp, required this.ciudad, required this.municipio, required this.alias, required this.imagen});

  static Direccion fromJson(Map<String, dynamic> json){
    return Direccion(
      id: json['ID'],
      calle: json['CALLE'],
      exterior: json['EXTERIOR'],
      interior: json['INTERIOR']==null ? '' : json['INTERIOR'],
      colonia: json['COLONIA'],
      cp: json['CP'],
      ciudad: json['CIUDAD'],
      municipio: json['MUNICIPIO'],
      alias: json['ALIAS'],
      imagen: json['IMAGEN']==null||json['IMAGEN']=='' ? 'imagen.jpg' : json['IMAGEN'],
    );
  }
}

class Orden {
  final String id;
  final String orden;
  final String direccion;
  final String status;
  final String fechaentrega;
  final String usuario;
  final String nombre;
  final String posicion;
  final String? cliente;
  final String? estructura;
  final String? transportista;

  Orden({required this.id, required this.orden, required this.direccion, required this.status, required this.fechaentrega, required this.usuario, required this.nombre, required this.posicion, this.cliente, this.estructura, this.transportista});

  static Orden fromJson(Map<String, dynamic> json){
    return Orden(
      id: json['ID'],
      orden: json['ORDEN'],
      direccion: json['DIRECCION'],
      status: json['STATUS'],
      fechaentrega: json['FECHAENTREGA'],
      usuario: json['USUARIO'],
      nombre: json['NOMBRE'],
      posicion: json['POSICION'],
      cliente: json['CLIENTE'],
      estructura: json['ESTRUCTURA'],
      transportista: json['TRANSPORTISTA'],
    );
  }
}

class Notificacion {
  final String idnotif;
  final String titulo;
  final String mensaje;
  final String evento;
  final String visto;
  final String fnotificacion;
  final String idorden;
  final String orden;
  final String direccion;
  final String usuario;
  final String nombre;
  final String cliente;
  final String estructura;

  Notificacion({required this.idnotif, required this.titulo, required this.mensaje, required this.evento, required this.visto, required this.fnotificacion, required this.idorden, required this.orden, required this.direccion, required this.usuario, required this.nombre, required this.cliente, required this.estructura});

  static Notificacion fromJson(Map<String, dynamic> json){
    return Notificacion(
      idnotif: json['IDNOTIF'],
      titulo: json['TITULO'],
      mensaje: json['MENSAJE'],
      evento: json['EVENTO'],
      visto: json['VISTO'],
      fnotificacion: json['FNOTIFICACION'],
      idorden: json['IDORDEN'],
      orden: json['ORDEN'],
      direccion: json['DIRECCION'],
      usuario: json['USUARIO'],
      nombre: json['NOMBRE'],
      cliente: json['CLIENTE'],
      estructura: json['ESTRUCTURA'],
    );
  }
}

class Preguntas {
  final String idpregunta;
  final String idtmp;
  final String estructura;
  final String pregunta;
  final String tiporespuesta;
  final String respuesta;
  final String orden;
  final String resporden;
  final List<Respuestas> respuestas;

  Preguntas({required this.idpregunta, required this.idtmp, required this.estructura, required this.pregunta, required this.tiporespuesta, required this.respuesta, required this.orden, required this.resporden, required this.respuestas});

  static Preguntas fromJson(Map<String, dynamic> json){
    return Preguntas(
      idpregunta: json['IDPREGUNTA'],
      idtmp: json['IDTMP'],
      estructura: json['ESTRUCTURA'],
      pregunta: json['PREGUNTA'],
      tiporespuesta: json['TIPORESPUESTA'],
      respuesta: json['RESPUESTA'],
      orden: json['ORDEN'],
      resporden: json['RESPORDEN'],
      respuestas: [],
    );
  }
}

class Respuestas {
  final String tipo;
  final String respuesta;
  final String resporden;

  Respuestas({required this.tipo, required this.respuesta, required this.resporden});
}

class Puntos {
  final String origen;
  final String foperacion;
  final int puntos;

  Puntos({required this.origen, required this.foperacion, required this.puntos});

  static Puntos fromJson(Map<String, dynamic> json){
    return Puntos(
      origen: json['ORIGEN'],
      foperacion: json['FOPERACION'],
      puntos: int.tryParse(json['PUNTOS']) ?? 0,
    );
  }
}

class Promociones {
  final String imagen;
  final String texto;
  final String url;

  Promociones({required this.imagen, required this.texto, required this.url});

  static Promociones fromJson(Map<String, dynamic> json){
    return Promociones(
      imagen: json['IMAGEN'],
      texto: json['TEXTO'],
      url: json['URL']
    );
  }
}
