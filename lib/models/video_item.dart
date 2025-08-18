class VideoItem {
  final int id;
  final String titulo;
  final String descripcion;
  final int categoriaId;
  final DateTime fechaPublicacion;
  final bool premium; // si requiere pago
  final String? thumbnailUrl;

  VideoItem({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoriaId,
    required this.fechaPublicacion,
    required this.premium,
    this.thumbnailUrl,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) => VideoItem(
        id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
        titulo: json['titulo'] ?? '',
        descripcion: json['descripcion'] ?? '',
        categoriaId: json['categoriaId'] is int ? json['categoriaId'] : int.tryParse('${json['categoriaId']}') ?? 0,
        fechaPublicacion: DateTime.tryParse('${json['fechaPublicacion'] ?? ''}') ?? DateTime.now(),
        premium: json['premium'] == true || json['premium'] == 1 || '${json['premium']}' == 'true',
        thumbnailUrl: (json['thumbnail'] ?? json['thumbnailUrl'])?.toString(),
      );
}
