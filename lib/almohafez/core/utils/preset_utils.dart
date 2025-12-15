// lib/utils/preset_utils.dart

enum PresetType {
  countries,
  categories,
  tags,
  brands,
  colors,
  conditions,
}

// ignore: constant_identifier_names
enum OrderDirection { ASC, DESC }

class PresetUtils {
  static const _names = {
    PresetType.countries: 'COUNTRIES',
    PresetType.categories: 'CATEGORIES',
    PresetType.tags: 'TAGS',
    PresetType.brands: 'BRANDS',
    PresetType.colors: 'COLORS',
    PresetType.conditions: 'CONDITIONS',
  };

  /// Upper‑case name the backend expects
  static String getPresetTypeName(PresetType type) => _names[type]!;

  /// Reverse lookup
  static PresetType fromName(String name) => _names.entries.firstWhere((e) => e.value == name).key;

  /// All the string names
  static List<String> getPresetTypeNames() => _names.values.toList();
}

class GetPresetsDto {
  GetPresetsDto({
    required this.entity,
    this.orderField,
    this.orderDirection,
    this.filterField,
    this.filterValue,
    this.page,
    this.limit,
  });
  final PresetType entity;
  final String? orderField;
  final OrderDirection? orderDirection;
  final String? filterField;
  final String? filterValue;
  final int? page;
  final int? limit;

  Map<String, dynamic> toJson() => {
        'entity': PresetUtils.getPresetTypeName(entity),
        if (orderField != null) 'orderField': orderField,
        if (orderDirection != null) 'orderDirection': orderDirection!.name,
        if (filterField != null) 'filterField': filterField,
        if (filterValue != null) 'filterValue': filterValue,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      };
}

class GetMultiplePresetsDto {
  GetMultiplePresetsDto({required this.entities});
  final List<GetPresetsDto> entities;

  Map<String, dynamic> toJson() => {'entities': entities.map((e) => e.toJson()).toList()};
}
