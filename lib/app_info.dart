import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:mad3/frontend/pages/pages.dart'
//     show firebaseMessagingBackgroundHandler;

import 'backend/models.dart';

/// TODO: this whole ugly global state thing is not going to cut it.. needs to be reimplemented
/// [AppInfo] contains statics storing singleton instances of Firebase objects, like [database], basic
///  configuration info necessary for in-app presentation, like [darkMode] and [isAdmin], and data from the database
///  like [currentEvents], [currentTasks], [currentPackets]
///
class AppInfo {
  ///
  static late FirebaseFirestore database;

  ///
  static late UserModel currentUser;

  ///
  static late ChapterModel currentChapter;

  ///
  static late List<EventModel>? currentEvents;

  ///
  static late List<TaskModel> currentTasks;

  ///
  static late List<PacketModel> currentPackets;

  ///
  static List<UserModel> userList = [];

  ///
  static bool isAdmin = false;
  static bool isExec = false;

  ///
  static bool darkMode = false;

  ///
  static String font = 'Montserrat';

  ///
  static Future<String> getVersion() async {
    DocumentSnapshot docRef = await AppInfo.database
        .collection('version')
        .doc('xNkwvDdbext00XQEtvlB')
        .get();
    return docRef.get('version') as String;
  }

  ///
  static Future<void> loadData() async {
    await getCurrentUserData().then(
      (value) {
        AppInfo.currentUser = value;
      },
    );

    if (currentUser.currentChapter != "") {
      await EventModel.getCurrentEvents().then(
        (value) {
          AppInfo.currentEvents = value;
        },
      );
      DocumentSnapshot d = await AppInfo.database
          .collection('chapters')
          .doc(currentUser.currentChapter)
          .get();
      List<String> exec = (d.get('exec') as List).cast<String>();
      AppInfo.isExec = exec.contains(currentUser.id);
    }

    await TaskModel.getCurrentTasks().then(
      (value) {
        AppInfo.currentTasks = value;
      },
    );
    await PacketModel.getPackets().then(
      (value) {
        AppInfo.currentPackets = value;
      },
    );
  }

  /// Fetches the current user's data and returns a [UserModel] for easy reading
  ///
  /// Wrapper around [getUserModelWithId]
  static Future<UserModel> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String id = user!.uid;
    return await UserModel.getUserById(id);
  }
}
