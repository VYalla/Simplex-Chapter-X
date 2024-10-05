import 'package:flutter/material.dart';
import 'package:simplex_chapter_x/backend/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskDetailWidget extends StatelessWidget {
  final TaskModel task;
  final String chapterId;

  const TaskDetailWidget(
      {Key? key, required this.task, required this.chapterId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Open Task'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              //on delete
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TASK',
              style:
                  TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
            ),
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_alert),
              label: const Text('Add reminder'),
              onPressed: () {
                // add reminders
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  '${task.timeDue}\n${task.dueDate.toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'DESCRIPTION',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(task.description),
            const SizedBox(height: 16),
            const Text(
              'RESOURCES',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // link to resources
            const SizedBox(height: 16),
            const Text(
              'SUBMISSIONS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              child: Text('Upload Files'),
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white)),
              onPressed: () async {
                await _uploadFiles();
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await _markAsDone();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              child: const Text('Mark as done'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadFiles() async {
    //implement
  }

  Future<void> _markAsDone() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await TaskModel.completeTask(
        task,
        '', // submissionText
        '', // submissionImage
        '', // pdf
        DateTime.now().toIso8601String(),
        user.uid,
      );
    }
  }
}
