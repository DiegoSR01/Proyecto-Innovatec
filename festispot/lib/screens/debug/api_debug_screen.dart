import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/api/festispot_api.dart';

class ApiDebugScreen extends StatefulWidget {
  const ApiDebugScreen({super.key});

  @override
  State<ApiDebugScreen> createState() => _ApiDebugScreenState();
}

class _ApiDebugScreenState extends State<ApiDebugScreen> {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();
  bool _isConnected = false;
  bool _isLoggedIn = false;
  String? _currentUser;
  String _baseUrl = 'http://localhost:3000/api';
  
  // Controladores para pruebas
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _baseUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _baseUrlController.text = _baseUrl;
    _initializeApi();
    _updateStatus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  void _addLog(String message, {bool isError = false}) {
    setState(() {
      final timestamp = DateTime.now().toString().substring(11, 19);
      final prefix = isError ? '❌' : '✅';
      _logs.add('[$timestamp] $prefix $message');
    });
    
    // Scroll al final
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _initializeApi() async {
    try {
      _addLog('Inicializando FestiSpot API...');
      await FestiSpotApi.initialize(debugMode: true);
      _addLog('API inicializada exitosamente');
      await _checkConnectivity();
    } catch (e) {
      _addLog('Error inicializando API: $e', isError: true);
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      _addLog('Verificando conectividad...');
      final isConnected = await FestiSpotApi.checkConnectivity();
      setState(() {
        _isConnected = isConnected;
      });
      _addLog('Conectividad: ${isConnected ? "Conectado" : "Sin conexión"}');
    } catch (e) {
      _addLog('Error verificando conectividad: $e', isError: true);
      setState(() {
        _isConnected = false;
      });
    }
  }

  Future<void> _updateStatus() async {
    setState(() {
      _isLoggedIn = FestiSpotApi.authService.isLoggedIn;
      _currentUser = FestiSpotApi.authService.currentUser?.email;
    });
  }

  Future<void> _testLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _addLog('Por favor ingresa email y contraseña', isError: true);
      return;
    }

    try {
      _addLog('Intentando iniciar sesión...');
      final response = await FestiSpotApi.authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (response.success) {
        _addLog('Inicio de sesión exitoso');
        _addLog('Usuario: ${response.data?.email}');
        _addLog('Tipo: ${response.data?.userType}');
        await _updateStatus();
      } else {
        _addLog('Error en inicio de sesión: ${response.message}', isError: true);
      }
    } catch (e) {
      _addLog('Error durante login: $e', isError: true);
    }
  }

  Future<void> _testRegister() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _addLog('Por favor ingresa email y contraseña', isError: true);
      return;
    }

    try {
      _addLog('Intentando registrar usuario...');
      final response = await FestiSpotApi.authService.register(
        email: _emailController.text,
        password: _passwordController.text,
        userType: 'asistente',
        name: 'Usuario de Prueba',
      );

      if (response.success) {
        _addLog('Registro exitoso');
        _addLog('Usuario creado: ${response.data?.email}');
        await _updateStatus();
      } else {
        _addLog('Error en registro: ${response.message}', isError: true);
      }
    } catch (e) {
      _addLog('Error durante registro: $e', isError: true);
    }
  }

  Future<void> _testLogout() async {
    try {
      _addLog('Cerrando sesión...');
      final response = await FestiSpotApi.authService.logout();
      
      if (response.success) {
        _addLog('Sesión cerrada exitosamente');
        await _updateStatus();
      } else {
        _addLog('Error cerrando sesión: ${response.message}', isError: true);
      }
    } catch (e) {
      _addLog('Error durante logout: $e', isError: true);
    }
  }

  Future<void> _testGetEvents() async {
    try {
      _addLog('Obteniendo eventos...');
      final response = await FestiSpotApi.eventService.getAllEvents();
      
      if (response.success && response.data != null) {
        _addLog('Eventos obtenidos: ${response.data!.length}');
        for (var event in response.data!) {
          _addLog('  - ${event.title} (${event.category})');
        }
      } else {
        _addLog('Error obteniendo eventos: ${response.message}', isError: true);
      }
    } catch (e) {
      _addLog('Error durante obtención de eventos: $e', isError: true);
    }
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  void _copyLogs() {
    final logsText = _logs.join('\n');
    Clipboard.setData(ClipboardData(text: logsText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logs copiados al portapapeles')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Debug'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyLogs,
            tooltip: 'Copiar logs',
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearLogs,
            tooltip: 'Limpiar logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Panel de estado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado de la API',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _isConnected ? Icons.wifi : Icons.wifi_off,
                      color: _isConnected ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text('Conectividad: ${_isConnected ? "Conectado" : "Sin conexión"}'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _isLoggedIn ? Icons.person : Icons.person_off,
                      color: _isLoggedIn ? Colors.green : Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text('Usuario: ${_currentUser ?? "No autenticado"}'),
                  ],
                ),
              ],
            ),
          ),
          
          // Panel de controles
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // URL Base
                TextFormField(
                  controller: _baseUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL Base de la API',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Credentials
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Botones de prueba
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _checkConnectivity,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Conectividad'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _testLogin,
                      icon: const Icon(Icons.login),
                      label: const Text('Login'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _testRegister,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Registro'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _testLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _testGetEvents,
                      icon: const Icon(Icons.event),
                      label: const Text('Eventos'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Panel de logs
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logs (${_logs.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: _logs.isEmpty
                          ? const Center(
                              child: Text(
                                'No hay logs aún...',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: _logs.length,
                              itemBuilder: (context, index) {
                                final log = _logs[index];
                                final isError = log.contains('❌');
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1),
                                  child: Text(
                                    log,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                      color: isError ? Colors.red.shade300 : Colors.green.shade300,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
