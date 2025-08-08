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
