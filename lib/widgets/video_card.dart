import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/video_item.dart';
import 'locked_overlay.dart';

class VideoCard extends StatelessWidget {
  final VideoItem item;
  final bool locked;
  final VoidCallback? onTap;
  const VideoCard({super.key, required this.item, required this.locked, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: item.thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey.shade200),
            ),
          ),
          if (locked) const LockedOverlay(),
          Positioned(
            left: 12, right: 12, bottom: 12,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.55),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
