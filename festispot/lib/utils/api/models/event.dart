class Event {
  final String? id;
  final String title;
  final String description;
  final String? category;
  final String? location;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? price;
  final String? imageUrl;
  final String? organizerId;
  final String? organizerName;
  final int? capacity;
  final int? attendeesCount;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Event({
    this.id,
    required this.title,
    required this.description,
    this.category,
    this.location,
    this.date,
    this.startTime,
    this.endTime,
    this.price,
    this.imageUrl,
    this.organizerId,
    this.organizerName,
    this.capacity,
    this.attendeesCount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'],
      location: json['location'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      price: json['price']?.toDouble(),
      imageUrl: json['imageUrl'] ?? json['image_url'],
      organizerId: json['organizerId']?.toString() ?? json['organizer_id']?.toString(),
      organizerName: json['organizerName'] ?? json['organizer_name'],
      capacity: json['capacity']?.toInt(),
      attendeesCount: json['attendeesCount']?.toInt() ?? json['attendees_count']?.toInt(),
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'date': date?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'price': price,
      'imageUrl': imageUrl,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'capacity': capacity,
      'attendeesCount': attendeesCount,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? location,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    double? price,
    String? imageUrl,
    String? organizerId,
    String? organizerName,
    int? capacity,
    int? attendeesCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      capacity: capacity ?? this.capacity,
      attendeesCount: attendeesCount ?? this.attendeesCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Event{id: $id, title: $title, category: $category, location: $location, date: $date}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
