import 'package:flutter/material.dart';
import 'package:festispot/utils/eventos_carrusel.dart';
import 'package:festispot/utils/variables.dart';
import 'package:festispot/screens/productor/mostrar_eventop.dart';

class ExplorarEventos extends StatefulWidget {
  const ExplorarEventos({super.key});

  @override
  State<ExplorarEventos> createState() => _ExplorarEventosState();
}

class _ExplorarEventosState extends State<ExplorarEventos> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todos';
  List<Evento> _filteredEventos = [];

  final List<String> _categories = [
    'Todos',
    'Conferencia',
    'Seminario',
    'Taller',
    'Networking',
    'Festival',
    'Evento Deportivo',
    'Evento Cultural',
    'Evento Empresarial',
    'Educativo',
    'Evento Social',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _filteredEventos = carrusel;
  }

  void _filterEvents() {
    setState(() {
      _filteredEventos = carrusel.where((evento) {
        bool matchesSearch = evento.nombre.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        bool matchesCategory = _selectedCategory == 'Todos';
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

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
          "🔍 Explorar Eventos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Color.fromARGB(255, 0, 229, 255),
              size: 24,
            ),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2D2E3F),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar eventos...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 0, 229, 255),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onChanged: (value) {
                  _filterEvents();
                },
              ),
            ),
          ),

          // Filtros de categorías
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        _filterEvents();
                      });
                    },
                    backgroundColor: const Color(0xFF2D2E3F),
                    selectedColor: Color.fromARGB(255, 0, 229, 255),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? Color.fromARGB(255, 0, 229, 255)
                          : Colors.transparent,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Resultados de búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredEventos.length} eventos encontrados',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      // Toggle entre grid y lista
                    });
                  },
                  icon: const Icon(Icons.grid_view, color: Color(0xFFE91E63)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Lista de eventos
          Expanded(
            child: _filteredEventos.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredEventos.length,
                    itemBuilder: (context, index) {
                      final evento = _filteredEventos[index];
                      return _buildEventCard(evento);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Evento evento) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2E3F),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            evento.copy();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MostrarEventoprod(carrusel: evento),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Imagen del evento
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage(
                    placeholder: const AssetImage("assets/images/loading.gif"),
                    image: AssetImage(evento.imagen),
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(width: 16),
                // Información del evento
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evento.nombre ?? 'Evento',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white.withOpacity(0.6),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Ciudad de México',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white.withOpacity(0.6),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Próximamente',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 229, 255),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              evento.categoria ?? 'Evento',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.8',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botón de favorito
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Toggle favorito
                      },
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Color(0xFFE91E63),
                        size: 24,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color.fromARGB(255, 0, 229, 255), Color(0xFF9C27B0)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Ver',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron eventos',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Prueba con otros términos de búsqueda',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2E3F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtros',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ordenar por:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildFilterOption('Más populares'),
              _buildFilterOption('Fecha más próxima'),
              _buildFilterOption('Precio más bajo'),
              _buildFilterOption('Mejor valorados'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 229, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Aplicar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      leading: Radio<String>(
        value: title,
        groupValue: null, // Aquí puedes manejar el estado seleccionado
        onChanged: (value) {
          // Manejar selección
        },
        activeColor:Color.fromARGB(255, 0, 229, 255),
      ),
    );
  }
}
