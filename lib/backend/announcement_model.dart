part of 'models.dart';

/// [AnnouncementModel] encapsulates fields of a Firebase Competitive Event Document found
/// in the 'compEvents' collection
///
/// Instantiate [AnnouncementModel] using a [DocumentSnapshot] with [AnnouncementModel.fromDocumentSnapshot] to easily
/// read fields from the document. When an update to the document is required, use [toMap] to
/// quickly transform the object into a [Map] and then write to the [DocumentReference]
class AnnouncementModel {
  /// the unique Firebase document id of this announcement
  final String id;

  /// the URL of the image associated with the announcement
  final String image;

  /// the actual message content of the announcement
  final String message;

  /// the name of the user who sent the announcement
  final String senderName;

  /// the profile picture of the user who sent the announcement
  final String senderPfp;

  /// the time when the announcement was sent.
  /// Stored UTC like so: YYYY-MM-DD HH:MM:SS.SSSSSS (microsecond precision)
  final String timeStamp;

  AnnouncementModel(
      {required this.id,
      required this.image,
      required this.message,
      required this.senderName,
      required this.senderPfp,
      required this.timeStamp});

  /// Utility constructor to easily make an [AnnouncementModel] from a [DocumentSnapshot]
  ///
  /// Queries the [DocumentSnapshot] for each field and instantiates [AnnouncementModel] accordingly
  AnnouncementModel.fromDocumentSnapshot(DocumentSnapshot<Object?> doc)
      : id = doc.id,
        image = doc.get('image') as String,
        message = doc.get('message') as String,
        senderName = doc.get('senderName') as String,
        senderPfp = doc.get('senderPfp') as String,
        timeStamp = doc.get('timeStamp') as String;

  /// Utility method to easily make a [Map] from an [AnnouncementModel]
  ///
  /// Invoke [toMap] when writing a [AnnouncementModel] object to an event document in the database
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'message': message,
      'senderName': senderName,
      'senderPfp': senderPfp,
      'timeStamp': timeStamp
    };
  }

  /// writes the [announcement] to the database
  ///
  /// This will overwrite all fields!
  static Future<void> writeAnnouncement(AnnouncementModel announcement) async {
    AppInfo.database
        .collection('announcements')
        .doc(announcement.id)
        .set(announcement.toMap());
  }

  /// updates the announcement specified by the provided [id] with the
  /// given [updates]
  ///
  /// Firebase will merge the target data with the incoming data
  static Future<void> updateAnnouncementById(
      String id, Map<String, dynamic> updates) async {
    AppInfo.database.collection('announcements').doc(id).update(updates);
  }

  /// deletes the announcement specified by the provided [id]
  ///
  ///
  static Future<void> deleteAnnouncementById(String id) async {
    AppInfo.database.collection('announcements').doc(id).delete();
  }

  /// gets an announcement specified by the provided [id] as an [AnnouncementModel]
  ///
  ///
  static Future<AnnouncementModel> getAnnouncementById(String id) async {
    DocumentSnapshot announcementQuery =
        await AppInfo.database.collection('announcements').doc(id).get();
    return AnnouncementModel.fromDocumentSnapshot(announcementQuery);
  }

  /// gets all of the sent announcements as a [List] of [AnnouncementModel]s
  ///
  ///
  static Future<List<AnnouncementModel>> getAnnouncements() async {
    QuerySnapshot announcementQuery =
        await AppInfo.database.collection('announcements').get();
    return announcementQuery.docs
        .map((snapshot) => AnnouncementModel.fromDocumentSnapshot(snapshot))
        .toList();
  }
}
