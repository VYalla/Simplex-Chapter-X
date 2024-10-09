import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:simplex_chapter_x/frontend/chats/chatroom_page.dart';
import 'package:simplex_chapter_x/frontend/login/create_account.dart';
import 'package:simplex_chapter_x/frontend/login/login_page.dart';
import 'package:simplex_chapter_x/frontend/nav/navigation.dart';
import 'package:simplex_chapter_x/frontend/select_chapter/chapter_select.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:simplex_chapter_x/frontend/login/login_page.dart';
import 'package:simplex_chapter_x/frontend/select_chapter/chapter_select.dart';
import 'package:simplex_chapter_x/firebase_options.dart';
import 'package:simplex_chapter_x/app_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AppInfo.database = FirebaseFirestore.instance;
  AppInfo.messenger = FirebaseMessaging.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  //need to check if fullname is valid when signing with google
                  final String? fullName = userData['name'] as String?;
                  return const ChapterSelectWidget();
                }
                return const LoginWidget();
              },
            );
          }
          return const LoginWidget();
        },
      ),
    );
  }
}
