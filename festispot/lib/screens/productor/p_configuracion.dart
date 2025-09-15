import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool _notificacionesActivas = true;
  bool _modoOscuro = true;
  bool _notificacionesEventos = true;
  bool _notificacionesOfertas = false;
  bool _ubicacionActiva = true;
  String _idiomaSeleccionado =
      'Español'; // Agregado para manejar el idioma seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B2E),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "⚙️ Configuración",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Sección de Preferencias
            _buildSectionHeader('Preferencias'),
            _buildSettingTile(
              icon: Icons.notifications,
              title: 'Notificaciones',
              subtitle: 'Recibe alertas de nuevos eventos',
              isSwitch: true,
              switchValue: _notificacionesActivas,
              onSwitchChanged: (value) {
                setState(() {
                  _notificacionesActivas = value;
                });
              },
            ),
            _buildSettingTile(
              icon: Icons.dark_mode,
              title: 'Modo Oscuro',
              subtitle: 'Tema oscuro para mejor experiencia',
              isSwitch: true,
              switchValue: _modoOscuro,
              onSwitchChanged: (value) {
                setState(() {
                  _modoOscuro = value;
                });
              },
            ),
            _buildSettingTile(
              icon: Icons.location_on,
              title: 'Ubicación',
              subtitle: 'Permite acceso a tu ubicación',
              isSwitch: true,
              switchValue: _ubicacionActiva,
              onSwitchChanged: (value) {
                setState(() {
                  _ubicacionActiva = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // Sección de Notificaciones Detalladas
            _buildSectionHeader('Notificaciones Detalladas'),
            _buildSettingTile(
              icon: Icons.event,
              title: 'Eventos Nuevos',
              subtitle: 'Notificaciones de eventos recién añadidos',
              isSwitch: true,
              switchValue: _notificacionesEventos,
              onSwitchChanged: (value) {
                setState(() {
                  _notificacionesEventos = value;
                });
              },
            ),
            _buildSettingTile(
              icon: Icons.local_offer,
              title: 'Ofertas y Promociones',
              subtitle: 'Recibe notificaciones de descuentos',
              isSwitch: true,
              switchValue: _notificacionesOfertas,
              onSwitchChanged: (value) {
                setState(() {
                  _notificacionesOfertas = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // Sección de Cuenta
            _buildSectionHeader('Cuenta'),
            _buildSettingTile(
              icon: Icons.security,
              title: 'Privacidad y Seguridad',
              subtitle: 'Configurar privacidad de cuenta',
              onTap: () {
                // Navegar a privacidad
              },
            ),
            _buildSettingTile(
              icon: Icons.language,
              title: 'Idioma',
              subtitle: 'Español',
              onTap: () {
                _showLanguageDialog();
              },
            ),

            const SizedBox(height: 24),

            // Sección de Soporte
            _buildSectionHeader('Soporte'),
            _buildSettingTile(
              icon: Icons.help,
              title: 'Centro de Ayuda',
              subtitle: 'Preguntas frecuentes y soporte',
              onTap: () {
                // Navegar a ayuda
              },
            ),
            _buildSettingTile(
              icon: Icons.bug_report,
              title: 'Reportar Problema',
              subtitle: 'Informar errores o sugerencias',
              onTap: () {
                // Navegar a reportar problema
              },
            ),
            _buildSettingTile(
              icon: Icons.star_rate,
              title: 'Calificar App',
              subtitle: 'Ayúdanos a mejorar',
              onTap: () {
                // Abrir store para calificar
              },
            ),

            const SizedBox(height: 24),

            // Sección de Información
            _buildSectionHeader('Información'),
            _buildSettingTile(
              icon: Icons.info,
              title: 'Acerca de FestiSpot',
              subtitle: 'Versión 1.0.0',
              onTap: () {
                _showAboutDialog();
              },
            ),
            _buildSettingTile(
              icon: Icons.description,
              title: 'Términos y Condiciones',
              subtitle: 'Política de privacidad',
              onTap: () {
                // Mostrar términos
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isSwitch = false,
    bool switchValue = false,
    Function(bool)? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2E3F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isSwitch ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                      255,
                      0,
                      229,
                      255,
                    ).withOpacity(0.2), // Changed opacity for container
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color.fromARGB(
                      255,
                      0,
                      229,
                      255,
                    ), // Kept original color for icon
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSwitch)
                  Switch(
                    value: switchValue,
                    onChanged: onSwitchChanged,
                    activeTrackColor: Color.fromARGB(255, 0, 229, 255),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.5),
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2E3F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Seleccionar Idioma',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Español'),
            _buildLanguageOption('English'),
            _buildLanguageOption('Français'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Aquí podrías agregar lógica para aplicar el idioma
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 229, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Aplicar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language, style: const TextStyle(color: Colors.white)),
      leading: Radio<String>(
        value: language,
        groupValue: _idiomaSeleccionado,
        onChanged: (value) {
          setState(() {
            _idiomaSeleccionado = value!;
          });
        },
        activeColor: Color.fromARGB(255, 0, 229, 255),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2E3F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 0, 229, 255), Color(0xFF9C27B0)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.celebration,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'FestiSpot',
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
            const Text(
              'Versión 1.0.0',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'FestiSpot es tu compañero perfecto para descubrir y disfrutar de los mejores eventos en tu ciudad.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            const Text(
              '© 2024 FestiSpot. Todos los derechos reservados.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 229, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
