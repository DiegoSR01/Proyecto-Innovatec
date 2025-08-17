import 'package:festispot/paginas/model_event.dart';

final List<Evento> carrusel = [
  Evento(
    id: 1,
    nombre: 'Cata de vinos',
    imagen: "assets/images/cata.jpeg",
    descripcion:
        "Disfruta de una cata de vinos con expertos en la materia. Aprende sobre diferentes variedades y técnicas de degustación.",
  ),
  Evento(
    id: 2,
    nombre: 'Concierto de musica clásica',
    imagen: "assets/images/conc_ejem.jpg",
    descripcion:
        "Asiste a un concierto de música clásica con una orquesta reconocida. Una experiencia cultural única.", 
    categoria: "concierto", 
    ubicacion: " Auditorio Nacional",
    fecha:"2023-10-15"
  ),
  Evento(
    id: 3,
    nombre: 'Feria del alfeñique',
    imagen: "assets/images/feria_ejem.jpeg",
    descripcion:
        "Disfruta de un día lleno de tradición en la Feria del Alfeñique. Prueba dulces típicos y disfruta de actividades culturales.",
  ),
  Evento(
    id: 4,
    nombre: 'Feria de agrucultura',
    imagen: "assets/images/feria_agri.jpeg",
    descripcion:
        "Visita la Feria de Agricultura para conocer más sobre prácticas sostenibles y productos locales. Ideal para los amantes de la naturaleza.",
  ),
];
