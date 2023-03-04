import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sehat/homepage.dart';
import 'package:sehat/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('2023sehat');
  await Hive.openBox('profile');
  TeleBot().start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = "Gezunt'23";
    return const MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: title),
    );
  }
}
