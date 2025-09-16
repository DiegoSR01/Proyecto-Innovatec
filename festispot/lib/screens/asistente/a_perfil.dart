import 'package:festispot/screens/asistente/a_suscripcion.dart';
import 'package:flutter/material.dart';
import 'package:festispot/screens/login.dart';
import 'package:festispot/services/user_service.dart';
import 'package:festispot/services/auth_service.dart';
import 'package:festispot/models/usuario.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  Usuario? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _loadUserData();
    _animationController.forward();
  }

  /// Carga los datos del usuario actual
  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Cargar información del usuario
      final user = await UserService.getCurrentUserProfile();

      setState(() {
        _currentUser = user;
        _isLoading = false;
      });

      if (user == null) {
        _showCustomSnackBar('Error: No se pudo cargar la información del usuario', false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showCustomSnackBar('Error al cargar datos del perfil: $e', false);
    }
  }

  /// Muestra el diálogo para cambiar la foto de perfil
  void _mostrarDialogoCambiarFoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D2E3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.camera_alt, color: Color(0xFF4CAF50)),
              SizedBox(width: 12),
              Text(
                'Cambiar Foto de Perfil',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona cómo quieres agregar tu foto:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _seleccionarImagen(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Color(0xFF4CAF50),
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cámara',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _seleccionarImagen(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            color: Color(0xFF2196F3),
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Galería',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Selecciona una imagen de la cámara o galería
  Future<void> _seleccionarImagen(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        _showCustomSnackBar('Subiendo imagen...', true);
        
        // Subir la imagen usando UserService
        final result = await UserService.updateAvatar(File(image.path));
        
        result.onSuccess((user, message) {
          setState(() {
            _currentUser = user;
          });
          _showCustomSnackBar(message, true);
        });

        result.onError((message) {
          _showCustomSnackBar(message, false);
        });
      }
    } catch (e) {
      _showCustomSnackBar('Error al seleccionar imagen: $e', false);
    }
  }
  void _mostrarDialogoEditarPerfil() {
    if (_currentUser == null) return;

    final nombreController = TextEditingController(text: _currentUser!.nombre);
    final apellidoController = TextEditingController(text: _currentUser!.apellido);
    final telefonoController = TextEditingController(text: _currentUser!.telefono ?? '');
    final fechaNacimientoController = TextEditingController(text: _currentUser!.fechaNacimiento ?? '');
    
    // Asegurar que el género seleccionado sea uno de los valores válidos
    String? generoSeleccionado = _currentUser!.genero;
    if (generoSeleccionado != null && !['M', 'F', 'O'].contains(generoSeleccionado)) {
      generoSeleccionado = null; // Si el género no es válido, no seleccionar nada
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2D2E3F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(Icons.edit, color: Color(0xFF00BCD4)),
                  SizedBox(width: 12),
                  Text(
                    'Editar Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextFieldDialog('Nombre', nombreController, Icons.person),
                    const SizedBox(height: 16),
                    _buildTextFieldDialog('Apellido', apellidoController, Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildTextFieldDialog('Teléfono', telefonoController, Icons.phone, isOptional: true),
                    const SizedBox(height: 16),
                    _buildTextFieldDialog('Fecha de Nacimiento (YYYY-MM-DD)', fechaNacimientoController, Icons.cake, isOptional: true),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1B2E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: generoSeleccionado,
                          isExpanded: true,
                          hint: const Text('Seleccionar género', style: TextStyle(color: Colors.white70)),
                          dropdownColor: const Color(0xFF2D2E3F),
                          style: const TextStyle(color: Colors.white),
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'M',
                              child: Text('Masculino', style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem<String>(
                              value: 'F',
                              child: Text('Femenino', style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem<String>(
                              value: 'O',
                              child: Text('Otro', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            setModalState(() {
                              generoSeleccionado = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BCD4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      
                      final result = await UserService.updateProfile(
                        nombre: nombreController.text.trim(),
                        apellido: apellidoController.text.trim(),
                        telefono: telefonoController.text.trim().isEmpty ? null : telefonoController.text.trim(),
                        fechaNacimiento: fechaNacimientoController.text.trim().isEmpty ? null : fechaNacimientoController.text.trim(),
                        genero: generoSeleccionado,
                      );

                      result.onSuccess((user, message) {
                        setState(() {
                          _currentUser = user;
                        });
                        _showCustomSnackBar(message, true);
                      });

                      result.onError((message) {
                        _showCustomSnackBar(message, false);
                      });
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }

  /// Muestra el diálogo para cambiar email
  void _mostrarDialogoCambiarEmail() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D2E3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.email, color: Color(0xFFFF9800)),
              SizedBox(width: 12),
              Text(
                'Cambiar Email',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email actual: ${_currentUser?.email ?? 'No disponible'}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              _buildTextFieldDialog('Nuevo Email', emailController, Icons.email),
              const SizedBox(height: 8),
              const Text(
                'Se enviará un enlace de verificación al nuevo email.',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  final newEmail = emailController.text.trim();
                  if (newEmail.isEmpty || !newEmail.contains('@')) {
                    _showCustomSnackBar('Por favor ingresa un email válido', false);
                    return;
                  }

                  Navigator.pop(context);
                  
                  final result = await UserService.changeEmail(newEmail);

                  result.onSuccess((user, message) {
                    setState(() {
                      _currentUser = user;
                    });
                    _showCustomSnackBar(message, true);
                  });

                  result.onError((message) {
                    _showCustomSnackBar(message, false);
                  });
                },
                child: const Text(
                  'Cambiar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Muestra el diálogo para cambiar contraseña
  void _mostrarDialogoCambiarPassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D2E3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.lock, color: Color(0xFF9C27B0)),
              SizedBox(width: 12),
              Text(
                'Cambiar Contraseña',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextFieldDialog('Contraseña Actual', currentPasswordController, Icons.lock, isPassword: true),
              const SizedBox(height: 16),
              _buildTextFieldDialog('Nueva Contraseña', newPasswordController, Icons.lock_outline, isPassword: true),
              const SizedBox(height: 16),
              _buildTextFieldDialog('Confirmar Nueva Contraseña', confirmPasswordController, Icons.lock_outline, isPassword: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  final currentPassword = currentPasswordController.text;
                  final newPassword = newPasswordController.text;
                  final confirmPassword = confirmPasswordController.text;

                  if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
                    _showCustomSnackBar('Todos los campos son obligatorios', false);
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    _showCustomSnackBar('Las contraseñas no coinciden', false);
                    return;
                  }

                  if (newPassword.length < 6) {
                    _showCustomSnackBar('La nueva contraseña debe tener al menos 6 caracteres', false);
                    return;
                  }

                  Navigator.pop(context);
                  
                  final result = await UserService.changePassword(currentPassword, newPassword);

                  result.onSuccess((user, message) {
                    _showCustomSnackBar(message, true);
                  });

                  result.onError((message) {
                    _showCustomSnackBar(message, false);
                  });
                },
                child: const Text(
                  'Cambiar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Widget para construir text fields en diálogos
  Widget _buildTextFieldDialog(String label, TextEditingController controller, IconData icon, {bool isPassword = false, bool isOptional = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: isOptional ? '$label (opcional)' : label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: const Color(0xFF1A1B2E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE91E63)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showCustomSnackBar(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.info,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess
            ? const Color(0xFF4CAF50)
            : const Color(0xFFE91E63),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isSuccess ? 2 : 3),
      ),
    );
  }

  void _mostrarDialogoCerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D2E3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            '¿Estás seguro que deseas cerrar sesión? Tendrás que volver a iniciar sesión para acceder a tu cuenta.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Cerrar el diálogo
                  
                  // Cerrar sesión usando AuthService
                  await AuthService.logout();
                  
                  // Navegar a la pantalla de login
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B2E),
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2E3F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          "Mi Perfil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2E3F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _isLoading ? null : _loadUserData,
              tooltip: 'Actualizar información',
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Perfil del usuario
                _buildUserProfileSection(),
                const SizedBox(height: 32),

                // Información de la cuenta
                _buildAccountSection(),
                const SizedBox(height: 24),

                // Configuraciones de cuenta
                _buildSecuritySection(),
                const SizedBox(height: 24),

                // Acción de cerrar sesión
                _buildLogoutSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE91E63).withOpacity(0.1),
              const Color(0xFF9C27B0).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE91E63).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
              ),
              SizedBox(height: 16),
              Text(
                'Cargando perfil...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentUser == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.withOpacity(0.1),
              Colors.orange.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar perfil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No se pudo cargar la información del usuario',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadUserData,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE91E63).withOpacity(0.1),
            const Color(0xFF9C27B0).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE91E63).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: _currentUser!.avatarUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          _currentUser!.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, color: Colors.white, size: 60);
                          },
                        ),
                      )
                    : const Icon(Icons.person, color: Colors.white, size: 60),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _mostrarDialogoCambiarFoto,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _currentUser!.nombreCompleto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _currentUser!.email,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getRoleColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getRoleColor(), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getRoleIcon(), color: _getRoleColor(), size: 16),
                const SizedBox(width: 4),
                Text(
                  _currentUser!.nombreRol.toUpperCase(),
                  style: TextStyle(
                    color: _getRoleColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (_currentUser!.telefono != null && _currentUser!.telefono!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.white60, size: 16),
                const SizedBox(width: 4),
                Text(
                  _currentUser!.telefono!,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ],
          if (_currentUser!.fechaNacimiento != null && _currentUser!.fechaNacimiento!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cake, color: Colors.white60, size: 16),
                const SizedBox(width: 4),
                Text(
                  _formatFechaNacimiento(_currentUser!.fechaNacimiento!),
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Obtiene el color del rol del usuario
  Color _getRoleColor() {
    switch (_currentUser?.rolId) {
      case 1: // Asistente
        return const Color(0xFFE91E63);
      case 2: // Organizador
        return const Color(0xFF4CAF50);
      case 3: // Admin
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFFE91E63);
    }
  }

  /// Obtiene el ícono del rol del usuario
  IconData _getRoleIcon() {
    switch (_currentUser?.rolId) {
      case 1: // Asistente
        return Icons.person_outline;
      case 2: // Organizador
        return Icons.business_outlined;
      case 3: // Admin
        return Icons.admin_panel_settings_outlined;
      default:
        return Icons.person_outline;
    }
  }

  /// Formatea la fecha de nacimiento para mostrar
  String _formatFechaNacimiento(String fecha) {
    try {
      final DateTime fechaNac = DateTime.parse(fecha);
      final now = DateTime.now();
      final edad = now.year - fechaNac.year;
      
      if (now.month < fechaNac.month || 
          (now.month == fechaNac.month && now.day < fechaNac.day)) {
        return '${edad - 1} años';
      }
      return '$edad años';
    } catch (e) {
      return fecha; // Devolver fecha original si no se puede parsear
    }
  }

  Widget _buildAccountSection() {
    return _buildSection('Información Personal', [
      _buildSettingTile(
        Icons.attach_money,
        'Suscripción',
        'Gestionar plan de suscripción',
        const Color.fromARGB(255, 255, 64, 129),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SuscripcionScreenA()),
        ),
      ),
      _buildSettingTile(
        Icons.edit_outlined,
        'Editar Perfil',
        'Modificar nombre y información básica',
        const Color(0xFF00BCD4),
        _mostrarDialogoEditarPerfil,
      ),
      _buildSettingTile(
        Icons.email_outlined,
        'Cambiar Correo',
        'Actualizar dirección de correo electrónico',
        const Color(0xFFFF9800),
        _mostrarDialogoCambiarEmail,
      ),
      _buildSettingTile(
        Icons.phone_outlined,
        'Teléfono',
        _currentUser?.telefono != null && _currentUser!.telefono!.isNotEmpty
            ? 'Teléfono: ${_currentUser!.telefono}'
            : 'Agregar número de teléfono',
        const Color(0xFF4CAF50),
        _mostrarDialogoEditarPerfil,
      ),
    ]);
  }

  Widget _buildSecuritySection() {
    return _buildSection('Seguridad y Privacidad', [
      _buildSettingTile(
        Icons.lock_outline,
        'Cambiar Contraseña',
        'Modificar tu contraseña de acceso',
        const Color(0xFF9C27B0),
        _mostrarDialogoCambiarPassword,
      ),
      _buildSettingTile(
        Icons.security_outlined,
        'Autenticación de Dos Factores',
        'Agregar capa extra de seguridad',
        const Color(0xFF00BCD4),
        () => _showCustomSnackBar('Función próximamente disponible', false),
      ),
      _buildSettingTile(
        Icons.privacy_tip_outlined,
        'Privacidad de Datos',
        'Controla qué información compartes',
        const Color(0xFF4CAF50),
        () => _showCustomSnackBar(
          'Configuración de privacidad próximamente',
          false,
        ),
      ),
    ]);
  }

  Widget _buildLogoutSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.red, Color(0xFFD32F2F)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _mostrarDialogoCerrarSesion,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2E3F),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFE91E63),
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

}
