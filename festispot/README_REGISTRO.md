# 📱 FestiSpot - Sistema de Registro Actualizado

## 🎯 Resumen de Implementación

He actualizado completamente el sistema de registro de FestiSpot para que sea compatible con la estructura de la base de datos MySQL. Aquí están todos los cambios realizados:

## 🔧 Cambios Implementados

### 1. **Modelo de Usuario Actualizado** (`lib/models/usuario.dart`)
- ✅ Separación de `nombre` y `apellido`
- ✅ Agregado `telefono` (opcional)
- ✅ Agregado `fecha_nacimiento` (opcional)
- ✅ Agregado `genero` (opcional)
- ✅ Agregado `rol_id` (1=asistente, 2=organizador, 3=admin)
- ✅ Agregado `estado` (activo, inactivo, suspendido)
- ✅ Agregado `email_verificado` y `token_verificacion`
- ✅ Agregado campos de timestamps (`created_at`, `updated_at`)

### 2. **AuthService Actualizado** (`lib/services/auth_service.dart`)
- ✅ Método `register()` actualizado con nuevos campos
- ✅ Soporte para `apellido`, `telefono`, `fechaNacimiento`, `genero`, `rolId`
- ✅ Compatibilidad con el endpoint PHP de registro

### 3. **Pantalla de Registro Actualizada** (`lib/screens/registro.dart`)
- ✅ Campo de apellido (requerido)
- ✅ Campo de teléfono (opcional)
- ✅ Selector de género (opcional)
- ✅ Selector de fecha de nacimiento (opcional)
- ✅ Selector de tipo de cuenta (Asistente/Organizador)
- ✅ Validación completa de campos
- ✅ Integración real con la API

### 4. **API PHP Validada** (`festispot_api/api/auth.php`)
- ✅ El endpoint de registro ya soporta todos los campos necesarios
- ✅ Validación de email único
- ✅ Encriptación de contraseñas con `password_hash()`
- ✅ Generación de token de verificación
- ✅ Respuestas JSON correctas

## 🧪 Cómo Probar el Sistema

### Opción 1: Servidor Web Local
1. **Configurar XAMPP/WAMP/MAMP:**
   ```bash
   # Asegúrate de que MySQL y Apache estén corriendo
   # Importa el archivo festispot_api/festispot.sql a tu base de datos
   ```

2. **Probar la API:**
   ```bash
   # Coloca el proyecto en htdocs (XAMPP) o www (WAMP)
   # Navega a: http://localhost/festispot/test_api.php
   ```

3. **Ejecutar la app Flutter:**
   ```bash
   cd festispot
   flutter pub get
   flutter run
   ```

### Opción 2: Probar sin Servidor (Modo Local)
La app tiene un sistema de fallback que permite probar sin servidor:

```dart
// Credenciales de prueba predefinidas en LocalCredentials:
Email: asistente@festispot.com
Password: password123

Email: productor@festispot.com  
Password: password123
```

## 📊 Estructura de Datos

### Tabla `users` en MySQL:
```sql
CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('masculino','femenino','otro','prefiero_no_decir') DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `rol_id` bigint UNSIGNED NOT NULL DEFAULT 1,
  `estado` enum('activo','inactivo','suspendido') DEFAULT 'activo',
  `fecha_registro` timestamp NULL DEFAULT NULL,
  `ultimo_acceso` timestamp NULL DEFAULT NULL,
  `token_verificacion` varchar(255) DEFAULT NULL,
  `email_verificado` tinyint(1) NOT NULL DEFAULT 0,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_rol_id_foreign` (`rol_id`)
);
```

### Modelo Dart:
```dart
class Usuario {
  final int? id;
  final String nombre;
  final String apellido;
  final String email;
  final String? telefono;
  final String? fechaNacimiento;
  final String? genero;
  final int rolId; // 1=asistente, 2=organizador, 3=admin
  final String estado;
  final bool emailVerificado;
  // ... más campos
}
```

## 🌐 Endpoints de la API

### Registro de Usuario
```http
POST /festispot_api/api/auth.php
Content-Type: application/json

{
  "action": "register",
  "nombre": "Juan",
  "apellido": "Pérez",
  "email": "juan@example.com",
  "password": "password123",
  "telefono": "+52 81 1234 5678",
  "fecha_nacimiento": "1995-05-15",
  "genero": "masculino",
  "rol_id": 1
}
```

### Login de Usuario
```http
POST /festispot_api/api/auth.php
Content-Type: application/json

{
  "action": "login",
  "email": "juan@example.com",
  "password": "password123"
}
```

## ✅ Validaciones Implementadas

### Frontend (Flutter):
- ✅ Validación de email con regex
- ✅ Contraseña mínimo 6 caracteres
- ✅ Confirmación de contraseña
- ✅ Campos requeridos vs opcionales
- ✅ Validación de fecha de nacimiento (mínimo 13 años)
- ✅ Aceptación de términos y condiciones

### Backend (PHP):
- ✅ Validación de campos requeridos
- ✅ Verificación de email único
- ✅ Encriptación segura de contraseñas
- ✅ Sanitización de datos
- ✅ Respuestas de error detalladas

## 🚀 Próximos Pasos

1. **Configurar tu servidor local** (XAMPP/WAMP)
2. **Importar la base de datos** (`festispot_api/festispot.sql`)
3. **Ejecutar el script de prueba** (`test_api.php`)
4. **Probar el registro desde la app Flutter**
5. **Verificar que los datos se guarden en MySQL**

## 🔧 Configuración de URLs

En `lib/config/api_config.dart`, asegúrate de que las URLs apunten a tu servidor:

```dart
class ApiConfig {
  static const String localBaseUrl = 'http://localhost/festispot';
  // Cambiar por tu configuración local si es diferente
}
```

## 📞 ¿Necesitas Ayuda?

Si encuentras algún problema:

1. **Verifica la conexión a la base de datos** ejecutando `test_api.php`
2. **Revisa los logs de PHP** para errores específicos
3. **Asegúrate de que todas las tablas existan** en MySQL
4. **Verifica que las URLs sean correctas** en `api_config.dart`

¡El sistema está completamente implementado y listo para usar! 🎉