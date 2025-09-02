class ApiConstants {
  // URL base de la API - Tu servidor real
  static const String baseUrl = 'http://10.228.2.163:8000/api';
  
  // Endpoints de la API
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String eventsEndpoint = '/v1/events';
  
  // Endpoint de prueba
  static const String testEndpoint = '/test';
  
  // Rutas específicas de autenticación
  static const String loginEndpoint = '$authEndpoint/login';
  static const String registerEndpoint = '$authEndpoint/register';
  static const String refreshTokenEndpoint = '$authEndpoint/refresh';
  static const String logoutEndpoint = '$authEndpoint/logout';
  
  // Rutas específicas de usuarios
  static const String userProfileEndpoint = '$usersEndpoint/profile';
  static const String updateUserEndpoint = '$usersEndpoint/update';
  
  // Rutas específicas de eventos (usando v1)
  static const String allEventsEndpoint = eventsEndpoint;
  static const String createEventEndpoint = eventsEndpoint;
  static const String updateEventEndpoint = eventsEndpoint;
  static const String deleteEventEndpoint = eventsEndpoint;
  
  // Headers comunes
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout para las peticiones
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Claves para SharedPreferences
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
}
