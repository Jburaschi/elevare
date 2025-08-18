import 'package:flutter/material.dart';
import '../models/video.dart';

class VideoPlayerScreen extends StatelessWidget {
  final Video video;

  VideoPlayerScreen({required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(video.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline, size: 100),
            SizedBox(height: 20),
            Text('Aquí se reproducirá el video: ${video.title}'),
          ],
        ),
      ),
    );
  }
}
