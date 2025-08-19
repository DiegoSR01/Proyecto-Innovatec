// Variables para validación de login
class LoginCredentials {
  // Credenciales del Asistente
  static const String assistantEmail = 'asistente@festispot.com';
  static const String assistantPassword = 'asistente123';
  
  // Credenciales del Productor
  static const String producerEmail = 'productor@festispot.com';
  static const String producerPassword = 'productor123';
  
  // Tipos de usuario
  static const String userTypeAssistant = 'asistente';
  static const String userTypeProducer = 'productor';
  
  // Método para validar credenciales y retornar tipo de usuario
  static String? validateCredentials(String email, String password) {
    if (email == assistantEmail && password == assistantPassword) {
      return userTypeAssistant;
    } else if (email == producerEmail && password == producerPassword) {
      return userTypeProducer;
    }
    return null; // Credenciales inválidas
  }
}

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
  );
}
