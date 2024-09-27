import 'package:flutter/material.dart';
import 'package:simplex_chapter_x/frontend/chats/chatroom_page.dart';
import 'package:simplex_chapter_x/frontend/login/login_page.dart';
import 'package:simplex_chapter_x/frontend/nav/navigation.dart';
import 'package:simplex_chapter_x/frontend/select_chapter/chapter_select.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:simplex_chapter_x/firebase_options.dart';
import 'package:simplex_chapter_x/frontend/select_chapter/chapter_select.dart';

import 'app_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AppInfo.database = FirebaseFirestore.instance;
  AppInfo.messenger = FirebaseMessaging.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Navigation(pIndex: 0),
    );
  }
}
