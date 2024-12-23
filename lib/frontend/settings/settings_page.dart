import '../../app_info.dart';
import '../flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';

import '../profile/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> firstLast = AppInfo.currentUser.name.split(' ');
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                  'Settings',
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
                          InkWell(
                            onTap: () {
                              Profile.showProfilePage(context);
                            },
                            child: Container(
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
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 25, right: 20, left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Text(
                        'Coming soon! Bringing features like dark mode, user panels, notification settings, etc!',
                        style: TextStyle(
                          color: Color(0xFFa6a6a6),
                          fontSize: 14,
                          fontFamily: 'Google Sans',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ],
                  )),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
