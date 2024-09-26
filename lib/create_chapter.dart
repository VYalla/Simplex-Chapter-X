import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class CreateChapterPage extends StatefulWidget {
  const CreateChapterPage({super.key});

  @override
  _CreateChapterPageState createState() => _CreateChapterPageState();
}

class _CreateChapterPageState extends State<CreateChapterPage> {
  final _formKey = GlobalKey<FormState>();
  String _chapterName = '';
  bool _parentApproval = false;
  bool _enableModules = false;
  String _joinCode = '';

  @override
  void initState() {
    super.initState();
    _generateJoinCode();
  }

  void _generateJoinCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    String code = '';
    for (var i = 0; i < 6; i++) {
      code += chars[rnd.nextInt(chars.length)];
    }
    setState(() {
      _joinCode = code;
    });
  }

  Future<void> _createChapter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseFirestore.instance.collection('chapters').add({
          'name': _chapterName,
          'parentApproval': _parentApproval,
          'enableModules': _enableModules,
          'joinCode': _joinCode,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chapter created successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating chapter: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Chapter')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Chapter Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a chapter name';
                }
                return null;
              },
              onSaved: (value) => _chapterName = value!,
            ),
            SwitchListTile(
              title: const Text('Parent Approval'),
              value: _parentApproval,
              onChanged: (value) => setState(() => _parentApproval = value),
            ),
            SwitchListTile(
              title: const Text('Enable Modules'),
              value: _enableModules,
              onChanged: (value) => setState(() => _enableModules = value),
            ),
            ListTile(
              title: const Text('Join Code'),
              subtitle: Text(_joinCode),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _generateJoinCode,
              ),
            ),
            ElevatedButton(
              onPressed: _createChapter,
              child: const Text('Create Chapter'),
            ),
          ],
        ),
      ),
    );
  }
}
