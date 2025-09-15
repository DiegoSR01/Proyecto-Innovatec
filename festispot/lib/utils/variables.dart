class Evento {
  final int id;
  final String nombre;
  final String imagen;
  final String descripcion;
  final String categoria;
  final String ubicacion;
  final String fecha;
  final String hora;
  final String? precio;
  final String? capacidad;
  final String? edad;
  final String? organizador;
  final String? organizadorRating;
  final String? organizadorEventos;
  
  // Campos adicionales de la BD
  final String? descripcionCorta;
  final String? fechaFin;
  final String? horaFin;
  final String? horaAperturaPuertas;
  final String? tipoEvento;
  final String? direccionCompleta;
  final String? ciudad;
  final String? estado;
  final String? pais;
  final String? codigoPostal;
  final String? detallesUbicacion;
  final int? edadMinima;
  final String? politicasCancelacion;
  final String? instruccionesEspeciales;
  final String? tags;
  final bool? accesible;
  final String? plataformaVirtual;
  final String? enlaceEvento;
  final String? codigoAcceso;
  final String? passwordVirtual;
  final String? instruccionesVirtuales;
  final String? imagenesGaleria;
  final String? videos;
  final String? estadoEvento;
  final String? organizadorNombre;
  final String? organizadorApellido;
  final String? organizadorEmail;
  final String? organizadorTelefono;

  const Evento({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.categoria,
    required this.ubicacion,
    required this.fecha,
    required this.hora,
    this.precio,
    this.capacidad,
    this.edad,
    this.organizador,
    this.organizadorRating,
    this.organizadorEventos,
    this.descripcionCorta,
    this.fechaFin,
    this.horaFin,
    this.horaAperturaPuertas,
    this.tipoEvento,
    this.direccionCompleta,
    this.ciudad,
    this.estado,
    this.pais,
    this.codigoPostal,
    this.detallesUbicacion,
    this.edadMinima,
    this.politicasCancelacion,
    this.instruccionesEspeciales,
    this.tags,
    this.accesible,
    this.plataformaVirtual,
    this.enlaceEvento,
    this.codigoAcceso,
    this.passwordVirtual,
    this.instruccionesVirtuales,
    this.imagenesGaleria,
    this.videos,
    this.estadoEvento,
    this.organizadorNombre,
    this.organizadorApellido,
    this.organizadorEmail,
    this.organizadorTelefono,
  });

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'],
    nombre: json['nombre'],
    imagen: json['imagen'],
    descripcion: json['descripcion'],
    categoria: json['categoria'],
    ubicacion: json['ubicacion'],
    fecha: json['fecha'],
    hora: json['hora'],
    precio: json['precio'],
    capacidad: json['capacidad'],
    edad: json['edad'],
    organizador: json['organizador'],
    organizadorRating: json['organizadorRating'],
    organizadorEventos: json['organizadorEventos'],
    descripcionCorta: json['descripcion_corta'],
    fechaFin: json['fecha_fin'],
    horaFin: json['hora_fin'],
    horaAperturaPuertas: json['hora_apertura_puertas'],
    tipoEvento: json['event_type'],
    direccionCompleta: json['full_address'],
    ciudad: json['city'],
    estado: json['state'],
    pais: json['country'],
    codigoPostal: json['postal_code'],
    detallesUbicacion: json['location_details'],
    edadMinima: json['edad_minima'],
    politicasCancelacion: json['politicas_cancelacion'],
    instruccionesEspeciales: json['instrucciones_especiales'],
    tags: json['tags'],
    accesible: json['accessible'] == 1,
    plataformaVirtual: json['virtual_platform'],
    enlaceEvento: json['event_link'],
    codigoAcceso: json['access_code'],
    passwordVirtual: json['virtual_password'],
    instruccionesVirtuales: json['virtual_instructions'],
    imagenesGaleria: json['gallery_images'],
    videos: json['videos'],
    estadoEvento: json['estado'],
    organizadorNombre: json['organizador_nombre'],
    organizadorApellido: json['organizador_apellido'],
    organizadorEmail: json['organizador_email'],
    organizadorTelefono: json['organizador_telefono'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'imagen': imagen,
    'descripcion': descripcion,
    'categoria': categoria,
    'ubicacion': ubicacion,
    'fecha': fecha,
    'hora': hora,
    'precio': precio,
    'capacidad': capacidad,
    'edad': edad,
    'organizador': organizador,
    'organizadorRating': organizadorRating,
    'organizadorEventos': organizadorEventos,
    'descripcion_corta': descripcionCorta,
    'fecha_fin': fechaFin,
    'hora_fin': horaFin,
    'hora_apertura_puertas': horaAperturaPuertas,
    'event_type': tipoEvento,
    'full_address': direccionCompleta,
    'city': ciudad,
    'state': estado,
    'country': pais,
    'postal_code': codigoPostal,
    'location_details': detallesUbicacion,
    'edad_minima': edadMinima,
    'politicas_cancelacion': politicasCancelacion,
    'instrucciones_especiales': instruccionesEspeciales,
    'tags': tags,
    'accessible': accesible == true ? 1 : 0,
    'virtual_platform': plataformaVirtual,
    'event_link': enlaceEvento,
    'access_code': codigoAcceso,
    'virtual_password': passwordVirtual,
    'virtual_instructions': instruccionesVirtuales,
    'gallery_images': imagenesGaleria,
    'videos': videos,
    'estado': estadoEvento,
    'organizador_nombre': organizadorNombre,
    'organizador_apellido': organizadorApellido,
    'organizador_email': organizadorEmail,
    'organizador_telefono': organizadorTelefono,
  };

  Evento copy() => Evento(
    id: id,
    nombre: nombre,
    imagen: imagen,
    descripcion: descripcion,
    categoria: categoria,
    ubicacion: ubicacion,
    fecha: fecha,
    hora: hora,
    precio: precio,
    capacidad: capacidad,
    edad: edad,
    organizador: organizador,
    organizadorRating: organizadorRating,
    organizadorEventos: organizadorEventos,
    descripcionCorta: descripcionCorta,
    fechaFin: fechaFin,
    horaFin: horaFin,
    horaAperturaPuertas: horaAperturaPuertas,
    tipoEvento: tipoEvento,
    direccionCompleta: direccionCompleta,
    ciudad: ciudad,
    estado: estado,
    pais: pais,
    codigoPostal: codigoPostal,
    detallesUbicacion: detallesUbicacion,
    edadMinima: edadMinima,
    politicasCancelacion: politicasCancelacion,
    instruccionesEspeciales: instruccionesEspeciales,
    tags: tags,
    accesible: accesible,
    plataformaVirtual: plataformaVirtual,
    enlaceEvento: enlaceEvento,
    codigoAcceso: codigoAcceso,
    passwordVirtual: passwordVirtual,
    instruccionesVirtuales: instruccionesVirtuales,
    imagenesGaleria: imagenesGaleria,
    videos: videos,
    estadoEvento: estadoEvento,
    organizadorNombre: organizadorNombre,
    organizadorApellido: organizadorApellido,
    organizadorEmail: organizadorEmail,
    organizadorTelefono: organizadorTelefono,
  );
}
