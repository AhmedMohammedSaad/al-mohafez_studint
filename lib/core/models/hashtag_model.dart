class HashtagResponse {
  HashtagResponse({
    required this.count,
    required this.currentPage,
    required this.totalPages,
    required this.docs,
  });

  factory HashtagResponse.fromJson(Map<String, dynamic> json) {
    final result = json['result'];
    return HashtagResponse(
      count: result['count'] ?? 0,
      currentPage: result['currentPage'] ?? 1,
      totalPages: result['totalPages'] ?? 1,
      docs: List<HashtagModel>.from(
        (result['docs'] as List).map((x) => HashtagModel.fromJson(x)),
      ),
    );
  }
  final int count;
  final int currentPage;
  final int totalPages;
  final List<HashtagModel> docs;
}

class HashtagModel {
  const HashtagModel({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.outfits = 0,
  });

  /// Factory from JSON
  factory HashtagModel.fromJson(Map<String, dynamic> json) {
    return HashtagModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      outfits: json['outfits'] ?? 0,
    );
  }

  /// ✅ Empty instance
  factory HashtagModel.empty() {
    return HashtagModel(
      id: '',
      name: '',
      status: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      outfits: 0,
    );
  }
  final String id;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int outfits;

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'outfits': outfits,
    };
  }

  /// ✅ Copy with
  HashtagModel copyWith({
    String? id,
    String? name,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? outfits,
  }) {
    return HashtagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      outfits: outfits ?? this.outfits,
    );
  }
}
