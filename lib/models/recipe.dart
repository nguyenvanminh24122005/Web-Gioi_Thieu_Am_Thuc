class Recipe {
  final int? id;
  final String name;
  final String region;
  final String description;
  final DateTime createdAt;
  final String? imagePath; // ✅ ảnh

  Recipe({
    this.id,
    required this.name,
    required this.region,
    required this.description,
    required this.createdAt,
    this.imagePath,
  });

  Recipe copyWith({
    int? id,
    String? name,
    String? region,
    String? description,
    DateTime? createdAt,
    String? imagePath,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as int?,
      name: map['name'] as String,
      region: map['region'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      imagePath: map['imagePath'] as String?,
    );
  }
}