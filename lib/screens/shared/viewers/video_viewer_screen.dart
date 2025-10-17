import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewerScreen extends StatefulWidget {
  const VideoViewerScreen({super.key, required this.path});
  final String path;

  @override
  State<VideoViewerScreen> createState() => _VideoViewerScreenState();
}

class _VideoViewerScreenState extends State<VideoViewerScreen> {
  late VideoPlayerController controller;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(File(widget.path));
    controller.initialize().then((_) => setState(() => ready = true));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: Center(
        child: ready
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: ready
          ? FloatingActionButton(
              onPressed: () {
                setState(
                  () => controller.value.isPlaying
                      ? controller.pause()
                      : controller.play(),
                );
              },
              child: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
