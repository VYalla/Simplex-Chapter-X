import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:simplex_chapter_x/frontend/login/login_page.dart';
import 'package:simplex_chapter_x/frontend/select_chapter/chapter_select.dart';
import 'package:simplex_chapter_x/firebase_options.dart';
import 'package:simplex_chapter_x/app_info.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString());
    log(stack.toString());
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  AppInfo.database = FirebaseFirestore.instance;
  AppInfo.messenger = FirebaseMessaging.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  MyApp({super.key});

  void initState() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadger.removeBadge();
    }
  }

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
            return FutureBuilder<void>(
              future: AppInfo.loadData(),
              builder: (context, loadSnapshot) {
                if (loadSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (loadSnapshot.hasError) {
                  return const LoginWidget();
                }

                return const ChapterSelectWidget();
              },
            );
          }
          return const LoginWidget();
        },
      ),
    );
  }
}

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterAppBadger.updateBadgeCount(1);
}
