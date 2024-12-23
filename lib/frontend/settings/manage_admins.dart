import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simplex_chapter_x/app_info.dart';
import 'package:simplex_chapter_x/backend/models.dart';
import 'package:simplex_chapter_x/frontend/toast.dart';

import '../flutter_flow/flutter_flow_theme.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ManageAdminsWidget extends StatefulWidget {
  const ManageAdminsWidget({super.key});

  @override
  State<ManageAdminsWidget> createState() => _ManageAdminsWidgetState();
}

class _ManageAdminsWidgetState extends State<ManageAdminsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode f = FocusNode();
  TextEditingController search = TextEditingController();
  bool dataLoaded = false;
  List<UserModel> users = [];
  List<String> execIds = [];
  String owner = "";

  _ManageAdminsWidgetState() {
    _loadData();
  }

  void _loadData() async {
    DocumentSnapshot value = await FirebaseFirestore.instance
        .collection('chapters')
        .doc(AppInfo.currentUser.currentChapter)
        .get();

    execIds = (value.get('exec') as List).cast<String>();
    List<String> userIds = (value.get('users') as List).cast<String>();
    owner = value.get('owner') as String;
    final List<DocumentSnapshot> results = [];
    for (int i = 0; i < userIds.length; i += 10) {
      final chunk =
          userIds.sublist(i, i + 10 > userIds.length ? userIds.length : i + 10);
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll(querySnapshot.docs);
    }
    for (DocumentSnapshot d in results) {
      users.add(UserModel.fromDocumentSnapshot(d));
    }
    users.sort(
      (a, b) {
        return a.name.compareTo(b.name);
      },
    );
    dataLoaded = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    f.dispose();
    search.dispose();
    super.dispose();
  }

  List<Widget> getWidgetsFromSearch() {
    String txt = search.text;
    List<Widget> items = [];
    Iterable<UserModel> newUsers;
    if (txt.isNotEmpty) {
      newUsers = users.where(
        (element) {
          return element.name.toLowerCase().startsWith(txt.toLowerCase());
        },
      );
    } else {
      newUsers = users;
    }

    for (UserModel u in newUsers) {
      List<String> firstLast = u.name.split(' ');
      String initials = firstLast[0][0] + firstLast[1][0];
      items.addAll([
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 18, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 7, 0),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Text(
                            initials,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Google Sans',
                                  color: Colors.white,
                                  fontSize: 11,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: AutoSizeText(
                        u.name,
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Google Sans',
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              execIds.contains(u.id)
                  ? InkWell(
                      onTap: () async {
                        if (u.id != owner) {
                          await FirebaseFirestore.instance
                              .collection('chapters')
                              .doc(AppInfo.currentUser.currentChapter)
                              .update({
                            'exec': FieldValue.arrayRemove([u.id])
                          });
                          execIds.remove(u.id);
                          Toasts.toast("Admin removed!", false);
                          setState(() {});
                        } else {
                          Toasts.toast(
                              "Cannot remove admin privileges from the owner.",
                              true);
                        }
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0x78710101),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                      ))
                  : InkWell(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('chapters')
                            .doc(AppInfo.currentUser.currentChapter)
                            .update({
                          'exec': FieldValue.arrayUnion([u.id])
                        });
                        execIds.add(u.id);
                        Toasts.toast("Admin added!", false);
                        setState(() {});
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0x78017106),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      )),
            ],
          ),
        ),
        const Divider(
          thickness: 1.5,
          color: Color(0x5BA7A7A7),
        ),
      ]);
    }

    if (items.isEmpty) {
      items.add(Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 18, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: AutoSizeText(
                        'No users found with the inputted search query.',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Google Sans',
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F6F7),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height,
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
                                  'Manage Admins',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Google Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 32,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0x5F000000),
                                shape: BoxShape.circle,
                              ),
                              child: const Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                      child: dataLoaded
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F1F1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 15, 0, 12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(15, 0, 0, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'User List',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Google Sans',
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        useGoogleFonts: false,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(15, 0, 15, 0),
                                            child: TextFormField(
                                              onChanged: (val) {
                                                setState(() {});
                                              },
                                              controller: search,
                                              focusNode: f,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                hintText: 'Search...',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Google Sans',
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFE7E7E7),
                                                prefixIcon: const Icon(
                                                  Icons.search_sharp,
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Google Sans',
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                              cursorColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1.5,
                                            color: Color(0x5BA7A7A7),
                                          ),
                                          for (Widget item
                                              in getWidgetsFromSearch())
                                            (item),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                  CircularProgressIndicator(color: Colors.black)
                                ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
