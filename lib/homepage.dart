import 'dart:io';
import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sehat/imagepage.dart';
import 'package:sehat/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> getBox = Storages().getBox;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: getBox.keys
              .map(
                (e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Colors.amber,
                      child: Text(
                        e.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: getBox[e].length,
                      itemBuilder: (context, index) {
                        var data = getBox[e][index];
                        String random = Random().nextInt(2846).toString();
                        return ListTile(
                          leading: GestureDetector(
                            onTap: () => context.pushTransparentRoute(
                              ImagePage(
                                  imagePath: data['image'],
                                  tag: data['image'] + random),
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 500),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Hero(
                                tag: data['image'] + random,
                                child: Image.file(
                                  File(data['image']),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          title: Text(data['jam']),
                          trailing: Text(data['berat']),
                        );
                      },
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const ShowDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ShowDialog extends StatefulWidget {
  const ShowDialog({super.key});

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  TextEditingController beratController = TextEditingController();
  String? file;
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: beratController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Input Berat Badan',
                      hintText: ''),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('Kg'),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          file != null
              ? SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(file!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Container(),
          IconButton(
            onPressed: () async {
              XFile? image =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (image != null) {
                file = image.path;
                print(file);
              }
              setState(() {});
            },
            icon: const Icon(Icons.camera_alt_outlined),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.cancel_rounded),
        ),
        IconButton(
          onPressed: () async {
            dynamic getData = Storages().getBox[day] ?? {};
            if (file != null && beratController.text.isNotEmpty) {
              List<dynamic> listdata = [];
              print('getData : $getData');
              if (getData.isNotEmpty) {
                listdata.addAll(getData);
              }
              print(listdata);
              listdata.add(
                listData(
                  file!,
                  '${beratController.text}kg',
                ),
              );
              print(listdata);
              await Storages().putBox(listdata);
              print('storage get box : ${Storages().getBox}');
              // ignore: use_build_context_synchronously
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
          },
          icon: const Icon(Icons.done_outline_rounded),
        ),
      ],
    );
  }
}
