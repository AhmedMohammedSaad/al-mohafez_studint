class PaginationMeta {
  const PaginationMeta({
    required this.count,
    required this.currentPage,
    required this.totalPages,
  });

  factory PaginationMeta.initial() {
    return const PaginationMeta(
      count: 0,
      currentPage: 1,
      totalPages: 1,
    );
  }

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      count: json['limit'] ?? 0,
      currentPage: json['page'] ?? 1,
      totalPages: ((json['total'] ?? 1) / (json['limit'] ?? 1)).ceil(),
    );
  }
  final int count;
  final int currentPage;
  final int totalPages;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'limit': count,
      'page': currentPage,
      'total': totalPages,
    };
  }

  PaginationMeta copyWith({
    int? count,
    int? currentPage,
    int? totalPages,
  }) {
    return PaginationMeta(
      count: count ?? this.count,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
