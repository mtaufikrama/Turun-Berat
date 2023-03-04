import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class ImageNVideo extends StatefulWidget {
  const ImageNVideo({super.key, required this.path});
  final String path;

  @override
  State<ImageNVideo> createState() => _ImageNVideoState();
}

class _ImageNVideoState extends State<ImageNVideo> {
  VideoPlayerController? _videoPlayerController;
  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.file(File(widget.path))
      ..initialize();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(widget.path),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: [
            VideoPlayer(_videoPlayerController!),
            Center(
              child: IconButton(
                onPressed: () => setState(() {
                  if (_videoPlayerController!.value.isPlaying) {
                    _videoPlayerController!.pause();
                  } else {
                    _videoPlayerController!.play();
                    _videoPlayerController!.setLooping(true);
                  }
                }),
                icon: Icon(
                  _videoPlayerController!.value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
