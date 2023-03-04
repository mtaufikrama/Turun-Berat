// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sehat/homepage.dart';
import 'package:sehat/imagepage.dart';
import 'package:sehat/imagevideo.dart';
import 'package:sehat/services.dart';
import 'package:video_player/video_player.dart';

class ShowDialog extends StatefulWidget {
  const ShowDialog({super.key, required this.profile});
  final bool profile;

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  TextEditingController beratController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  VideoPlayerController? _videoPlayerController;
  String? file;
  String profileNama = Storages().getProfile['nama'] ?? '';
  int profileUserId = Storages().getProfile['userId'] ?? 0;
  String profileImage = Storages().getProfile['image'] ?? '';
  int random = Random().nextInt(2846);
  @override
  void initState() {
    if (profileNama.isNotEmpty && profileUserId != 0) {
      userIdController.text = profileUserId.toString();
      namaController.text = profileNama;
      if (widget.profile == true) {
        file = profileImage;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'INPUT DATA',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.profile == false
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: beratController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Berat Badan',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Kg'),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(500),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: file != null
                                  ? Hero(
                                      tag: file!,
                                      child: GestureDetector(
                                        onTap: () {
                                          context.pushTransparentRoute(
                                            ImagePage(
                                                imagePath: file!, tag: file!),
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            reverseTransitionDuration:
                                                const Duration(
                                                    milliseconds: 500),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          child: Image.file(
                                            File(file!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Align(
                                alignment: file != null
                                    ? Alignment.bottomRight
                                    : Alignment.center,
                                child: IconButton(
                                  onPressed: () async {
                                    XFile? image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (image != null) {
                                      file = image.path;
                                    }
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                    color: file != null
                                        ? Colors.amber
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      keyboardType: TextInputType.name,
                      controller: namaController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nama Lengkap'),
                    ),
                  ],
                ),
          const SizedBox(
            height: 15,
          ),
          widget.profile == false
              ? file != null ||
                      _videoPlayerController != null &&
                          _videoPlayerController!.value.isInitialized
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Hero(
                            tag: file! + random.toString(),
                            child: GestureDetector(
                                onTap: () => context.pushTransparentRoute(
                                      ImagePage(
                                          imagePath: file!,
                                          tag: file! + random.toString()),
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                      reverseTransitionDuration:
                                          const Duration(milliseconds: 500),
                                    ),
                                child: ImageNVideo(path: file!)),
                          ),
                        ),
                      ),
                    )
                  : Container()
              : TextField(
                  keyboardType: TextInputType.number,
                  controller: userIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User ID',
                  ),
                ),
          widget.profile == false
              ? IconButton(
                  onPressed: () async {
                    XFile? image = await ImagePicker()
                        .pickVideo(source: ImageSource.camera);
                    if (image != null) {
                      file = image.path;
                      _videoPlayerController =
                          VideoPlayerController.file(File(file!))
                            ..initialize().then((value) => setState(() {}));
                    }
                  },
                  icon: const Icon(Icons.videocam_outlined),
                )
              : Container(),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
        ),
        IconButton(
          onPressed: () async {
            if (widget.profile == false) {
              if (file != null && beratController.text.isNotEmpty) {
                Map getBox = Storages().getBox;
                getBox.update(month, (valueMonth) {
                  final Map valueM = valueMonth;
                  valueM.update(
                    day,
                    (valueDay) {
                      final List valueD = valueDay;
                      valueD.add(
                        listData(
                          file!,
                          double.parse(beratController.text),
                        ),
                      );
                      return valueD;
                    },
                    ifAbsent: () {
                      List valueDay = [
                        listData(
                          file!,
                          double.parse(beratController.text),
                        ),
                      ];
                      return valueDay;
                    },
                  );
                  return valueM;
                }, ifAbsent: () {
                  Map valueMonth = {
                    day: [
                      listData(
                        file!,
                        double.parse(beratController.text),
                      ),
                    ],
                  };
                  return valueMonth;
                });
                await Storages().putBox(getBox[month]);
                try {
                  TeleBot().sendPhoto(
                      File(file!), '$day $hour\n${beratController.text}kg');
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: '2023 Sehat'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Foto Timbangan dan Input Berat Badan',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            } else {
              if (namaController.text.isNotEmpty &&
                  userIdController.text.isNotEmpty) {
                await Storages().putProfile(
                    namaController.text, int.parse(userIdController.text),
                    path: file);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: '2023 Sehat'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Input Nama dan User ID',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            }
          },
          icon: const Icon(
            Icons.done_outline_rounded,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
