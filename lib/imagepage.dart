import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:sehat/imagevideo.dart';
import 'package:video_player/video_player.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key, required this.imagePath, required this.tag});

  final String imagePath;
  final String tag;

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  VideoPlayerController? _videoPlayerController;
  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.file(File(widget.imagePath))
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
    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      startingOpacity: 0.7,
      isFullScreen: false,
      backgroundColor: Colors.black,
      direction: DismissiblePageDismissDirection.multi,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: widget.tag,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ImageNVideo(path: widget.imagePath),
                ),
              ),
              IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
