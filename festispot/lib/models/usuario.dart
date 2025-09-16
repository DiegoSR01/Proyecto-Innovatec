class Usuario {
  final int? id;
  final String nombre;
  final String apellido;
  final String email;
  final String? password;
  final String? telefono;
  final String? fechaNacimiento;
  final String? genero;
  final String? avatarUrl;
  final int rolId; // 1=asistente, 2=productor, 3=organizador
  final String estado; // activo, inactivo, suspendido
  final DateTime? fechaRegistro;
  final DateTime? ultimoAcceso;
  final String? tokenVerificacion;
  final bool emailVerificado;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  const Usuario({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.password,
    this.telefono,
    this.fechaNacimiento,
    this.genero,
    this.avatarUrl,
    this.rolId = 1, // Asistente por defecto
    this.estado = 'activo',
    this.fechaRegistro,
    this.ultimoAcceso,
    this.tokenVerificacion,
    this.emailVerificado = false,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  /// Crea un Usuario desde un JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString(),
      telefono: json['telefono']?.toString(),
      fechaNacimiento: json['fecha_nacimiento']?.toString(),
      genero: json['genero']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      rolId: json['rol_id'] != null ? int.tryParse(json['rol_id'].toString()) ?? 1 : 1,
      estado: json['estado']?.toString() ?? 'activo',
      fechaRegistro: json['fecha_registro'] != null 
          ? DateTime.tryParse(json['fecha_registro'].toString())
          : null,
      ultimoAcceso: json['ultimo_acceso'] != null 
          ? DateTime.tryParse(json['ultimo_acceso'].toString())
          : null,
      tokenVerificacion: json['token_verificacion']?.toString(),
      emailVerificado: json['email_verificado'] == 1 || json['email_verificado'] == true,
      fechaCreacion: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      fechaActualizacion: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  /// Convierte el Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      if (password != null) 'password': password,
      if (telefono != null) 'telefono': telefono,
      if (fechaNacimiento != null) 'fecha_nacimiento': fechaNacimiento,
      if (genero != null) 'genero': genero,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'rol_id': rolId,
      'estado': estado,
      if (tokenVerificacion != null) 'token_verificacion': tokenVerificacion,
      'email_verificado': emailVerificado ? 1 : 0,
      if (fechaCreacion != null) 'created_at': fechaCreacion!.toIso8601String(),
      if (fechaActualizacion != null) 'updated_at': fechaActualizacion!.toIso8601String(),
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
    String? apellido,
    String? email,
    String? password,
    String? telefono,
    String? fechaNacimiento,
    String? genero,
    String? avatarUrl,
    int? rolId,
    String? estado,
    DateTime? fechaRegistro,
    DateTime? ultimoAcceso,
    String? tokenVerificacion,
    bool? emailVerificado,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      password: password ?? this.password,
      telefono: telefono ?? this.telefono,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      genero: genero ?? this.genero,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rolId: rolId ?? this.rolId,
      estado: estado ?? this.estado,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      ultimoAcceso: ultimoAcceso ?? this.ultimoAcceso,
      tokenVerificacion: tokenVerificacion ?? this.tokenVerificacion,
      emailVerificado: emailVerificado ?? this.emailVerificado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  /// Verifica si es un asistente
  bool get esAsistente => rolId == 1;

  /// Verifica si es un organizador/productor
  bool get esProductor => rolId == 2;

  /// Verifica si es un administrador
  bool get esAdmin => rolId == 3;

  /// Obtiene el nombre del rol
  String get nombreRol {
    switch (rolId) {
      case 1:
        return 'Asistente';
      case 2:
        return 'Organizador';
      case 3:
        return 'Administrador';
      default:
        return 'Desconocido';
    }
  }

  /// Obtiene el nombre completo
  String get nombreCompleto => '$nombre $apellido';

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
    return 'Usuario(id: $id, nombre: $nombre, apellido: $apellido, email: $email, rol: $nombreRol)';
  }
}
