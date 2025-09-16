import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../config/api_config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  int _selectedUserType = 1; // 1=asistente, 2=organizador
  String? _selectedGender;
  DateTime? _birthDate;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    // Envolver todo en try-catch para prevenir cierre de app
    try {
      if (_formKey.currentState!.validate()) {
        if (!_acceptTerms || !_acceptPrivacy) {
          _showCustomSnackBar(
            'Debes aceptar los términos y condiciones y la política de privacidad',
            false,
          );
          return;
        }

        setState(() {
        _isLoading = true;
      });

      try {
        // Debug: mostrar información de configuración
        if (ApiConfig.isDebugMode) {
          print('🔧 Configuración actual:');
          print('   URL: ${ApiConfig.authUrl}');
          print('   Debug Mode: ${ApiConfig.isDebugMode}');
        }

        // Validar email antes de enviar
        final email = _emailController.text.trim().toLowerCase();
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
          _showCustomSnackBar('El formato del email no es válido', false);
          return;
        }

        // Llamar al servicio de autenticación
        final result = await AuthService.register(
          nombre: _firstNameController.text.trim(),
          apellido: _lastNameController.text.trim(),
          email: email,
          password: _passwordController.text,
          telefono: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
          fechaNacimiento: _birthDate?.toIso8601String().split('T')[0],
          genero: _selectedGender,
          rolId: _selectedUserType,
        );

        if (result.isSuccess) {
          _showCustomSnackBar(
            result.message,
            true,
          );

          // Regresar al login después de un momento
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        } else {
          // Mostrar error específico del servidor
          String errorMessage = result.message;
          
          // Personalizar algunos mensajes de error comunes
          if (errorMessage.contains('email ya está registrado') || 
              errorMessage.contains('already exists')) {
            errorMessage = 'Este email ya está registrado. Intenta iniciar sesión o usa otro email.';
          } else if (errorMessage.contains('JSON') || errorMessage.contains('decodificar')) {
            errorMessage = 'Error de comunicación con el servidor. Verifica tu conexión e inténtalo de nuevo.';
          } else if (errorMessage.contains('conexión') || errorMessage.contains('internet')) {
            errorMessage = 'Sin conexión a internet. Verifica tu red e inténtalo de nuevo.';
          } else if (errorMessage.contains('conexión a la base de datos') || 
                     errorMessage.contains('MySQL') ||
                     errorMessage.contains('database connection')) {
            errorMessage = '⚠️ Servidor en mantenimiento. El servicio de base de datos no está disponible temporalmente. Inténtalo más tarde.';
          } else if (errorMessage.contains('HTML en lugar de JSON') ||
                     errorMessage.contains('no válida')) {
            errorMessage = '🔧 Error del servidor. El administrador ha sido notificado. Inténtalo más tarde.';
          }
          
          _showCustomSnackBar(errorMessage, false);
        }
      } catch (e) {
        // Error no controlado
        String errorMessage = 'Error inesperado: ${e.toString()}';
        
        if (e.toString().contains('SocketException')) {
          errorMessage = 'Sin conexión a internet. Verifica tu red e inténtalo de nuevo.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage = 'La conexión tardó demasiado. Inténtalo de nuevo.';
        } else if (e.toString().contains('JSON')) {
          errorMessage = 'Error de comunicación con el servidor. Inténtalo de nuevo.';
        } else if (e.toString().contains('conexión a la base de datos') || 
                   e.toString().contains('MySQL') ||
                   e.toString().contains('database')) {
          errorMessage = '⚠️ Servidor en mantenimiento. Inténtalo más tarde.';
        } else if (e.toString().contains('ApiException')) {
          // Extraer el mensaje limpio de ApiException
          String message = e.toString().replaceAll('ApiException: ', '');
          errorMessage = message;
        }
        
        _showCustomSnackBar(errorMessage, false);
        
        // Debug: mostrar error completo en consola
        if (ApiConfig.isDebugMode) {
          print('❌ Error completo: $e');
          print('❌ Stack trace: ${StackTrace.current}');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
    } catch (e) {
      // Capturar cualquier error no manejado para prevenir cierre de app
      if (ApiConfig.isDebugMode) {
        print('❌ Error crítico no manejado en registro: $e');
        print('❌ Stack trace: ${StackTrace.current}');
      }
      
      _showCustomSnackBar(
        'Error inesperado. Por favor, inténtalo de nuevo.',
        false,
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showCustomSnackBar(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2E3F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Crear Cuenta',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Logo igual al del login - sin minitarjeta de fondo
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    // Logo con resplandor rosa igual al login
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE91E63).withOpacity(0.4),
                            blurRadius: 40,
                            offset: const Offset(0, 0),
                          ),
                          BoxShadow(
                            color: const Color(0xFFE91E63).withOpacity(0.2),
                            blurRadius: 80,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/logo-festispot.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Títulos
                    const Text(
                      '¡Únete a FestiSpot!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Descubre y organiza eventos increíbles',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Formulario de registro
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2E3F),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Selector de tipo de usuario
                      const Text(
                        'Tipo de cuenta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildUserTypeCard(
                              1,
                              'Asistente',
                              Icons.person_outline,
                              'Descubre eventos',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildUserTypeCard(
                              2,
                              'Organizador',
                              Icons.business_outlined,
                              'Organiza eventos',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Campo de nombre
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'Nombre',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          if (value.length < 2) {
                            return 'El nombre debe tener al menos 2 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Campo de apellidos
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Apellido(s)',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tus apellidos';
                          }
                          if (value.length < 2) {
                            return 'El apellido debe tener al menos 2 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Campo de teléfono (opcional)
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Teléfono (opcional)',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),

                      // Selector de género (opcional)
                      _buildGenderSelector(),
                      const SizedBox(height: 20),

                      // Selector de fecha de nacimiento (opcional)
                      _buildDateSelector(),
                      const SizedBox(height: 20),

                      // Campo de email
                      _buildTextField(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Ingresa un correo válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Campo de contraseña
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onTogglePassword: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Campo de confirmar contraseña
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirmar contraseña',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isPasswordVisible: _isConfirmPasswordVisible,
                        onTogglePassword: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor confirma tu contraseña';
                          }
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Checkbox términos y condiciones y política de privacidad
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFFE91E63),
                              checkColor: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Acepto los términos y condiciones',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: _acceptPrivacy,
                              onChanged: (value) {
                                setState(() {
                                  _acceptPrivacy = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFFE91E63),
                              checkColor: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Acepto la política de privacidad',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Botón de registro
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Crear Cuenta',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Enlace para volver al login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes cuenta? ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Inicia sesión',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFFE91E63),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildUserTypeCard(
    int value,
    String title,
    IconData icon,
    String subtitle,
  ) {
    bool isSelected = _selectedUserType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFFE91E63).withOpacity(0.1)
            : const Color(0xFF1A1B2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
              ? const Color(0xFFE91E63)
              : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected 
                  ? const Color(0xFFE91E63)
                  : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected 
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected 
                  ? const Color(0xFFE91E63)
                  : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedGender,
        decoration: InputDecoration(
          labelText: 'Género (opcional)',
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.person_outline,
            color: Color(0xFFE91E63),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        dropdownColor: const Color(0xFF2D2E3F),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        items: const [
          DropdownMenuItem(value: 'masculino', child: Text('Masculino')),
          DropdownMenuItem(value: 'femenino', child: Text('Femenino')),
          DropdownMenuItem(value: 'otro', child: Text('Otro')),
          DropdownMenuItem(value: 'prefiero_no_decir', child: Text('Prefiero no decir')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.calendar_today_outlined,
          color: Color(0xFFE91E63),
        ),
        title: Text(
          _birthDate == null 
            ? 'Fecha de nacimiento (opcional)'
            : 'Nacimiento: ${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
          style: TextStyle(
            color: _birthDate == null 
              ? Colors.white.withOpacity(0.7)
              : Colors.white,
            fontSize: 16,
          ),
        ),
        trailing: _birthDate != null 
          ? IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white.withOpacity(0.7),
              ),
              onPressed: () {
                setState(() {
                  _birthDate = null;
                });
              },
            )
          : null,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _birthDate ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)), // Mínimo 13 años
            builder: (context, child) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFFE91E63),
                    onPrimary: Colors.white,
                    surface: Color(0xFF2D2E3F),
                    onSurface: Colors.white,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null && picked != _birthDate) {
            setState(() {
              _birthDate = picked;
            });
          }
        },
      ),
    );
  }
}