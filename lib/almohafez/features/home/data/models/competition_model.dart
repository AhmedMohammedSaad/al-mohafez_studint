class Competition {
  final String id;
  final String name;
  final String description;
  final String? link;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? startDate;
  final DateTime? endDate;

  const Competition({
    required this.id,
    required this.name,
    required this.description,
    this.link,
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
    this.startDate,
    this.endDate,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      link: json['link'],
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'link': link,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }

  /// Check if competition has a valid link
  bool get hasLink => link != null && link!.isNotEmpty;

  @override
  String toString() {
    return 'Competition(id: $id, name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Competition && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
