import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class Storages {
  Box box = Hive.box('2023sehat');
  Box boxProfile = Hive.box('profile');

  Future<void> putBox(List<dynamic> listData) async =>
      await box.put(day, listData);

  Future<void> putProfile(Map<dynamic, dynamic> mapProfile) async =>
      await box.put(day, mapProfile);

  Map<dynamic, dynamic> get getBox => box.toMap().isNotEmpty
      ? box.toMap()
      : {};
  Map<dynamic, dynamic> get getProfile =>
      boxProfile.toMap().isNotEmpty ? boxProfile.toMap() : {};
}

class TeleBot {
  static TeleDart? teledart;
  static const String botToken =
      '6084131281:AAEzAoy7YtPuCYrQvb8fEm0TaLvQMLTiW2c';
  static const List<int> listUserId = [
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
    int userId = Storages().getProfile['userId'];
    if (listUserId.contains(userId)) {
      listUserId
          .map((e) async =>
              e != userId ? await teledart!.sendMessage(e, text) : null)
          .toList();
    } else {
      await teledart!.sendMessage(listUserId[0], text);
      await teledart!.sendMessage(userId, text);
    }
  }

  Future<void> sendPhoto(dynamic text) async {
    listUserId.map((e) async => await teledart!.sendPhoto(e, text)).toList();
  }
}

Map<dynamic, dynamic> listData(String image, String berat) => {
      'jam': hour,
      'image': image,
      'berat': berat,
    };
String get hour => DateFormat.Hms().format(DateTime.now());
String get day => DateFormat.yMd().format(DateTime.now());
