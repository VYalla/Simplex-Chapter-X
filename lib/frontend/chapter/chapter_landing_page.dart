import 'package:flutter/material.dart';

class ChapterLandingPage extends StatelessWidget {
  final String chapterName;

  const ChapterLandingPage({Key? key, required this.chapterName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapterName),
      ),
      body: Center(
        child: Text(
          'Welcome to $chapterName',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
