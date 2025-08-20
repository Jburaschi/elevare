class AppCategory {
  final String id;
  final String nombre;
  final String descripcion;
  AppCategory({required this.id, required this.nombre, required this.descripcion});

  factory AppCategory.fromJson(Map<String, dynamic> j) => AppCategory(
    id: '${j["id"]}',
    nombre: j["nombre"] ?? j["name"] ?? 'Sin nombre',
    descripcion: j["descripcion"] ?? j["description"] ?? '',
  );
}
