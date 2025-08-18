import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../services/content_service.dart';

class VideoScreen extends StatefulWidget {
  final int id;
  const VideoScreen({super.key, required this.id});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final _service = ContentService();
  VideoPlayerController? _controller;
  ChewieController? _chewie;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final urlOrToken = await _service.getVimeoUrlOrToken(widget.id);
      if (urlOrToken.isEmpty) throw Exception('No hay URL de reproducción disponible');
      _controller = VideoPlayerController.networkUrl(Uri.parse(urlOrToken));
      await _controller!.initialize();
      _chewie = ChewieController(videoPlayerController: _controller!, autoPlay: true, looping: false);
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    _chewie?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => Navigator.of(context).pop()), title: const Text('Reproduciendo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Builder(
            builder: (_) {
              if (loading) return const CircularProgressIndicator();
              if (error != null) return Text(error!, style: const TextStyle(color: Colors.red));
              return AspectRatio(
                aspectRatio: _controller!.value.aspectRatio == 0 ? 16 / 9 : _controller!.value.aspectRatio,
                child: Chewie(controller: _chewie!),
              );
            },
          ),
        ),
      ),
    );
  }
}
