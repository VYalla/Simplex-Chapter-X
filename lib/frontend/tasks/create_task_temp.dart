import 'package:flutter/material.dart';
import 'package:simplex_chapter_x/backend/models.dart';
import 'package:intl/intl.dart';

class CreateTaskWidget extends StatefulWidget {
  final String chapterId;

  const CreateTaskWidget({Key? key, required this.chapterId}) : super(key: key);

  @override
  _CreateTaskWidgetState createState() => _CreateTaskWidgetState();
}

class _CreateTaskWidgetState extends State<CreateTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now();
  TimeOfDay _dueTime = TimeOfDay.now();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final dueDateTime = DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        _dueTime.hour,
        _dueTime.minute,
      );

      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chapterId: widget.chapterId,
        title: _title,
        description: _description,
        dueDate: dueDateTime,
        timeDue: DateFormat('h:mm a').format(dueDateTime),
        submissions: [],
        usersSubmitted: [],
        links: [],
        image: '',
        notes: '',
        isCompleted: false,
      );

      await TaskModel.writeTask(newTask);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a title' : null,
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a description' : null,
              onSaved: (value) => _description = value!,
            ),
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_dueDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _dueDate) {
                  setState(() {
                    _dueDate = pickedDate;
                  });
                }
              },
            ),
            ListTile(
              title: const Text('Due Time'),
              subtitle: Text(_dueTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _dueTime,
                );
                if (pickedTime != null && pickedTime != _dueTime) {
                  setState(() {
                    _dueTime = pickedTime;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
