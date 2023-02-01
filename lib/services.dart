import 'dart:io';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class Storages {
  Box box = Hive.box('2023sehat');
  Box boxProfile = Hive.box('profile');

  // Future<void> putBox(List<dynamic> listData) async =>
  //     await box.put(day, listData);
  Future<void> putBox(Map valueMonth) async => await box.put(month, valueMonth);

  Future<void> putProfile(String nama, int userId, {String? path}) async {
    await boxProfile.put('nama', nama);
    await boxProfile.put('userId', userId);
    await boxProfile.put('image', path);
  }

  Map<dynamic, dynamic> get getBox => box.toMap().isNotEmpty ? box.toMap() : {};
  Map<dynamic, dynamic> get getProfile =>
      boxProfile.toMap().isNotEmpty ? boxProfile.toMap() : {};
}

class TeleBot {
  TeleDart? teledart;
  static const botToken =
      '6084131281:AAEzAoy7YtPuCYrQvb8fEm0TaLvQMLTiW2c';
  static const listUserId = [
    1304468509,
    1248566730,
  ];

  void start() async {
    final username = (await Telegram(botToken).getMe()).username;
    teledart = TeleDart(botToken, Event(username!));
    teledart!.start();
    if (teledart != null) {
      teledart!.onCommand('start').listen((message) {
        message.reply('user ID : ${message.chat.id}');
      });
      teledart!.onMessage().listen(
          (event) => event.reply('click command : \n/start = to get user ID'));
    }
  }

  Future<void> sendMessage(String text) async {
    if (teledart == null) {
      final username = (await Telegram(botToken).getMe()).username;
      teledart = TeleDart(botToken, Event(username!));
    }
    teledart!.start();
    int userId = Storages().getProfile['userId'] ?? 1000000;
    if (listUserId.contains(userId)) {
      listUserId
          .map((e) async =>
              e != userId ? await teledart!.sendMessage(e, text) : null)
          .toList();
    } else {
      await teledart!.sendMessage(listUserId[1], text);
    }
  }

  Future<void> sendPhoto(File file, String text) async {
    if (teledart == null) {
      final username = (await Telegram(botToken).getMe()).username;
      teledart = TeleDart(botToken, Event(username!));
    }
    teledart!.start();
    int userId = Storages().getProfile['userId'] ?? listUserId[1];
    if (listUserId.contains(userId)) {
      listUserId
          .map((e) async => e != userId
              ? await teledart!.sendPhoto(e, file, caption: text)
              : null)
          .toList();
    } else {
      await teledart!.sendPhoto(userId, file, caption: text);
    }
  }
}

Map<dynamic, dynamic> listData(String image, double berat) => {
      'jam': hour,
      'image': image,
      'berat': berat,
    };

String get hour => DateFormat.Hms().format(DateTime.now());
String get day => DateFormat.yMd().format(DateTime.now());
String get month => DateFormat.MMMM().format(DateTime.now());
