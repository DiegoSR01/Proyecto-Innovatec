class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T? Function(dynamic)? fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : json['data'],
      errors: json['errors'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
      'statusCode': statusCode,
    };
  }

  // Factory methods para respuestas comunes
  factory ApiResponse.success({required String message, T? data}) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: 200,
    );
  }

  factory ApiResponse.error({required String message, Map<String, dynamic>? errors, int? statusCode}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }

  @override
  String toString() {
    return 'ApiResponse{success: $success, message: $message, data: $data, errors: $errors, statusCode: $statusCode}';
  }
}
