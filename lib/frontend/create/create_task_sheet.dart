import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:simplex_chapter_x/backend/models.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import '../nav/create_sheet.dart';

class CreateTaskSheet extends StatefulWidget {
  const CreateTaskSheet({Key? key}) : super(key: key);

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController name;
  late TextEditingController desc;
  late TextEditingController loc;

  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now().add(Duration(hours: 1));
  TimeOfDay _endTime =
      TimeOfDay.now().replacing(hour: (TimeOfDay.now().hour + 1) % 24);
  bool _isAllDay = false;
  String? _currentChapter;
  final Color _blueColor = Color(0xFF3B58F4);

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    desc = TextEditingController();
    loc = TextEditingController();
    _fetchCurrentChapter();
  }

  @override
  void dispose() {
    name.dispose();
    desc.dispose();
    loc.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentChapter() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userModel = await UserModel.getUserById(user.uid);
      setState(() {
        _currentChapter = userModel.currentChapter;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _currentChapter != null) {
      if (name.text.isEmpty || desc.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in name and description')),
        );
        return;
      }

      _formKey.currentState!.save();

      final startDateTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );

      final endDateTime = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chapterId: _currentChapter!,
        title: name.text,
        description: desc.text,
        dueDate: endDateTime,
        timeDue: DateFormat('h:mm a').format(endDateTime),
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
      key: scaffoldKey,
      backgroundColor: Color(0xFFF5F6F7),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(22, 35, 22, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          getCreateSheet();
                        },
                        child: Text(
                          'Cancel',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Google Sans',
                                    color: Color(0xFF3B58F4),
                                    fontSize: 15,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _submitForm();
                          } else {}
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Add',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Google Sans',
                                  color: Color(0xFF3B58F4),
                                  fontSize: 15,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Create Task',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Google Sans',
                                    color: Color(0xFF333333),
                                    fontSize: 32,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0x0B767676),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 200,
                                        child: TextFormField(
                                          controller: name,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'Name',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Google Sans',
                                                      color: Color(0x7F999999),
                                                      fontSize: 15,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: false,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Google Sans',
                                                color: Color(0xFF333333),
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Color(0xFFE7E7E7),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Color(0xFFE7E7E7),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 200,
                                        child: TextFormField(
                                          controller: desc,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'Description',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Google Sans',
                                                      color: Color(0x7F999999),
                                                      fontSize: 15,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: false,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Google Sans',
                                                color: Color(0xFF333333),
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0x0B767676),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 200,
                                        child: TextFormField(
                                          controller: loc,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'Location',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Google Sans',
                                                      color: Color(0x7F999999),
                                                      fontSize: 15,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: false,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Google Sans',
                                                color: Color(0xFF333333),
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Color(0xFFE7E7E7),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 12, 12, 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'All-day',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Google Sans',
                                              color: Color(0xFF333333),
                                              fontSize: 15,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                      Switch(
                                        activeColor: _blueColor,
                                        inactiveThumbColor: Colors.black,
                                        inactiveTrackColor: Color(0xFFF5F6F7),
                                        value: _isAllDay,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _isAllDay = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Color(0xFFE7E7E7),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 12, 12, 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Starts',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Google Sans',
                                              color: Color(0xFF333333),
                                              fontSize: 15,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: _startDate,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2101),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                          primary: _blueColor),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (pickedDate != null &&
                                              pickedDate != _startDate) {
                                            setState(() {
                                              _startDate = pickedDate;
                                            });
                                          }

                                          if (!_isAllDay) {
                                            final TimeOfDay? pickedTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: _startTime,
                                              initialEntryMode:
                                                  TimePickerEntryMode.input,
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.light(
                                                            primary:
                                                                _blueColor),
                                                    timePickerTheme:
                                                        TimePickerThemeData(
                                                            dayPeriodColor:
                                                                _blueColor),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            if (pickedTime != null &&
                                                pickedTime != _startTime) {
                                              setState(() {
                                                _startTime = pickedTime;
                                              });
                                            }
                                          }
                                        },
                                        child: Text(
                                          _isAllDay
                                              ? DateFormat('MMM d, yyyy')
                                                  .format(_startDate)
                                              : '${DateFormat('MMM d, yyyy').format(_startDate)} ${_startTime.format(context)}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Google Sans',
                                                color: Color(0xFF3B58F4),
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Color(0xFFE7E7E7),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 12, 12, 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Ends',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Google Sans',
                                              color: Color(0xFF333333),
                                              fontSize: 15,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: _endDate,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2101),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                          primary: _blueColor),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (pickedDate != null &&
                                              pickedDate != _endDate) {
                                            setState(() {
                                              _endDate = pickedDate;
                                            });
                                          }

                                          if (!_isAllDay) {
                                            final TimeOfDay? pickedTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: _endTime,
                                              initialEntryMode:
                                                  TimePickerEntryMode.input,
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.light(
                                                            primary:
                                                                _blueColor),
                                                    timePickerTheme:
                                                        TimePickerThemeData(
                                                            dayPeriodColor:
                                                                _blueColor),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            if (pickedTime != null &&
                                                pickedTime != _endTime) {
                                              setState(() {
                                                _endTime = pickedTime;
                                              });
                                            }
                                          }
                                        },
                                        child: Text(
                                          _isAllDay
                                              ? DateFormat('MMM d, yyyy')
                                                  .format(_endDate)
                                              : '${DateFormat('MMM d, yyyy').format(_endDate)} ${_endTime.format(context)}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Google Sans',
                                                color: Color(0xFF3B58F4),
                                                fontSize: 15,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCreateSheet() {
    Navigator.pop(context);
    CreateSheet.getCreateSheet(context);
  }
}
