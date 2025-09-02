import '../models/api_response.dart';
import '../models/user.dart';
import '../models/event.dart';

class MockApiService {
  static bool _isEnabled = false;
  static bool get isEnabled => _isEnabled;
  
  static void enable() => _isEnabled = true;
  static void disable() => _isEnabled = false;

  // Datos simulados
  static final List<User> _mockUsers = [
    User(
      id: '1',
      email: 'asistente@festispot.com',
      name: 'Usuario Asistente',
      userType: 'asistente',
      phone: '+1234567890',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: '2',
      email: 'productor@festispot.com',
      name: 'Usuario Productor',
      userType: 'productor',
      phone: '+0987654321',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  static final List<Event> _mockEvents = [
    Event(
      id: '1',
      title: 'Festival de Jazz en el Parque',
      description: 'Un festival increíble de jazz con artistas locales e internacionales.',
      category: 'Música',
      location: 'Parque Central, Ciudad',
      date: DateTime.now().add(const Duration(days: 15)),
      startTime: DateTime.now().add(const Duration(days: 15, hours: 18)),
      endTime: DateTime.now().add(const Duration(days: 15, hours: 23)),
      price: 25.0,
      organizerId: '2',
      organizerName: 'Usuario Productor',
      capacity: 500,
      attendeesCount: 234,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Event(
      id: '2',
      title: 'Exposición de Arte Moderno',
      description: 'Una exhibición fascinante de arte contemporáneo.',
      category: 'Arte',
      location: 'Galería Municipal',
      date: DateTime.now().add(const Duration(days: 7)),
      startTime: DateTime.now().add(const Duration(days: 7, hours: 10)),
      endTime: DateTime.now().add(const Duration(days: 7, hours: 18)),
      price: 15.0,
      organizerId: '2',
      organizerName: 'Usuario Productor',
      capacity: 200,
      attendeesCount: 89,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Event(
      id: '3',
      title: 'Concierto de Rock',
      description: 'Una noche épica con las mejores bandas de rock local.',
      category: 'Música',
      location: 'Estadio Principal',
      date: DateTime.now().add(const Duration(days: 20)),
      startTime: DateTime.now().add(const Duration(days: 20, hours: 20)),
      endTime: DateTime.now().add(const Duration(days: 21, hours: 1)),
      price: 40.0,
      organizerId: '2',
      organizerName: 'Usuario Productor',
      capacity: 2000,
      attendeesCount: 1567,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  static User? _currentUser;

  // Simular delay de red
  static Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 500 + (DateTime.now().millisecond % 1000)));
  }

  // Mock login
  static Future<ApiResponse<User>> mockLogin(String email, String password) async {
    await _simulateNetworkDelay();

    // Validar credenciales mock
    if ((email == 'asistente@festispot.com' && password == 'asistente123') ||
        (email == 'productor@festispot.com' && password == 'productor123')) {
      
      final user = _mockUsers.firstWhere((u) => u.email == email);
      _currentUser = user;
      
      return ApiResponse<User>.success(
        message: 'Login exitoso',
        data: user,
      );
    }

    return ApiResponse<User>.error(
      message: 'Credenciales incorrectas',
      statusCode: 401,
    );
  }

  // Mock register
  static Future<ApiResponse<User>> mockRegister({
    required String email,
    required String password,
    String? name,
    String? phone,
    required String userType,
  }) async {
    await _simulateNetworkDelay();

    // Verificar si el email ya existe
    if (_mockUsers.any((u) => u.email == email)) {
      return ApiResponse<User>.error(
        message: 'El email ya está registrado',
        statusCode: 409,
      );
    }

    final newUser = User(
      id: '${_mockUsers.length + 1}',
      email: email,
      name: name ?? 'Usuario Nuevo',
      phone: phone,
      userType: userType,
      createdAt: DateTime.now(),
    );

    _mockUsers.add(newUser);
    _currentUser = newUser;

    return ApiResponse<User>.success(
      message: 'Usuario registrado exitosamente',
      data: newUser,
    );
  }

  // Mock logout
  static Future<ApiResponse<void>> mockLogout() async {
    await _simulateNetworkDelay();
    _currentUser = null;
    return ApiResponse<void>.success(message: 'Logout exitoso');
  }

  // Mock get events
  static Future<ApiResponse<List<Event>>> mockGetEvents() async {
    await _simulateNetworkDelay();
    return ApiResponse<List<Event>>.success(
      message: 'Eventos obtenidos exitosamente',
      data: List.from(_mockEvents),
    );
  }

  // Mock create event
  static Future<ApiResponse<Event>> mockCreateEvent({
    required String title,
    required String description,
    String? category,
    String? location,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    double? price,
    int? capacity,
  }) async {
    await _simulateNetworkDelay();

    if (_currentUser?.userType != 'productor') {
      return ApiResponse<Event>.error(
        message: 'Solo los productores pueden crear eventos',
        statusCode: 403,
      );
    }

    final newEvent = Event(
      id: '${_mockEvents.length + 1}',
      title: title,
      description: description,
      category: category ?? 'General',
      location: location ?? 'Ubicación por definir',
      date: date ?? DateTime.now().add(const Duration(days: 30)),
      startTime: startTime,
      endTime: endTime,
      price: price ?? 0.0,
      organizerId: _currentUser!.id,
      organizerName: _currentUser!.name,
      capacity: capacity ?? 100,
      attendeesCount: 0,
      isActive: true,
      createdAt: DateTime.now(),
    );

    _mockEvents.add(newEvent);

    return ApiResponse<Event>.success(
      message: 'Evento creado exitosamente',
      data: newEvent,
    );
  }

  // Mock get profile
  static Future<ApiResponse<User>> mockGetProfile() async {
    await _simulateNetworkDelay();

    if (_currentUser == null) {
      return ApiResponse<User>.error(
        message: 'Usuario no autenticado',
        statusCode: 401,
      );
    }

    return ApiResponse<User>.success(
      message: 'Perfil obtenido exitosamente',
      data: _currentUser!,
    );
  }

  // Mock connectivity check
  static Future<bool> mockCheckConnectivity() async {
    await _simulateNetworkDelay();
    return true; // Siempre "conectado" en modo mock
  }

  // Getters
  static User? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;
  static List<Event> get events => List.from(_mockEvents);
  static List<User> get users => List.from(_mockUsers);
}
