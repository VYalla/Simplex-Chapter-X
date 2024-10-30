import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simplex_chapter_x/frontend/flutter_flow/flutter_flow_theme.dart';
import 'package:simplex_chapter_x/frontend/login/login_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Profile {
  static bool isSigningOut = false;

  static void showProfilePage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      // backgroundColor: const Color(0xFFFFFFFF),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _openUrl('https://github.com/MahirEmran/Sielify/blob/main/Sielify_Terms_and_Conditions.md'),
                      child: Text(
                        'Terms and Conditions',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          // color: const Color(0xFF3B58F4),
                          decoration: TextDecoration.underline
                        ),
                      )
                    )
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _openUrl('https://github.com/MahirEmran/Sielify/blob/main/Sielify_Privacy_Policy.md'),
                      child: Text(
                        'Privacy Policy',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          // color: const Color(0xFF3B58F4),
                          decoration: TextDecoration.underline
                        ),
                      )
                    )
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _signOut(context),
                      child: Text(
                        'Sign out',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          // color: const Color(0xFF3B58F4),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    )
                  ],
                )
              )
            ],
          )
        );
      }
    );
  }

  // Maybe make this public in the future if needed
  static _signOut(BuildContext context) async {
    if (!isSigningOut) {

      try {
        await FirebaseAuth.instance.signOut();
        if (!kIsWeb) {
          await GoogleSignIn().signOut();
        }
      } catch (e) {
        print(e);
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginWidget()
        ),
        (route) => false
      );
    }

  }

  // You should probably only use this for trusted links
  static _openUrl(String url) async {
    await launchUrlString(
      url,
      // mode: LaunchMode.externalApplication
    );
  }
}