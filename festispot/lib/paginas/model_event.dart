class Evento {
  final int id;
  final String nombre;
  final String imagen;
  final String descripcion;
  final String categoria;
  final String ubicacion;
  final String fecha;

  const Evento({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.categoria,
    required this.ubicacion,
    required this.fecha,
  });

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'],
    nombre: json['nombre'],
    imagen: json['imagen'],
    descripcion: json['descripcion'],
    categoria: json['categoria'],
    ubicacion: json['ubicacion'],
    fecha: json['fecha'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'imagen': imagen,
    'descripcion': descripcion,
    'categoria': categoria,
    'ubicacion': ubicacion,
    'fecha': fecha,
  };

  Evento copy() => Evento(
    id: id,
    nombre: nombre,
    imagen: imagen,
    descripcion: descripcion,
    categoria: categoria,
    ubicacion: ubicacion,
    fecha: fecha,
  );
}
