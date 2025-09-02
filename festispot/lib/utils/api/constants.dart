class ApiConstants {
  // URL base de la API - Cambiar por tu URL real
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Endpoints de la API
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String eventsEndpoint = '/events';
  
  // Rutas específicas de autenticación
  static const String loginEndpoint = '$authEndpoint/login';
  static const String registerEndpoint = '$authEndpoint/register';
  static const String refreshTokenEndpoint = '$authEndpoint/refresh';
  static const String logoutEndpoint = '$authEndpoint/logout';
  
  // Rutas específicas de usuarios
  static const String userProfileEndpoint = '$usersEndpoint/profile';
  static const String updateUserEndpoint = '$usersEndpoint/update';
  
  // Rutas específicas de eventos
  static const String allEventsEndpoint = '$eventsEndpoint/all';
  static const String createEventEndpoint = '$eventsEndpoint/create';
  static const String updateEventEndpoint = '$eventsEndpoint/update';
  static const String deleteEventEndpoint = '$eventsEndpoint/delete';
  
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
