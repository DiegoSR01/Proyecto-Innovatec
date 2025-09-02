# FestiSpot API - Documentación

## Descripción
Esta implementación incluye toda la infraestructura necesaria para conectar la aplicación FestiSpot con una API de base de datos. La implementación está organizada dentro de `lib/utils/api/` como solicitaste.

## Estructura de la API

```
lib/utils/api/
├── constants.dart              # Constantes y configuración de la API
├── festispot_api.dart         # Archivo principal que exporta todo
├── models/                    # Modelos de datos
│   ├── api_response.dart      # Respuesta genérica de la API
│   ├── user.dart             # Modelo de usuario
│   └── event.dart            # Modelo de evento
└── services/                 # Servicios de la API
    ├── api_service.dart      # Servicio base para peticiones HTTP
    ├── auth_service.dart     # Servicio de autenticación
    ├── event_service.dart    # Servicio de eventos
    └── user_service.dart     # Servicio de usuarios
```

## Configuración

### 1. Cambiar la URL de la API
Edita `lib/utils/api/constants.dart`:
```dart
static const String baseUrl = 'https://tu-api.com/api'; // Cambia esta URL
```

### 2. Inicialización
La API se inicializa automáticamente en `main.dart`:
```dart
await FestiSpotApi.initialize(debugMode: true);
```

## Servicios Disponibles

### AuthService - Autenticación
```dart
// Login
final response = await FestiSpotApi.authService.login(
  email: 'usuario@email.com',
  password: 'contraseña',
);

// Registro
final response = await FestiSpotApi.authService.register(
  email: 'nuevo@email.com',
  password: 'contraseña',
  userType: 'asistente', // o 'productor'
  name: 'Nombre Usuario',
);

// Logout
await FestiSpotApi.authService.logout();

// Verificar sesión
bool isValid = await FestiSpotApi.authService.isSessionValid();
```

### EventService - Gestión de Eventos
```dart
// Obtener todos los eventos
final response = await FestiSpotApi.eventService.getAllEvents();

// Crear evento (para productores)
final response = await FestiSpotApi.eventService.createEvent(
  title: 'Mi Evento',
  description: 'Descripción del evento',
  category: 'Música',
  location: 'Ciudad, País',
  date: DateTime.now(),
);

// Registrarse a un evento (para asistentes)
await FestiSpotApi.eventService.attendEvent('evento_id');

// Buscar eventos
final response = await FestiSpotApi.eventService.searchEvents(
  query: 'música',
  category: 'Conciertos',
);
```

### UserService - Gestión de Usuarios
```dart
// Obtener perfil
final response = await FestiSpotApi.authService.getProfile();

// Actualizar perfil
final response = await FestiSpotApi.authService.updateProfile(
  name: 'Nuevo Nombre',
  phone: '+1234567890',
);

// Cambiar contraseña
await FestiSpotApi.userService.changePassword(
  currentPassword: 'actual',
  newPassword: 'nueva',
);
```

## Pantalla de Debug

### Acceso
1. Ve a la pantalla de login
2. Haz clic en el botón "API Debug" en la parte inferior
3. Esto te llevará a una pantalla donde puedes:
   - Verificar conectividad con la API
   - Probar login/registro
   - Ver logs en tiempo real
   - Copiar logs para debugging

### Funciones de Debug
- **Verificar conectividad**: Prueba si la API responde
- **Test de Login**: Prueba credenciales de login
- **Test de Registro**: Crea usuarios de prueba
- **Obtener eventos**: Prueba la obtención de eventos
- **Logs en tiempo real**: Ve todas las peticiones HTTP y respuestas

## Manejo de Errores

Todas las respuestas de la API usan el modelo `ApiResponse<T>`:

```dart
final response = await FestiSpotApi.authService.login(...);

if (response.success) {
  // Operación exitosa
  final user = response.data;
  print('Bienvenido ${user?.name}');
} else {
  // Error
  print('Error: ${response.message}');
  if (response.errors != null) {
    print('Detalles: ${response.errors}');
  }
}
```

## Características Incluidas

### Seguridad
- ✅ Manejo automático de tokens JWT
- ✅ Refresh tokens
- ✅ Almacenamiento seguro con SharedPreferences
- ✅ Headers de autorización automáticos

### Funcionalidades
- ✅ Login/Registro/Logout
- ✅ Gestión de perfil de usuario
- ✅ CRUD completo de eventos
- ✅ Búsqueda de eventos
- ✅ Registro a eventos (asistentes)
- ✅ Gestión de eventos propios (productores)

### Debugging
- ✅ Logs detallados en modo debug
- ✅ Pantalla de debug con pruebas
- ✅ Verificación de conectividad
- ✅ Copia de logs para análisis

### Robustez
- ✅ Manejo de timeouts
- ✅ Reconexión automática
- ✅ Manejo de errores de red
- ✅ Validación de datos

## Ejemplo de Uso Completo

```dart
import 'package:festispot/utils/api/festispot_api.dart';

class MiWidget extends StatefulWidget {
  @override
  _MiWidgetState createState() => _MiWidgetState();
}

class _MiWidgetState extends State<MiWidget> {
  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final response = await FestiSpotApi.eventService.getAllEvents();
      
      if (response.success && response.data != null) {
        setState(() {
          // Actualizar UI con los eventos
          eventos = response.data!;
        });
      } else {
        // Mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      print('Error cargando eventos: $e');
    }
  }
}
```

## Endpoints Esperados en tu Backend

La API espera que tu backend tenga los siguientes endpoints:

### Autenticación
- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/register` - Registrar usuario
- `POST /api/auth/logout` - Cerrar sesión
- `POST /api/auth/refresh` - Refrescar token

### Usuarios
- `GET /api/users/profile` - Obtener perfil
- `PUT /api/users/update` - Actualizar perfil
- `PUT /api/users/change-password` - Cambiar contraseña

### Eventos
- `GET /api/events/all` - Obtener todos los eventos
- `POST /api/events/create` - Crear evento
- `PUT /api/events/update/:id` - Actualizar evento
- `DELETE /api/events/delete/:id` - Eliminar evento
- `GET /api/events/search` - Buscar eventos
- `POST /api/events/:id/attend` - Registrarse a evento
- `DELETE /api/events/:id/attend` - Cancelar asistencia

## Notas Importantes

1. **Configuración de URL**: Recuerda cambiar la URL base en `constants.dart`
2. **Modo Debug**: Puedes desactivar el modo debug en producción
3. **Tokens**: Los tokens se guardan automáticamente y se incluyen en las peticiones
4. **Conectividad**: La app verifica conectividad antes de hacer peticiones
5. **Errores**: Todos los errores se manejan de forma consistente

¡La implementación está lista para usar! Solo necesitas configurar la URL de tu backend y empezar a hacer peticiones.
