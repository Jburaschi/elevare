import 'package:flutter/material.dart';
import '../models/video.dart';
import '../widgets/video_card.dart';
import 'login_screen.dart';

class LandingScreen extends StatelessWidget {
  final List<Video> videos = [
    Video(id: 1, title: 'Pasarela básica', description: 'Tips de pasarela', isLocked: true),
    Video(id: 2, title: 'Fotografía profesional', description: 'Cómo posar frente a la cámara', isLocked: true),
    Video(id: 3, title: 'Postura y actitud', description: 'Mejora tu presencia escénica', isLocked: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Landing Page')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3/2, crossAxisSpacing: 16, mainAxisSpacing: 16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            child: VideoCard(video: videos[index]),
          );
        },
      ),
    );
  }
}
