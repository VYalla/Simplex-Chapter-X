import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplex_chapter_x/backend/models.dart';
import 'package:intl/intl.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class TaskLandingPageWidget extends StatefulWidget {
  final TaskModel task;
  final String chapterId;

  const TaskLandingPageWidget({
    Key? key,
    required this.task,
    required this.chapterId,
  }) : super(key: key);

  @override
  State<TaskLandingPageWidget> createState() => _TaskLandingPageWidgetState();
}

class _TaskLandingPageWidgetState extends State<TaskLandingPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isTaskSubmitted = false;

  @override
  void initState() {
    super.initState();
    checkIfTaskSubmitted();
  }

  void checkIfTaskSubmitted() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isTaskSubmitted = widget.task.usersSubmitted.contains(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F6F7),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 1,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F7),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(22, 65, 22, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.task_alt,
                              color: Color(0xFFC1AD83),
                              size: 20,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 0, 0),
                              child: Text(
                                'TASK',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Google Sans',
                                      color: const Color(0xFFC1AD83),
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever_sharp,
                            color: Color(0xFFD3D3D3),
                            size: 26,
                          ),
                          onPressed: () {
                            //IMPLEMENT THIS!!
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(22, 8, 22, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            widget.task.title,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Google Sans',
                                  color: const Color(0xFF333333),
                                  fontSize: 20,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(22, 15, 22, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECECED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 0, 15, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.edit_calendar,
                                  color: Color(0xFF999999),
                                  size: 22,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
                                  child: Text(
                                    'Add reminder', //what is this for?
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Google Sans',
                                          color: const Color(0xFF999999),
                                          fontSize: 15,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1.5,
                    color: Color(0x33CFCFCF),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(25, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0ECFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            color: Color(0xFF226ADD),
                            size: 20,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.task.timeDue,
                                style: const TextStyle(
                                  fontFamily: 'Google Sans',
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                DateFormat('EEEE, MMMM d')
                                    .format(widget.task.dueDate),
                                style: const TextStyle(
                                  fontFamily: 'Google Sans',
                                  color: Color(0xFF858585),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1.5,
                    color: Color(0x33CFCFCF),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(22, 15, 22, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            'DESCRIPTION',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Google Sans',
                                  color: const Color(0xFF333333),
                                  fontSize: 17,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(22, 6, 22, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            widget.task.description,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Google Sans',
                                  color: const Color(0xFF333333),
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
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(22, 20, 22, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            'SUBMISSIONS',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Google Sans',
                                  color: const Color(0xFF333333),
                                  fontSize: 17,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.task.submissions.isNotEmpty)
                    ...widget.task.submissions
                        .where((submission) =>
                            submission['user'] ==
                            FirebaseAuth.instance.currentUser?.uid)
                        .map((submission) {
                      return Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Divider(
                              height: 0,
                              thickness: 1.5,
                              color: Color(0xFFEDEEEF),
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F8FF),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            22, 15, 22, 15),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Icon(
                                              Icons.attachment,
                                              color: Color(0xFF4474B9),
                                              size: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(8, 0, 0, 0),
                                              child: Text(
                                                submission['text'] ??
                                                    'Attachment',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Google Sans',
                                                          color: const Color(
                                                              0xFF4474B9),
                                                          fontSize: 15,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts: false,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (!isTaskSubmitted)
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_forever_sharp,
                                              color: Color(0xFFAFC8ED),
                                              size: 22,
                                            ),
                                            onPressed: () =>
                                                _deleteAttachment(submission),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 0,
                              thickness: 1.5,
                              color: Color(0xFFEDEEEF),
                            ),
                          ],
                        ),
                      );
                    }),
                  if (!isTaskSubmitted)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(22, 15, 22, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _uploadFiles,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF226ADD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Upload File',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(22, 15, 22, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isTaskSubmitted ? null : _markAsDone,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isTaskSubmitted ? Colors.grey : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: isTaskSubmitted
                                        ? Colors.grey
                                        : const Color(0xFFF6F6F6),
                                    width: 2),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                isTaskSubmitted ? 'Submitted' : 'Submit',
                                style: TextStyle(
                                  color: isTaskSubmitted
                                      ? Colors.grey
                                      : const Color(0xFF226ADD),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadFiles() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController linkController = TextEditingController();
    bool isNameEmpty = false;
    bool isLinkEmpty = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Upload Attachment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter attachment name",
                    errorText: isNameEmpty ? "Name is required" : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      isNameEmpty = value.isEmpty;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: linkController,
                  decoration: InputDecoration(
                    hintText: "Enter attachment link",
                    errorText: isLinkEmpty ? "Link is required" : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      isLinkEmpty = value.isEmpty;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Upload'),
                onPressed: () async {
                  setState(() {
                    isNameEmpty = nameController.text.isEmpty;
                    isLinkEmpty = linkController.text.isEmpty;
                  });

                  if (!isNameEmpty && !isLinkEmpty) {
                    if (await _isValidUrl(linkController.text)) {
                      await _addAttachment(
                          nameController.text, linkController.text);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Invalid URL. Please enter a valid link.')),
                      );
                    }
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<bool> _isValidUrl(String url) async {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  Future<void> _addAttachment(String name, String link) async {
    final newSubmission = {
      'text': name,
      'pdfURL': link,
      'timestamp': DateTime.now().toIso8601String(),
      'user': FirebaseAuth.instance.currentUser?.uid ?? '',
    };

    setState(() {
      widget.task.submissions.add(newSubmission);
    });

    await TaskModel.updateTaskById(widget.chapterId, widget.task.id, {
      'submissions': widget.task.submissions,
    });
  }

  Future<void> _deleteAttachment(Map<String, String> submission) async {
    setState(() {
      widget.task.submissions.remove(submission);
    });

    await TaskModel.updateTaskById(widget.chapterId, widget.task.id, {
      'submissions': widget.task.submissions,
    });
  }

  Future<void> _markAsDone() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && widget.task.submissions.isNotEmpty) {
      await TaskModel.completeTask(
        widget.task,
        '', // submissionText
        '', // submissionImage
        '', // pdf
        DateTime.now().toIso8601String(),
        user.uid,
      );
      setState(() {
        isTaskSubmitted = true;
      });
    } else if (widget.task.submissions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please attach at least one file before submitting.')),
      );
    }
  }
}
