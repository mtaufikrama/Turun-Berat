import 'dart:io';
import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:sehat/imagepage.dart';
import 'package:sehat/services.dart';
import 'package:sehat/showdialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<dynamic, dynamic> getBox = Storages().getBox;
  final String nama = Storages().getProfile['nama'] ?? '';
  late double selisih;
  late double pertama;
  late double terakhir;
  @override
  void initState() {
    if (getBox.isNotEmpty) {
      pertama = getBox.values.first.values.first.first['berat'];
      terakhir = getBox.values.last.values.last.last['berat'];
    } else {
      pertama = 0.0;
      terakhir = 0.0;
    }
    selisih = terakhir - pertama;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const ShowDialog(profile: true),
            ),
            icon: const Icon(
              Icons.person,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            nama.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        'Hi, $nama',
                      ),
                      subtitle: Text(
                          'First Weight : ${pertama.toStringAsFixed(2)}kg\nLast Weight : ${terakhir.toStringAsFixed(2)}kg'),
                      leading: Storages().getProfile['image'] != null
                          ? GestureDetector(
                              onTap: () => context.pushTransparentRoute(
                                ImagePage(
                                  imagePath: Storages().getProfile['image'],
                                  tag: Storages().getProfile['image'],
                                ),
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                reverseTransitionDuration:
                                    const Duration(milliseconds: 500),
                              ),
                              child: Hero(
                                tag: Storages().getProfile['image'],
                                child: CircleAvatar(
                                  backgroundImage: FileImage(
                                    File(
                                      Storages().getProfile['image'],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : null,
                      trailing: Text(
                        '${selisih.abs().toStringAsFixed(2)}kg ${selisih > 0 ? '⬆' : selisih == 0 ? '' : '⬇'}',
                        style: TextStyle(
                          color: selisih < 0
                              ? Colors.green
                              : selisih == 0
                                  ? Colors.grey
                                  : Colors.red,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getBox.keys.map((e) {
                Map valueMonth = getBox[e];
                double selisihPerBulan = valueMonth.values.last.last['berat'] -
                    valueMonth.values.first.first['berat'];
                int r = Random().nextInt(255);
                int g = Random().nextInt(255);
                int b = Random().nextInt(255);
                return Container(
                  padding: const EdgeInsets.all(15),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, r, g, b),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 2,
                            offset: Offset(4, 4),
                            color: Colors.black38)
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${selisihPerBulan.abs().toStringAsFixed(2)}kg ${selisihPerBulan > 0 ? '⬆' : selisihPerBulan == 0 ? '' : '⬇'}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      Column(
                        children: valueMonth.keys
                            .map((e) => Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color.fromARGB(255, b, r, g),
                                          boxShadow: const [
                                            BoxShadow(
                                                blurRadius: 2,
                                                offset: Offset(2, 2),
                                                color: Colors.black26)
                                          ]),
                                      child: Text(
                                        e,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    getBox.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: valueMonth[e].length,
                                            itemBuilder: (context, index) {
                                              var data = valueMonth[e][index];
                                              String random = Random()
                                                  .nextInt(2846)
                                                  .toString();
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 1,
                                                ),
                                                child: ListTile(
                                                  leading: GestureDetector(
                                                    onTap: () => context
                                                        .pushTransparentRoute(
                                                      ImagePage(
                                                          imagePath:
                                                              data['image'],
                                                          tag: data['image'] +
                                                              random),
                                                      transitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                      reverseTransitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                    ),
                                                    child: AspectRatio(
                                                      aspectRatio: 1,
                                                      child: Hero(
                                                        tag: data['image'] +
                                                            random,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.file(
                                                            File(data['image']),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(data['jam']),
                                                  trailing: Text(
                                                    '${data['berat'].toStringAsFixed(2)}kg',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(),
                                  ],
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const ShowDialog(profile: false),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
