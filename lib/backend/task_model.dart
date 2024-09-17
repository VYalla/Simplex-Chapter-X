part of 'models.dart';

/// [TaskModel] encapsulates fields of a Firebase Event Document found in the 'events' Collection
///
/// Instantiate [TaskModel] using a [DocumentSnapshot] with [TaskModel.fromDocumentSnapshot] to easily
/// read fields from the document. When an update to the document is required, use [toMap] to
/// quickly transform the object into a [Map] and then write to the [DocumentReference]
class TaskModel {
  /// the Firebase document id of this particular task
  final String id;

  /// the name of this task
  final String name;

  /// the description of this task
  final String details;

  /// date the task is due, stored in a YYYY-MM-DD format
  final String dateDue;

  /// the time the task is due, stored in an HH:MM PM format
  /// Ex: '3:41 PM'
  final String timeDue;

  /// **⚠️ UNDER CONSTRUCTION ⚠️**
  /// A list of all of the submissions
  /// This should be merged with users submitted, so [submissions] should be a
  /// [Map<String, Map<String, String>>] rather than a List<Map<String, String>>
  /// So that the map keys are users and the map values are the submission data
  final List<Map<String, String>> submissions;

  /// **⚠️ UNDER CONSTRUCTION ⚠️**
  /// See notes on above field
  final List<String> usersSubmitted;

  /// A list of the links associated with this task
  /// The first map key is the name of the link and the second map key is the
  /// URL itself
  final List<Map<String, String>> links;

  /// URL of image to be displayed with the task
  final String image;

  /// notes that show up on the tasks overview panel (details show up in the task menu itself)
  final String notes;

  TaskModel({
    required this.id,
    required this.name,
    required this.details,
    required this.dateDue,
    required this.timeDue,
    required this.submissions,
    required this.links,
    required this.image,
    required this.usersSubmitted,
    required this.notes,
  });

  /// Utility constructor to easily make a [TaskModel] from a [DocumentSnapshot]
  ///
  /// Queries the [DocumentSnapshot] for each field and instantiates [TaskModel] accordingly
  TaskModel.fromDocumentSnapshot(DocumentSnapshot<Object?> doc)
      : id = doc.id,
        name = doc.get('name') as String,
        details = doc.get('details') as String,
        dateDue = doc.get('dateDue') as String,
        timeDue = doc.get('timeDue') as String,
        submissions = (doc.get('submissions') as List<dynamic>)
            .map((submission) => Map<String, String>.from(submission))
            .toList(),
        usersSubmitted = (doc.get('usersSubmitted') as List).cast<String>(),
        links = (doc.get('links') as List<dynamic>)
            .map((link) => Map<String, String>.from(link))
            .toList(),
        image = doc.get('image') as String,
        notes = doc.get('notes') as String;

  /// Utility method to easily make a [Map] from a [TaskModel]
  ///
  /// Invoke [toMap] when writing a [TaskModel] object to a task document in the database
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'details': details,
      'dateDue': dateDue,
      'timeDue': timeDue,
      'submissions': submissions,
      'usersSubmitted': usersSubmitted,
      'links': links,
      'image': image,
      'notes': notes,
    };
  }

  /// Writes the provided [TaskModel] object to the database
  ///
  ///
  static Future<void> writeTask(TaskModel task) async {
    AppInfo.database.collection('tasks').doc(task.id).set(task.toMap());
  }

  /// Updates the specified task via [id] with the provided updates
  ///
  /// Firebase will attempt to merge the target data with the incoming data
  static Future<void> updateTaskById(
      String id, Map<String, dynamic> updates) async {
    AppInfo.database.collection('tasks').doc(id).update(updates);
  }

  /// Deletes the specified task via [id] from the database
  ///
  ///
  static void deleteTaskById(String id) {
    FirebaseFirestore.instance.collection('tasks').doc(id).delete();
  }

  /// Gets the specified task via [id] as a [TaskModel] object
  ///
  ///
  static Future<TaskModel> getTaskById(String id) async {
    DocumentSnapshot taskQuery =
        await AppInfo.database.collection('tasks').doc(id).get();
    return TaskModel.fromDocumentSnapshot(taskQuery);
  }

  /// Gets the current tasks as a [List] of [TaskModel] objects
  ///
  ///
  static Future<List<TaskModel>> getCurrentTasks() async {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    QuerySnapshot taskQuery = await AppInfo.database
        .collection('tasks')
        .where('dateDue', isGreaterThanOrEqualTo: formattedDate)
        .get();

    return taskQuery.docs
        .map((snapshot) => TaskModel.fromDocumentSnapshot(snapshot))
        .toList();
  }

  /// Gets the past tasks as a [List] of [TaskModel] objects
  ///
  ///
  static Future<List<TaskModel>> getPastTasks() async {
    DateTime currentDate = DateTime.now().subtract(const Duration(days: 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    QuerySnapshot taskQuery = await AppInfo.database
        .collection('tasks')
        .where('dateDue', isLessThanOrEqualTo: formattedDate)
        .get();
    return taskQuery.docs
        .map((snapshot) => TaskModel.fromDocumentSnapshot(snapshot))
        .toList();
  }

  /// Updates the provided [task] with the provided submission details
  ///
  ///
  static Future<void> completeTask(
      TaskModel task,
      String submissionText,
      String submissionImage,
      String pdf,
      String timestamp,
      String username) async {
    AppInfo.database.collection('tasks').doc(task.id).update({
      'usersSubmitted': FieldValue.arrayUnion([username]),
      'submissions': FieldValue.arrayUnion([
        {
          "pdfURL": pdf,
          'imageURL': submissionImage,
          "text": submissionText,
          "timestamp": timestamp,
          "user": username
        }
      ]),
    });
  }
}
