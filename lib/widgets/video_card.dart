import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/video_item.dart';

class VideoCard extends StatelessWidget {
  final VideoItem item;
  final bool locked;
  final VoidCallback? onTap;
  const VideoCard({super.key, required this.item, this.locked = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: locked ? null : onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              color: Colors.grey.shade900,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: item.thumbnailUrl != null
                    ? Image.network(item.thumbnailUrl!, fit: BoxFit.cover, width: double.infinity)
                    : Container(color: Colors.black),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                item.titulo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [
                  Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 1))
                ]),
              ),
            ),
            if (locked)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.55),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/lock.svg', width: 42, height: 42),
                        const SizedBox(height: 8),
                        const Text('Contenido bloqueado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
