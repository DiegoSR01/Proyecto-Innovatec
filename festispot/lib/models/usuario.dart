class Usuario {
  final int? id;
  final String nombre;
  final String email;
  final String password;
  final String tipo; // 'asistente' o 'productor'
  final String? telefono;
  final String? fechaNacimiento;
  final String? fotoPerfil;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  const Usuario({
    this.id,
    required this.nombre,
    required this.email,
    required this.password,
    required this.tipo,
    this.telefono,
    this.fechaNacimiento,
    this.fotoPerfil,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  /// Crea un Usuario desde un JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      nombre: json['nombre']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? 'asistente',
      telefono: json['telefono']?.toString(),
      fechaNacimiento: json['fecha_nacimiento']?.toString(),
      fotoPerfil: json['foto_perfil']?.toString(),
      fechaCreacion: json['fecha_creacion'] != null 
          ? DateTime.tryParse(json['fecha_creacion'].toString())
          : null,
      fechaActualizacion: json['fecha_actualizacion'] != null 
          ? DateTime.tryParse(json['fecha_actualizacion'].toString())
          : null,
    );
  }

  /// Convierte el Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'email': email,
      'password': password,
      'tipo': tipo,
      if (telefono != null) 'telefono': telefono,
      if (fechaNacimiento != null) 'fecha_nacimiento': fechaNacimiento,
      if (fotoPerfil != null) 'foto_perfil': fotoPerfil,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion!.toIso8601String(),
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion!.toIso8601String(),
    };
  }

  /// Convierte el Usuario a JSON sin el password (para respuestas)
  Map<String, dynamic> toJsonSafe() {
    final json = toJson();
    json.remove('password');
    return json;
  }

  /// Crea una copia del usuario con valores actualizados
  Usuario copyWith({
    int? id,
    String? nombre,
    String? email,
    String? password,
    String? tipo,
    String? telefono,
    String? fechaNacimiento,
    String? fotoPerfil,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      password: password ?? this.password,
      tipo: tipo ?? this.tipo,
      telefono: telefono ?? this.telefono,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  /// Verifica si es un asistente
  bool get esAsistente => tipo == 'asistente';

  /// Verifica si es un productor
  bool get esProductor => tipo == 'productor';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Usuario &&
        other.id == id &&
        other.email == email;
  }

  @override
  int get hashCode => Object.hash(id, email);

  @override
  String toString() {
    return 'Usuario(id: $id, nombre: $nombre, email: $email, tipo: $tipo)';
  }
}
