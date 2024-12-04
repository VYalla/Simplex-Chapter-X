import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simplex_chapter_x/frontend/chats/chats_card.dart';

import '../../app_info.dart';
import '../../backend/models.dart';
import '../flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';

import 'chatroom_page.dart';

class ChatsWidget extends StatefulWidget {
  const ChatsWidget({super.key});

  @override
  State<ChatsWidget> createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> {
  List<String> firstLast = AppInfo.currentUser.name.split(' ');
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool dataLoaded = false;
  bool showUnsubscribed = false;
  List<AnnouncementModel> groups = [];
  StreamSubscription<DocumentSnapshot>? _streamSubscription;
  List<Widget> subscribedChats = [];
  List<Widget> unsubscribedChats = [];

  _ChatsWidgetState() {
    _setupMessageListener();
  }

  @override
  void initState() {
    super.initState();
    log(AppInfo.currentUser.isExec.toString());
  }

  void updateCards() {
    setState(() {});
  }

  void _setupMessageListener() {
    _streamSubscription = FirebaseFirestore.instance
        .collection('chapters')
        .doc(AppInfo.currentUser.currentChapter)
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        dataLoaded = false;
        setState(() {});
        AnnouncementModel.getAnnouncements(AppInfo.currentUser.currentChapter)
            .then(
          (value) {
            groups = value;
            groups.sort(
              (a, b) {
                if (a.msgs.isEmpty && b.msgs.isEmpty) {
                  return a.name.compareTo(b.name);
                } else if (a.msgs.isEmpty) {
                  return 1;
                } else if (b.msgs.isEmpty) {
                  return -1;
                } else {
                  String timestamp1 = a.msgs.last['timestamp']!;
                  String timestamp2 = b.msgs.last['timestamp']!;
                  return DateTime.parse(timestamp2)
                      .compareTo(DateTime.parse(timestamp1));
                }
              },
            );
            dataLoaded = true;
            setState(() {});
          },
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    subscribedChats = [];
    unsubscribedChats = [];
    for (AnnouncementModel a in groups) {
      if (AppInfo.currentUser.topicsSubscribed.contains(a.id)) {
        subscribedChats.add(ChatsCard(
          a: a,
          onPress: updateCards,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatroomWidget(a: a),
              ),
            );
          },
        ));
      } else {
        unsubscribedChats.add(ChatsCard(
          a: a,
          onPress: updateCards,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatroomWidget(a: a),
              ),
            );
          },
        ));
      }
    }
    List<Widget> otherItems = showUnsubscribed ? unsubscribedChats : [];
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F6F7),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 1,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F7),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 65, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 6, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Chats',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Google Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 40,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: false,
                                      ),
                                ),
                                // const Padding(
                                //   padding: EdgeInsetsDirectional.fromSTEB(
                                //       15, 0, 0, 0),
                                //   child: Icon(
                                //     Icons.help_outline,
                                //     color: Color(0xFF98989D),
                                //     size: 17,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Container(
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                              color: const Color(0xFF526BF4),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF051989),
                                width: 1,
                              ),
                            ),
                            child: Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Text(
                                firstLast[0][0] + firstLast[1][0],
                                style: const TextStyle(
                                  fontFamily: 'Google Sans',
                                  color: Colors.white,
                                  fontSize: 13,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 25, 0, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Subscribed',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Google Sans',
                            color: const Color(0xFF999999),
                            fontSize: 18,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: false,
                          ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
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
              Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: subscribedChats,
                  )),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 10, 0, 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showUnsubscribed = !showUnsubscribed;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFF999999),
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Icon(
                              !showUnsubscribed
                                  ? Icons.arrow_right
                                  : Icons.arrow_drop_down,
                              color: const Color(0xFFF5F6F7),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Unsubscribed',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Google Sans',
                              color: const Color(0xFF999999),
                              fontSize: 18,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: false,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: otherItems,
                  )),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
