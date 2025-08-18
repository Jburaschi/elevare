import 'package:flutter/material.dart';
import '../models/video.dart';

class VideoCard extends StatelessWidget {
  final Video video;

  VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library, size: 50),
              SizedBox(height: 8),
              Text(video.title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(video.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        if (video.isLocked)
          Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.lock, color: Colors.red),
          ),
      ],
    );
  }
}
