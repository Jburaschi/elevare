class AppCategory {
  final int id;
  final String nombre;
  final String descripcion;

  AppCategory({required this.id, required this.nombre, required this.descripcion});

  factory AppCategory.fromJson(Map<String, dynamic> json) => AppCategory(
        id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
        nombre: json['nombre'] ?? '',
        descripcion: json['descripcion'] ?? '',
      );
}
