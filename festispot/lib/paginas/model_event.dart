class Evento {
  final int id;
  final String nombre;
  final String imagen;
  final String descripcion;

  const Evento({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.descripcion,
  }); // Corregido "Eveto" a "Evento"

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'],
    nombre: json['nombre'],
    imagen: json['imagen'],
    descripcion: json['descripcion'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'imagen': imagen,
    'descripcion': descripcion,
  };

  Evento copy() =>
      Evento(id: id, nombre: nombre, imagen: imagen, descripcion: descripcion);
}
