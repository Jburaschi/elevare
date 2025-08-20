class VideoItem {
  final String id;
  final String titulo;
  final String thumbnailUrl;
  final String categoriaId;
  final bool premium;

  VideoItem({
    required this.id,
    required this.titulo,
    required this.thumbnailUrl,
    required this.categoriaId,
    required this.premium,
  });

  factory VideoItem.fromJson(Map<String, dynamic> j) => VideoItem(
    id: '${j["id"]}',
    titulo: j["titulo"] ?? j["title"] ?? 'Video',
    thumbnailUrl: j["thumbnailUrl"] ?? j["thumbnail"] ?? 'https://picsum.photos/600/400?random=${j["id"] ?? ""}',
    categoriaId: '${j["categoriaId"] ?? j["categoryId"] ?? "0"}',
    premium: (j["premium"] ?? j["isPremium"] ?? false) == true,
  );
}
