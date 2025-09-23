import 'package:flutter/material.dart';
import 'package:festispot/utils/image_helper.dart';
import 'package:festispot/utils/variables.dart';

class EventoImageWidget extends StatelessWidget {
  final Evento evento;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  
  const EventoImageWidget({
    super.key,
    required this.evento,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ImageHelper.buildEventImageWidget(
      imagen: evento.imagen,
      bannerImageData: evento.bannerImageData,
      bannerImageType: evento.bannerImageType,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}

class EventoGalleryWidget extends StatelessWidget {
  final Evento evento;
  final double? imageWidth;
  final double? imageHeight;
  final double spacing;
  final Axis direction;
  final BorderRadius? borderRadius;
  
  const EventoGalleryWidget({
    super.key,
    required this.evento,
    this.imageWidth = 100,
    this.imageHeight = 100,
    this.spacing = 8.0,
    this.direction = Axis.horizontal,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final galleryImages = ImageHelper.buildGalleryImages(
      galleryImagesJson: null, // Usar solo campos de BD
      galleryImagesData: evento.galleryImagesData,
      galleryImagesMetadata: evento.galleryImagesMetadata,
      width: imageWidth,
      height: imageHeight,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
    );
    
    if (galleryImages.isEmpty) {
      return const SizedBox.shrink();
    }
    
    if (direction == Axis.horizontal) {
      return SizedBox(
        height: imageHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: galleryImages.length,
          separatorBuilder: (context, index) => SizedBox(width: spacing),
          itemBuilder: (context, index) => galleryImages[index],
        ),
      );
    } else {
      return Column(
        children: galleryImages
            .expand((image) => [image, SizedBox(height: spacing)])
            .take(galleryImages.length * 2 - 1)
            .toList(),
      );
    }
  }
}

/// Widget mejorado que maneja automáticamente imágenes de BD con fallback
class SmartEventImageWidget extends StatelessWidget {
  final Evento evento;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool showLoadingIndicator;
  final bool showDebugInfo;
  
  const SmartEventImageWidget({
    super.key,
    required this.evento,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.showLoadingIndicator = true,
    this.showDebugInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageHelper.buildEventImageWidget(
          imagen: evento.imagen,
          bannerImageData: evento.bannerImageData,
          bannerImageType: evento.bannerImageType,
          width: width,
          height: height,
          fit: fit,
          borderRadius: borderRadius,
          placeholder: _buildPlaceholder(),
          errorWidget: _buildErrorWidget(),
        ),
        if (showDebugInfo) _buildDebugOverlay(),
      ],
    );
  }
  
  Widget _buildPlaceholder() {
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[200]!,
            Colors.grey[300]!,
          ],
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            color: Colors.grey[500],
            size: (width != null && height != null) ? (width! + height!) / 8 : 20,
          ),
          const SizedBox(height: 8),
          Text(
            'Sin imagen',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (showLoadingIndicator) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildErrorWidget() {
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red[50]!,
            Colors.red[100]!,
          ],
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: Colors.red[400],
            size: (width != null && height != null) ? (width! + height!) / 8 : 20,
          ),
          const SizedBox(height: 8),
          Text(
            'Imagen no disponible',
            style: TextStyle(
              color: Colors.red[600],
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Usando placeholder',
              style: TextStyle(
                color: Colors.red[800],
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDebugOverlay() {
    return Positioned(
      top: 4,
      left: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DEBUG INFO',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'BD: ${evento.bannerImageData != null && evento.bannerImageData!.isNotEmpty ? "✓" : "✗"}',
              style: TextStyle(
                color: evento.bannerImageData != null && evento.bannerImageData!.isNotEmpty ? Colors.green : Colors.red,
                fontSize: 7,
              ),
            ),
            Text(
              'URL: ${evento.imagen.isNotEmpty ? "✓" : "✗"}',
              style: TextStyle(
                color: evento.imagen.isNotEmpty ? Colors.green : Colors.red,
                fontSize: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de ejemplo para mostrar cómo usar las imágenes decodificadas
class EjemploUsoImagenes extends StatelessWidget {
  final Evento evento;
  
  const EjemploUsoImagenes({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen principal del evento (versión mejorada)
        const Text(
          'Imagen Principal (Smart Widget):',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SmartEventImageWidget(
          evento: evento,
          width: double.infinity,
          height: 200,
          borderRadius: BorderRadius.circular(12),
          showDebugInfo: true,
        ),
        
        const SizedBox(height: 20),
        
        // Imagen tradicional
        const Text(
          'Imagen Tradicional:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        EventoImageWidget(
          evento: evento,
          width: double.infinity,
          height: 150,
          borderRadius: BorderRadius.circular(12),
        ),
        
        const SizedBox(height: 20),
        
        // Galería de imágenes
        const Text(
          'Galería de Imágenes:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        EventoGalleryWidget(
          evento: evento,
          imageWidth: 120,
          imageHeight: 90,
          spacing: 12,
          borderRadius: BorderRadius.circular(8),
        ),
        
        const SizedBox(height: 20),
        
        // Ejemplo usando la extensión directamente
        const Text(
          'Usando extensión directa:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        evento.imagen.toImageWidget(
          width: 150,
          height: 150,
          borderRadius: BorderRadius.circular(75), // Imagen circular
        ),
        
        const SizedBox(height: 20),
        
        // Información de debug
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Debug Information:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text('imagen: ${evento.imagen.isNotEmpty ? evento.imagen : "null"}'),
              Text('bannerImageData: ${evento.bannerImageData != null && evento.bannerImageData!.isNotEmpty ? "${evento.bannerImageData!.length} chars" : "null"}'),
              Text('bannerImageType: ${evento.bannerImageType ?? "null"}'),
              Text('galleryImagesData: ${evento.galleryImagesData != null && evento.galleryImagesData!.isNotEmpty ? "${evento.galleryImagesData!.length} chars" : "null"}'),
              const SizedBox(height: 8),
              Text('isValidImage: ${evento.imagen.isValidImage}'),
              Text('isBase64Image: ${evento.imagen.isBase64Image}'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Widget para mostrar imagen de perfil de usuario con soporte base64
class UserAvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final String? avatarBase64Data;
  final double size;
  final String? fallbackText;
  
  const UserAvatarWidget({
    super.key,
    this.avatarUrl,
    this.avatarBase64Data,
    this.size = 50,
    this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: ImageHelper.buildImageWidget(
          imageField: avatarBase64Data ?? avatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: _buildFallbackAvatar(),
          errorWidget: _buildFallbackAvatar(),
        ),
      ),
    );
  }
  
  Widget _buildFallbackAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[400]!,
            Colors.grey[500]!,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: fallbackText != null && fallbackText!.isNotEmpty
            ? Text(
                fallbackText![0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(
                Icons.person,
                color: Colors.white,
                size: size * 0.6,
              ),
      ),
    );
  }
}