import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:festispot/config/api_config.dart';

class ImageHelper {
  // URL base para imágenes del servidor - usando la configuración de API
  static String get baseImageUrl => '${ApiConfig.baseUrl}/storage/images/';
  
  /// Decodifica y obtiene el widget de imagen apropiado basado en el campo de la BD
  static Widget buildImageWidget({
    required String? imageField,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
  }) {
    Widget image;
    
    // Si no hay imagen o está vacía, mostrar placeholder
    if (imageField == null || imageField.isEmpty) {
      image = _buildPlaceholder(width, height, placeholder);
    } else if (_isBase64Image(imageField)) {
      // Si es una imagen base64 (BLOB de la BD)
      image = _buildBase64Image(imageField, width, height, fit, errorWidget);
    } else if (_isValidImageFormat(imageField)) {
      // Solo procesar si es un formato de imagen válido
      if (_isUrl(imageField)) {
        // Si es una URL completa (externa)
        image = _buildNetworkImage(imageField, width, height, fit, errorWidget);
      } else {
        // Asumir que es nombre de archivo en el servidor (desde BD)
        String fullUrl = baseImageUrl + imageField;
        image = _buildNetworkImage(fullUrl, width, height, fit, errorWidget);
      }
    } else {
      // Si no es un formato válido, mostrar placeholder
      image = _buildPlaceholder(width, height, placeholder);
    }
    
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: image,
      );
    }
    
    return image;
  }
  
  /// Construye un widget de imagen desde un evento con múltiples fuentes
  static Widget buildEventImageWidget({
    required String? imagen,
    required String? bannerImageData,
    required String? bannerImageType,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
  }) {
    // Prioridad: 1. bannerImageData (BLOB), 2. imagen (URL/filename)
    String? imageToUse;
    
    if (bannerImageData != null && bannerImageData.isNotEmpty) {
      // Si hay datos BLOB, usar esos
      imageToUse = bannerImageData;
    } else if (imagen != null && imagen.isNotEmpty) {
      // Si hay URL o filename, usar eso
      imageToUse = imagen;
    }
    
    return buildImageWidget(
      imageField: imageToUse,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      borderRadius: borderRadius,
    );
  }
  
  /// Decodifica gallery_images JSON y BLOB y retorna una lista de widgets
  static List<Widget> buildGalleryImages({
    required String? galleryImagesJson,
    required String? galleryImagesData,
    required String? galleryImagesMetadata,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    List<Widget> galleryWidgets = [];
    
    // Intentar procesar BLOB data primero
    if (galleryImagesData != null && galleryImagesData.isNotEmpty) {
      try {
        // Procesar metadata si existe (para futuras mejoras)
        // Map<String, dynamic>? metadata;
        // if (galleryImagesMetadata != null && galleryImagesMetadata.isNotEmpty) {
        //   metadata = json.decode(galleryImagesMetadata);
        // }
        
        // El BLOB puede contener múltiples imágenes separadas
        // o puede ser una imagen única base64
        if (_isBase64Image(galleryImagesData)) {
          // Es una imagen base64 única
          galleryWidgets.add(buildImageWidget(
            imageField: galleryImagesData,
            width: width,
            height: height,
            fit: fit,
            borderRadius: borderRadius,
          ));
        } else {
          // Intentar decodificar como JSON de múltiples imágenes
          try {
            dynamic decodedImages = json.decode(galleryImagesData);
            if (decodedImages is List) {
              for (String imageData in decodedImages) {
                galleryWidgets.add(buildImageWidget(
                  imageField: imageData,
                  width: width,
                  height: height,
                  fit: fit,
                  borderRadius: borderRadius,
                ));
              }
            }
          } catch (e) {
            if (ApiConfig.isDebugMode) {
              print('Gallery images data no es JSON válido, intentando como imagen única');
            }
          }
        }
      } catch (e) {
        if (ApiConfig.isDebugMode) {
          print('Error al procesar gallery_images BLOB: $e');
        }
      }
    }
    
    // Si no hay imágenes del BLOB, intentar con JSON
    if (galleryWidgets.isEmpty && galleryImagesJson != null && galleryImagesJson.isNotEmpty) {
      try {
        dynamic decodedImages = json.decode(galleryImagesJson);
        
        List<String> imageUrls = [];
        
        if (decodedImages is List) {
          // Si es una lista de strings
          imageUrls = decodedImages.cast<String>();
        } else if (decodedImages is Map) {
          // Si es un objeto con URLs
          imageUrls = (decodedImages['images'] as List?)?.cast<String>() ?? [];
        }
        
        galleryWidgets.addAll(imageUrls.map((imageUrl) {
          return buildImageWidget(
            imageField: imageUrl,
            width: width,
            height: height,
            fit: fit,
            borderRadius: borderRadius,
          );
        }));
        
      } catch (e) {
        if (ApiConfig.isDebugMode) {
          print('Error al decodificar gallery_images JSON: $e');
        }
      }
    }
    
    return galleryWidgets;
  }
  
  /// Obtiene la URL completa de una imagen desde la BD
  static String getImageUrl(String? imageField) {
    if (imageField == null || imageField.isEmpty) {
      return '';
    }
    
    if (_isBase64Image(imageField)) {
      return imageField; // Retornar base64 tal como está
    }
    
    if (_isUrl(imageField)) {
      return imageField; // URL externa completa
    }
    
    if (_isValidImageFormat(imageField)) {
      return baseImageUrl + imageField; // Archivo del servidor
    }
    
    // Si no es un formato válido, retornar vacío
    return '';
  }
  
  /// Verifica si es un formato de imagen válido desde BD
  static bool _isValidImageFormat(String imageField) {
    if (_isBase64Image(imageField)) {
      return true; // Base64 válido
    }
    
    if (_isUrl(imageField)) {
      return true; // URL externa válida
    }
    
    // Verificar extensiones de archivo válidas para archivos del servidor
    final String lowerCase = imageField.toLowerCase();
    final List<String> validExtensions = [
      '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg'
    ];
    
    return validExtensions.any((ext) => lowerCase.endsWith(ext));
  }
  
  /// Verifica si es una imagen base64 (BLOB decodificado)
  static bool _isBase64Image(String imageField) {
    // Verificar si tiene el formato data:image/...;base64,
    if (imageField.startsWith('data:image/') && imageField.contains(';base64,')) {
      return true;
    }
    
    // Verificar si es base64 puro (sin prefijo data:)
    // Base64 debe tener longitud múltiplo de 4 y solo caracteres válidos
    if (imageField.length % 4 == 0) {
      final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*=*$');
      if (base64Pattern.hasMatch(imageField)) {
        // Verificar que sea lo suficientemente largo para ser una imagen
        return imageField.length > 100; // Mínimo razonable para una imagen
      }
    }
    
    return false;
  }
  
  /// Verifica si es una URL completa (externa)
  static bool _isUrl(String imageField) {
    return imageField.startsWith('http://') || imageField.startsWith('https://');
  }
  
  /// Construye widget para imagen base64 (BLOB de BD)
  static Widget _buildBase64Image(String base64Data, double? width, double? height, BoxFit fit, Widget? errorWidget) {
    try {
      Uint8List bytes;
      
      if (base64Data.startsWith('data:image/')) {
        // Formato data:image/...;base64,<data>
        final base64String = base64Data.split(',')[1];
        bytes = base64Decode(base64String);
      } else {
        // Base64 puro
        bytes = base64Decode(base64Data);
      }
      
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          if (ApiConfig.isDebugMode) {
            print('Error al mostrar imagen base64: $error');
          }
          return errorWidget ?? _buildErrorWidget(width, height, 'Base64');
        },
      );
    } catch (e) {
      if (ApiConfig.isDebugMode) {
        print('Error al decodificar base64: $e');
      }
      return errorWidget ?? _buildErrorWidget(width, height, 'Base64');
    }
  }
  
  /// Construye widget para imagen de red (desde servidor o URL externa)
  static Widget _buildNetworkImage(String url, double? width, double? height, BoxFit fit, Widget? errorWidget) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      headers: ApiConfig.headers,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingWidget(width, height);
      },
      errorBuilder: (context, error, stackTrace) {
        if (ApiConfig.isDebugMode) {
          print('Error al cargar imagen desde BD: $url - $error');
        }
        return errorWidget ?? _buildErrorWidget(width, height, 'Red');
      },
    );
  }
  
  /// Construye widget placeholder
  static Widget _buildPlaceholder(double? width, double? height, Widget? placeholder) {
    if (placeholder != null) return placeholder;
    
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            color: Colors.grey[600],
            size: (width != null && height != null) ? (width + height) / 8 : 20,
          ),
          if (ApiConfig.isDebugMode) ...[
            const SizedBox(height: 4),
            Text(
              'Sin imagen',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  /// Construye widget de loading
  static Widget _buildLoadingWidget(double? width, double? height) {
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );
  }
  
  /// Construye widget de error para imágenes de BD
  static Widget _buildErrorWidget(double? width, double? height, [String? source]) {
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[300]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: Colors.red[400],
            size: (width != null && height != null) ? (width + height) / 10 : 24,
          ),
          if (ApiConfig.isDebugMode && source != null) ...[
            const SizedBox(height: 4),
            Text(
              'Error $source',
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Extensión para facilitar el uso en widgets
extension ImageWidgetExtension on String? {
  /// Convierte el campo de imagen a un widget Image
  Widget toImageWidget({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return ImageHelper.buildImageWidget(
      imageField: this,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
  
  /// Obtiene la URL completa de la imagen
  String get imageUrl => ImageHelper.getImageUrl(this);
  
  /// Verifica si es una imagen válida desde BD
  bool get isValidImage {
    if (this == null || this!.isEmpty) return false;
    return ImageHelper._isValidImageFormat(this!);
  }
  
  /// Verifica si es una imagen base64
  bool get isBase64Image {
    if (this == null || this!.isEmpty) return false;
    return ImageHelper._isBase64Image(this!);
  }
}

/// Extensión para usar con el modelo Evento mejorado
extension EventoImageExtension on dynamic {
  /// Construye widget de imagen para eventos con soporte completo para BD
  Widget toEventImageWidget({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    // Si es un modelo Evento con campos de BD
    if (runtimeType.toString() == 'Evento') {
      return ImageHelper.buildEventImageWidget(
        imagen: this.imagen,
        bannerImageData: this.bannerImageData,
        bannerImageType: this.bannerImageType,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
        borderRadius: borderRadius,
      );
    } else {
      // Si es un string simple, usar método normal
      return ImageHelper.buildImageWidget(
        imageField: this?.toString(),
        width: width,
        height: height,
        fit: fit,
        borderRadius: borderRadius,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );
    }
  }
  
  /// Construye galería de imágenes para eventos
  List<Widget> toEventGalleryWidgets({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    // Si es un modelo Evento con campos de BD
    if (runtimeType.toString() == 'Evento') {
      return ImageHelper.buildGalleryImages(
        galleryImagesJson: this.imagen, // Fallback a imagen simple
        galleryImagesData: this.galleryImagesData,
        galleryImagesMetadata: this.galleryImagesMetadata,
        width: width,
        height: height,
        fit: fit,
        borderRadius: borderRadius,
      );
    }
    return [];
  }
}