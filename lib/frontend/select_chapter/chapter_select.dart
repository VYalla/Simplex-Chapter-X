import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:simplex_chapter_x/frontend/select_chapter/chapter_card.dart';
import 'package:simplex_chapter_x/frontend/select_chapter/join_chapter.dart';

class ChapterSelectWidget extends StatefulWidget {
  const ChapterSelectWidget({super.key});

  @override
  State<ChapterSelectWidget> createState() => _ChapterSelectWidgetState();
}

class _ChapterSelectWidgetState extends State<ChapterSelectWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  void _selectChapter(String chapterId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      await _firestore.collection('users').doc(userId).update({
        'currentChapter': chapterId,
      });
    } else {
      print("No user is currently logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F6F7),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JoinChapterWidget()),
          );
        },
        backgroundColor: const Color(0xFF3B58F4),
        elevation: 8,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x14556EF4), Color(0x7EF5F6F7)],
                  stops: [0, 1],
                  begin: AlignmentDirectional(0, -1),
                  end: AlignmentDirectional(0, 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 65, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // REPLACE WITH SIMPLEX CHAPTER LOGO
                            Container(
                              width: 19,
                              height: 19,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF0000),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                              child: Text(
                                'Simplex Chapter',
                                style: TextStyle(
                                  fontFamily: 'Google Sans',
                                  color: Colors.black,
                                  fontSize: 15,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 46,
                          height: 46,
                          child: Stack(
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(-1, -1),
                                child: Container(
                                  width: 43,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF526BF4),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF051989),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      // REPLACE WITH USER INITIALS
                                      'AK',
                                      style: TextStyle(
                                        fontFamily: 'Google Sans',
                                        color: Colors.white,
                                        fontSize: 15,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // HANDLE POPUP FOR SIGNING OUT
                              Align(
                                alignment: const AlignmentDirectional(1, 1),
                                child: Container(
                                  width: 19,
                                  height: 19,
                                  decoration: const BoxDecoration(
                                    color: Color(0x99000000),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                // Replace w/ user name
                                'Hello Archini,',
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Google Sans',
                                  color: Colors.black,
                                  fontSize: 35,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              '👋 Welcome Back',
                              style: TextStyle(
                                fontFamily: 'Google Sans',
                                color: Colors.black,
                                fontSize: 15,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 30, 24, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          'YOUR GROUPS',
                          style: TextStyle(
                            fontFamily: 'Google Sans',
                            color: Colors.black,
                            fontSize: 20,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD90000),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // REPLACE WITH LIST OF GETTING USER'S CHAPTERS
                  ChapterCard(
                      onTap: _selectChapter,
                      clubName: "FBLA",
                      bgImg:
                          'https://firebasestorage.googleapis.com/v0/b/mad2-5df9e.appspot.com/o/454531818_520016530728357_6259979388890006873_n%20(2).png?alt=media&token=a1d8f4bd-ad26-45a1-918f-f8d2788673f2',
                      school: 'North Creek High School',
                      clubImg:
                          'https://firebasestorage.googleapis.com/v0/b/mad2-5df9e.appspot.com/o/fbla_logo.png?alt=media&token=31e40871-5a41-4b8a-ab1c-17ef5e55d4e2'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
