class TopStudent {
  final String id;
  final String studentId;
  final String teacherId;
  final String name;
  final double progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TopStudent({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.name,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TopStudent.fromJson(Map<String, dynamic> json) {
    return TopStudent(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      name: json['name'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'teacher_id': teacherId,
      'name': name,
      'progress': progress,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TopStudent copyWith({
    String? id,
    String? studentId,
    String? teacherId,
    String? name,
    double? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TopStudent(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      teacherId: teacherId ?? this.teacherId,
      name: name ?? this.name,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TopStudent(id: $id, name: $name, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TopStudent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
