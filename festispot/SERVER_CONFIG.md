# Configuración del Servidor API FestiSpot

## 🌐 Información del Servidor

**URL Base:** `http://10.228.2.163:8000`

### 📡 Endpoints Disponibles

| Endpoint | URL Completa | Descripción |
|----------|--------------|-------------|
| **Test API** | `http://10.228.2.163:8000/api/test` | Endpoint de prueba para verificar conectividad |
| **Eventos** | `http://10.228.2.163:8000/api/v1/events` | API de eventos (GET, POST, PUT, DELETE) |
| **Test HTML** | `http://10.228.2.163:8000/api-test.html` | Página web de prueba |

## ⚙️ Configuración Actualizada

La aplicación ya está configurada para conectarse a tu servidor:

```dart
// lib/utils/api/constants.dart
static const String baseUrl = 'http://10.228.2.163:8000/api';
```

### 🔗 Endpoints Configurados

- **Base URL**: `http://10.228.2.163:8000/api`
- **Test**: `/test`
- **Eventos**: `/v1/events`
- **Autenticación**: `/auth/*` (login, register, logout)
- **Usuarios**: `/users/*` (profile, update)

## 🧪 Cómo Probar la Conexión

### 1. Desde la App (Recomendado)
1. Abre la app FestiSpot
2. Ve a la pantalla de login
3. Haz clic en "API Debug" (botón naranja en la parte inferior)
4. En la pantalla de debug:
   - Haz clic en **"Test API"** (botón verde) para probar el endpoint `/test`
   - Haz clic en **"Conectividad"** para verificar conexión general
   - Haz clic en **"Eventos"** para probar el endpoint de eventos

### 2. Desde el Navegador
Puedes probar directamente en tu navegador:
- [http://10.228.2.163:8000/api/test](http://10.228.2.163:8000/api/test)
- [http://10.228.2.163:8000/api/v1/events](http://10.228.2.163:8000/api/v1/events)
- [http://10.228.2.163:8000/api-test.html](http://10.228.2.163:8000/api-test.html)

### 3. Desde curl/Postman
```bash
# Probar endpoint de test
curl http://10.228.2.163:8000/api/test

# Obtener eventos
curl http://10.228.2.163:8000/api/v1/events

# Con headers JSON
curl -H "Content-Type: application/json" http://10.228.2.163:8000/api/v1/events
```

## 🔧 Funcionalidades de Debug

### Botones Disponibles
- 🔄 **Conectividad**: Verifica si el servidor responde
- 🟢 **Test API**: Prueba específicamente el endpoint `/test`
- 🟣 **Consultar BD**: Realiza una consulta completa de todos los datos en la base de datos
- 🤖 **Modo Mock/Real**: Alterna entre datos simulados y servidor real
- ⚡ **Credenciales**: Auto-llena credenciales de prueba
- 🔐 **Login/Registro**: Prueba autenticación
- 🎪 **Eventos**: Obtiene lista de eventos del servidor

### Estados Visuales
- 🟢 **Conectado**: Servidor responde correctamente
- 🟡 **Mock**: Usando datos simulados (sin servidor)
- 🔴 **Sin conexión**: No hay respuesta del servidor

## 🗃️ Consulta de Base de Datos

### Funcionalidad "Consultar BD"
El botón **"Consultar BD"** realiza una consulta exhaustiva de todos los datos disponibles en tu base de datos:

#### 📊 Datos Consultados:
1. **Eventos** (`/api/v1/events`):
   - Título, descripción, ubicación
   - Categoría y precio
   - Fecha y horarios
   - Número de asistentes y capacidad
   - Estado (activo/inactivo)
   - ID único de cada evento

2. **Usuarios** (`/api/users`):
   - Total de usuarios registrados
   - Tipos de usuario (asistente/productor)
   - Información básica disponible

3. **Categorías** (`/api/events/categories`):
   - Lista de todas las categorías de eventos
   - Categorías más populares

4. **Estadísticas** (`/api/stats`):
   - Métricas generales del sistema
   - Contadores de actividad
   - Datos de uso

#### 📋 Formato de Salida:
```
🔍 Consultando datos de la base de datos...
📊 Obteniendo eventos de la BD...
✅ Eventos encontrados: 5
📋 Lista de eventos:
  1. Festival de Jazz
     📍 Ubicación: Parque Central
     🏷️ Categoría: Música
     💰 Precio: $25
     📅 Fecha: 2025-09-15
     👥 Asistentes: 150/500
     🔧 Estado: Activo
     🆔 ID: 1
  ─────────────────
  2. Exposición de Arte...
👥 Total de usuarios: 45
🏷️ Categorías disponibles: Música, Arte, Teatro, Deportes
📊 Estadísticas obtenidas: {...}
🏁 Consulta de base de datos completada
```

## 📋 Respuestas Esperadas

### Endpoint de Test (`/api/test`)
```json
{
  "success": true,
  "message": "API funcionando correctamente",
  "timestamp": "2025-09-02T10:30:00Z"
}
```

### Endpoint de Eventos (`/api/v1/events`)
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "title": "Festival de Música",
      "description": "Un gran festival de música",
      "category": "Música",
      "location": "Parque Central",
      "date": "2025-09-15T18:00:00Z",
      "price": 25.00
    }
  ]
}
```

## 🚨 Solución de Problemas

### Error de Conexión
Si ves errores tipo `ClientException: Failed to fetch`:

1. **Verifica la red**: Asegúrate de estar en la misma red que el servidor
2. **Ping al servidor**: `ping 10.228.2.163`
3. **Firewall**: Verifica que el puerto 8000 esté abierto
4. **Servidor activo**: Confirma que el servidor esté corriendo

### Modo Mock Automático
Si no puedes conectarte al servidor, la app automáticamente:
- Habilita el modo mock
- Muestra datos simulados
- Permite seguir desarrollando sin servidor

### CORS (Cross-Origin Resource Sharing)
Si ejecutas en web y hay errores CORS, el servidor debe incluir headers:
```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
```

## 📱 Próximos Pasos

1. **Probar conexión**: Usa la pantalla de debug para verificar conectividad
2. **Revisar logs**: Observa los logs en tiempo real para diagnosticar problemas
3. **Autenticación**: Una vez conectado, implementa el sistema de login real
4. **Eventos**: Integra la carga de eventos reales en las pantallas principales

¡Tu servidor está configurado y listo para usar! 🎉
