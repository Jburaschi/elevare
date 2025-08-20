import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/content_service.dart';

class VideoScreen extends StatefulWidget {
  final String itemId;
  final String title;
  const VideoScreen({super.key, required this.itemId, required this.title});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ChewieController? _chewie;
  VideoPlayerController? _video;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final url = await ContentService().fetchVideoUrl(widget.itemId);
    _video = VideoPlayerController.networkUrl(Uri.parse(url));
    await _video!.initialize();
    _chewie = ChewieController(videoPlayerController: _video!, autoPlay: true, looping: false);
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _chewie?.dispose();
    _video?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: _video!.value.aspectRatio,
                child: Chewie(controller: _chewie!),
              ),
      ),
    );
  }
}
