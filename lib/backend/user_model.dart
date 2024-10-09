part of 'models.dart';

/// [UserModel] encapsulates fields of a Firebase User Document found in the 'users' Collection
/// It also contains many helpful static methods for user-related databse operations
///
/// Instantiate [UserModel] using a [DocumentSnapshot] with [UserModel.fromDocumentSnapshot] to easily
/// read fields from the document. When an update to the document is required, use [toMap] to
/// quickly transform the object into a [Map] and then write to the [DocumentReference]
class UserModel {
  /// the user's unique id
  final String id;

  /// the user's email
  final String email;

  /// link to user's profile picutre image
  final String profilePic;

  /// the username
  final String name;

  /// list of names of past events
  final List<String> pastEvents;

  /// list of names of current competitive events user is in
  final List<String> compEvents;

  /// grade of the user
  final int grade;

  /// whether or not the user's account has been approved
  final bool approved;

  /// whether or not tutorial has been displayed
  final bool openedAppSinceApproved;

  /// whether or not the user is an exec officer
  final bool isExec;

  String currentChapter;
  final List<String> chapters;

  UserModel({
    required this.id,
    required this.email,
    required this.profilePic,
    required this.name,
    required this.pastEvents,
    required this.compEvents,
    required this.grade,
    required this.isExec,
    required this.approved,
    required this.openedAppSinceApproved,
    required this.currentChapter,
    required this.chapters,
  });

  /// Utility constructor to easily make a [UserModel] from a [DocumentSnapshot]
  ///
  /// Queries the [DocumentSnapshot] for each field and instantiates [UserModel] accordingly
  UserModel.fromDocumentSnapshot(DocumentSnapshot<Object?> doc)
      : id = doc.id,
        email = doc.get('email') as String,
        currentChapter = doc.get('currentChapter') as String,
        profilePic = doc.get('profilePic') as String,
        name = doc.get('name') as String,
        pastEvents = (doc.get('pastEvents') as List).cast<String>(),
        compEvents = (doc.get('compEvents') as List).cast<String>(),
        grade = doc.get('grade') as int,
        isExec = doc.get('isExec') as bool,
        approved = doc.get('approved') as bool,
        chapters = (doc.get('chapters') as List).cast<String>(),
        openedAppSinceApproved = doc.get('openedAppSinceApproved') as bool;

  /// Utility method to easily make a [Map] from [UserModel]
  ///
  /// Invoke [toMap] when writing a [UserModel] object to a user's Firebase Document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'profilePic': profilePic,
      'name': name,
      'pastEvents': pastEvents,
      'compEvents': compEvents,
      'grade': grade,
      'isExec': isExec,
      'approved': approved,
      'chapters': chapters,
      'openedAppSinceApproved': openedAppSinceApproved,
      'currentChapter': currentChapter,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      profilePic: map['profilePic'],
      name: map['name'],
      pastEvents: map['pastEvents'],
      compEvents: map['compEvents'],
      grade: map['grade'],
      isExec: map['isExec'],
      approved: map['approved'],
      openedAppSinceApproved: map['openedAppSinceApproved'],
      currentChapter: map['currentChapter'],
      chapters: map['chapters'],
    );
  }

  /// Writes [UserModel] object to the database
  ///
  /// All fields will be replaced!
  static Future<void> writeUser(UserModel user) async {
    AppInfo.database.collection('users').doc(user.id).set(user.toMap());
  }

  static Future<void> addChapter(UserModel user, String chapterID) async {
    AppInfo.database.collection("users").doc(user.id).update({
  'chapters': FieldValue.arrayUnion([chapterID])});
  }

  /// Updates the user specified by the provided [id] with the updates
  ///
  /// Firebase will merge the target data with the incoming data
  static Future<void> updateUserById(
      String id, Map<String, dynamic> updates) async {
    AppInfo.database.collection('users').doc(id).set(updates);
  }

  /// **⚠️UNDER CONTSTRUCTION⚠️**
  /// deletes the user with the provided [userId] from the database
  ///
  /// Currently, this has the collections hard-coded. Needs
  /// to be generalized for multi-chapter usage
  static void deleteUserById(String userId) {
    AppInfo.database.collection('users').doc(userId).delete();
    AppInfo.database
        .collection('chatrooms')
        .doc("${userId}1HPfOe8jKzRX6Z4R8EgtQ5OTrCy1")
        .delete();
    AppInfo.database
        .collection('chatrooms')
        .doc("${userId}45XDSFj7bLO5b622cwHxUegCQ973")
        .delete();
  }

  /// Fetches a user's data by [id] and returns a [UserModel] for easy reading
  ///
  ///
  static Future<UserModel> getUserById(String id) async {
    DocumentSnapshot userInfo =
        await AppInfo.database.collection('users').doc(id).get();
    return UserModel.fromDocumentSnapshot(userInfo);
  }

  /// Queries the database to determine if a user exists with [email]
  ///
  ///
  static Future<bool> userEmailExists(String email) async {
    QuerySnapshot currentUsers = await AppInfo.database
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return currentUsers.docs.isNotEmpty;
  }

  /// Queries the database to determine if a user exists with [name]
  ///
  ///
  static Future<bool> userNameExists(String name) async {
    QuerySnapshot currentUsers = await AppInfo.database
        .collection('users')
        .where('name', isEqualTo: name)
        .get();
    return currentUsers.docs.isNotEmpty;
  }

  /// Fetches the [List] of all users as [UserModel] objects
  ///
  ///
  static Future<List<UserModel>> getUserList() async {
    QuerySnapshot userQuery = await AppInfo.database
        .collection('users')
        .where(
          'approved',
          isEqualTo: true,
        )
        .get();
    return userQuery.docs
        .map((snapshot) => UserModel.fromDocumentSnapshot(snapshot))
        .toList();
  }

  /// Fetches the [List] of unapproved users
  ///
  ///
  static Future<List<UserModel>> getUnapprovedUsers() async {
    QuerySnapshot userQuery = await AppInfo.database
        .collection('users')
        .where(
          'approved',
          isEqualTo: false,
        )
        .get();
    return userQuery.docs
        .map((snapshot) => UserModel.fromDocumentSnapshot(snapshot))
        .toList();
  }

  /// **⚠️UNDER CONTSTRUCTION⚠️**
  /// Associated with [ChatroomModel] which itself needs to be
  /// re-implemented
  ///
  static Future<List<UserModel>> searchUsers(String search, int num) async {
    QuerySnapshot userQuery = await AppInfo.database
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: search)
        .where('name', isLessThan: '${search}z')
        .where(
          'openedAppSinceApproved',
          isEqualTo: true,
        )
        .orderBy('name')
        .limit(num)
        .get();

    return userQuery.docs
        .map((snapshot) => UserModel.fromDocumentSnapshot(snapshot))
        .toList();
  }

  /// creates a collection of [UserModel] objects using docs found in [names] lookup from the database
  ///
  ///
  static Future<List<UserModel>> getUsersFromNames(List<String> names) async {
    List<UserModel> users = [];
    for (int i = 0; i < names.length; i++) {
      QuerySnapshot usersRef = await FirebaseFirestore.instance
          .collection('users')
          .where("name", isEqualTo: names[i])
          .get();
      for (QueryDocumentSnapshot user in usersRef.docs) {
        users.add(UserModel.fromDocumentSnapshot(user));
      }
    }
    return users;
  }
}
