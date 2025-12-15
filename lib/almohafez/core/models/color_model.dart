import 'dart:convert';

ColorModel colorModelFromJson(String str) {
  final jsonData = json.decode(str);
  if (jsonData is Map<String, dynamic>) {
    return ColorModel.fromJson(jsonData);
  }
  throw const FormatException('Unexpected JSON format for ColorModel');
}

String colorModelToJson(ColorModel data) => json.encode(data.toJson());

class ColorModel {
  ColorModel({
    required this.id,
    required this.name,
    required this.hex,
    this.createdAt,
    this.updatedAt,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      hex: json['hex'] as String,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }
  final String id;
  final String name;
  final String hex;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'hex': hex,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
