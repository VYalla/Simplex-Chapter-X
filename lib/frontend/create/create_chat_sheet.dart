import 'package:intl/intl.dart';
import 'package:simplex_chapter_x/backend/models.dart';
import 'package:simplex_chapter_x/frontend/toast.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';

import '../nav/create_sheet.dart';

class CreateChatSheet extends StatefulWidget {
  const CreateChatSheet({super.key});

  @override
  State<CreateChatSheet> createState() => _CreateChatSheetState();
}

class _CreateChatSheetState extends State<CreateChatSheet> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController title;
  Color color = Color(0xFF8252BE);

  @override
  void initState() {
    super.initState();

    title = TextEditingController();
  }

  @override
  void dispose() {
    title.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF5F6F7),
      body: Column(
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
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Google Sans',
                              color: Color(0xFF3B58F4),
                              fontSize: 15,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                    InkWell(
                      //TODO Finish implementing rest of event generation
                      onTap: () {
                        _submitForm();
                      },
                      child: Text(
                        'Add',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Google Sans',
                              color: Color(0xFF3B58F4),
                              fontSize: 15,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: false,
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
                        'Create Chat',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: TextFormField(
                                            controller: title,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              hintText: 'Chat Group Name',
                                              hintStyle: FlutterFlowTheme.of(
                                                      context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                      ],
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
                                      'Color',
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
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Pick a color!'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ColorPicker(
                                                        pickerColor: color,
                                                        onColorChanged:
                                                            changeColor,
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        child: const Text(
                                                            'Got it'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: color,
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                            ),
                                          )),
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
    );
  }

  void _submitForm() async {
    if (title.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in name')),
      );
      return;
    }

    AnnouncementModel a = AnnouncementModel(
        id: "", chapterid: "", name: title.text, msgs: [], color: color);

    try {
      AnnouncementModel.createChat(a);
      toasts.toast("Chat Created!", false);
      getCreateSheet();
    } catch (e) {
      toasts.toast("Error", true);
    }
  }

  void getCreateSheet() {
    Navigator.pop(context);
    CreateSheet.getCreateSheet(context);
  }

  void changeColor(Color newColor) {
    setState(() => color = newColor);
  }

  String _colorToHex() {
    return '${color.value.toRadixString(16).padLeft(8, '0')}';
  }
}