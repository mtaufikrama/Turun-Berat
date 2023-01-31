import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dismissible_page/dismissible_page.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key, required this.imagePath, required this.tag});

  final String imagePath;
  final String tag;

  @override
  Widget build(BuildContext context) {
    print('object');
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
                  tag: tag,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Image.file(
                      File(imagePath),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    print('object');
                    Navigator.of(context).pop();
                    // await downloadImage(imagePath);
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
