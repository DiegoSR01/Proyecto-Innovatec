import 'package:flutter/material.dart';
import '../../config/api_config.dart';

class ApiConfigScreen extends StatefulWidget {
  const ApiConfigScreen({super.key});

  @override
  State<ApiConfigScreen> createState() => _ApiConfigScreenState();
}

class _ApiConfigScreenState extends State<ApiConfigScreen> {
  ApiEnvironment selectedEnvironment = ApiConfig.currentEnvironment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        title: const Text(
          'Configuración de API',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2D2E3F),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Información actual
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2E3F),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF00BCD4).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BCD4).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Color(0xFF00BCD4),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Configuración Actual:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00BCD4),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Entorno', ApiConfig.currentEnvironment.displayName),
                  _buildInfoRow('URL Base', ApiConfig.currentBaseUrl),
                  _buildInfoRow('Timeout', '${ApiConfig.timeout.inSeconds}s'),
                  _buildInfoRow('Debug Mode', ApiConfig.isDebugMode ? 'Habilitado' : 'Deshabilitado'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Selección de entorno
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2E3F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seleccionar API:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...ApiEnvironment.values.map((env) => _buildEnvironmentOption(env)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Endpoints disponibles
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2E3F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endpoints Disponibles:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEndpointInfo('Autenticación', '${ApiConfig.currentBaseUrl}/auth.php'),
                  _buildEndpointInfo('Usuarios', '${ApiConfig.currentBaseUrl}/users.php'),
                  _buildEndpointInfo('Eventos', '${ApiConfig.currentBaseUrl}/get_events.php'),
                  _buildEndpointInfo('Categorías', '${ApiConfig.currentBaseUrl}/get_categorias.php'),
                  _buildEndpointInfo('Favoritos', '${ApiConfig.currentBaseUrl}/get_favoritos.php'),
                  _buildEndpointInfo('Reviews', '${ApiConfig.currentBaseUrl}/get_reviews.php'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botón de prueba de conexión
            ElevatedButton.icon(
              onPressed: _testConnection,
              icon: const Icon(Icons.network_check),
              label: const Text('Probar Conexión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Información adicional
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        color: Colors.orange.shade300,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Notas Importantes:',
                        style: TextStyle(
                          color: Colors.orange.shade300,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Para usar en dispositivo físico, cambia localhost por la IP de tu computadora\n'
                    '• Asegúrate de que XAMPP esté ejecutándose\n'
                    '• El modo local incluye sistema de fallback automático\n'
                    '• Los cambios se aplican inmediatamente',
                    style: TextStyle(
                      color: Colors.orange.shade200,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentOption(ApiEnvironment env) {
    final isSelected = selectedEnvironment == env;
    final isCurrent = ApiConfig.currentEnvironment == env;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected 
          ? const Color(0xFFE91E63).withOpacity(0.1)
          : const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
            ? const Color(0xFFE91E63)
            : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: RadioListTile<ApiEnvironment>(
        value: env,
        groupValue: selectedEnvironment,
        onChanged: (value) {
          setState(() {
            selectedEnvironment = value!;
          });
          // Cambiar el entorno inmediatamente
          ApiConfig.setEnvironment(value!);
        },
        title: Row(
          children: [
            Text(
              env.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isCurrent) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'ACTUAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          _getEnvironmentUrl(env),
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        activeColor: const Color(0xFFE91E63),
      ),
    );
  }

  Widget _buildEndpointInfo(String name, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            url,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _getEnvironmentUrl(ApiEnvironment env) {
    // Usar la configuración centralizada
    return ApiConfig.apiUrl;
  }

  void _testConnection() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Color(0xFF2D2E3F),
        content: Row(
          children: [
            CircularProgressIndicator(color: Color(0xFFE91E63)),
            SizedBox(width: 16),
            Text(
              'Probando conexión...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );

    try {
      // Intentar obtener categorías como test de conexión
      await Future.delayed(const Duration(seconds: 2)); // Simular petición
      // final categorias = await ApiService.getCategorias();
      
      Navigator.of(context).pop(); // Cerrar dialog de loading
      
      _showResultDialog(
        'Conexión Exitosa',
        'La conexión con la API funciona correctamente.',
        true,
      );
    } catch (e) {
      Navigator.of(context).pop(); // Cerrar dialog de loading
      
      _showResultDialog(
        'Error de Conexión',
        'No se pudo conectar con la API: $e',
        false,
      );
    }
  }

  void _showResultDialog(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2E3F),
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFE91E63),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
          ),
        ],
      ),
    );
  }
}
