part of 'models.dart';

/// [EventModel] encapsulates fields of a Firebase Event Document found in the 'events' Collection
///
/// Instantiate [EventModel] using a [DocumentSnapshot] with [EventModel.fromDocumentSnapshot] to easily
/// read fields from the document. When an update to the document is required, use [toMap] to
/// quickly transform the object into a [Map] and then write to the [DocumentReference]
class EventModel {
  /// the event's unique Firebase document id
  final String id;

  /// the name of the event
  final String name;

  /// a short textual description of the event details
  final String description;

  /// the date of the event stored in a 'YYYY-MM-DD' format
  final String date;

  /// **⚠️ UNDER CONSTRUCTION ⚠️**
  /// How is this used??
  final String qrCode;

  /// the time of the event stored in a 'HH:MM AM' format
  final String time;

  /// the name of the location of the event
  final String location;

  /// a list of the names of the users who have attended the event
  final List<String> usersAttended;

  /// a link to an image to be displayed on the event card in the app
  final String image;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.qrCode,
    required this.time,
    required this.location,
    required this.usersAttended,
    required this.image,
  });

  /// Utility constructor to easily make an [EventModel] from a [DocumentSnapshot]
  ///
  /// Queries the [DocumentSnapshot] for each field and instantiates [EventModel] accordingly
  EventModel.fromDocumentSnapshot(DocumentSnapshot<Object?> doc)
      : id = doc.id,
        name = doc.get('name') as String,
        description = doc.get('description') as String,
        date = doc.get('date') as String,
        qrCode = doc.get('qrCode') as String,
        time = doc.get('time') as String,
        location = doc.get('location') as String,
        usersAttended = (doc.get('usersAttended') as List).cast<String>(),
        image = doc.get('image') as String;

  /// Utility method to easily make a [Map] from [EventModel]
  ///
  /// Invoke [toMap] when writing an [EventModel] object to an event document in the database
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': date,
      'qrCode': qrCode,
      'time': time,
      'location': location,
      'usersAttended': usersAttended,
      'image': image,
    };
  }

  /// Writes the provided [EventModel] object to the database
  ///
  /// Every field will be overwritten!
  static Future<void> writeEvent(EventModel event) async {
    AppInfo.database.collection('events').doc(event.id).set(event.toMap());
  }

  /// Updates the event specified by the provided [id] with [updates]
  ///
  /// Firebase will merge the target data with the provided data
  static Future<void> updateEventById(
      String id, Map<String, dynamic> updates) async {
    AppInfo.database.collection('events').doc(id).update(updates);
  }

  /// Deletes the event specified by the provided [id]
  ///
  static void removeEventById(String id) {
    AppInfo.database.collection('events').doc(id).delete();
  }

  /// Gets an event with the given [id]
  ///
  ///
  static Future<EventModel> getEventById(String id) async {
    DocumentSnapshot eventInfo =
        await AppInfo.database.collection('events').doc(id).get();
    return EventModel.fromDocumentSnapshot(eventInfo);
  }

  /// Gets a [List] of all the current events as a [EventModel] objects
  ///
  ///
  static Future<List<EventModel>> getCurrentEvents() async {
    DateTime currentDate = DateTime.now().subtract(const Duration(days: 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    QuerySnapshot eventQuery = await AppInfo.database
        .collection('events')
        .where('date', isGreaterThan: formattedDate)
        .orderBy('date')
        .get();

    return eventQuery.docs
        .map((snapshot) => EventModel.fromDocumentSnapshot(snapshot))
        .toList();
  }

  /// Gets a [List] of all past events as [EventModel] objects
  ///
  ///
  static Future<List<EventModel>> getPastEvents() async {
    DateTime currentDate = DateTime.now().subtract(const Duration(days: 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    QuerySnapshot eventQuery = await AppInfo.database
        .collection('events')
        .where('date', isLessThanOrEqualTo: formattedDate)
        .orderBy('date')
        .get();

    return eventQuery.docs
        .map((snapshot) => EventModel.fromDocumentSnapshot(snapshot))
        .toList();
  }

  /// adds user by [name] to the provided [event] document in Firebase
  ///
  ///
  static Future<void> recordUserAttendance(
      EventModel event, String name) async {
    AppInfo.database.collection('events').doc(event.id).update({
      'usersAttended': FieldValue.arrayUnion([name]),
    });
  }
}
