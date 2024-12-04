import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:simplex_chapter_x/frontend/login/auth_service.dart';
import 'package:simplex_chapter_x/frontend/login/create_account.dart';
import 'package:simplex_chapter_x/frontend/select_chapter/chapter_select.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:simplex_chapter_x/app_info.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService();
  bool viewPassword = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // variables
  String email = "";
  String password = "";

  bool isSigningIn = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle(context);
      if (userCredential != null && mounted) {
        await AppInfo.loadData();
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const ChapterSelectWidget(),
          ));
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign in with Google')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing in with Google: $e')),
        );
      }
    }
  }

  Future<void> _signInWithApple() async {
    final userCredential = await _authService.signInWithApple();
    if (userCredential != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return const ChapterSelectWidget();
        },
      ));
      print('Signed in with Apple: ${userCredential.user!.email}');
    }
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
              Stack(
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 266,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.asset(
                            'assets/images/login_bg.png',
                          ).image,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24, 65, 24, 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 42, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: Image.asset(
                                      // REPLACE WITH SIELIFY CHAPTER LOGO
                                      'assets/images/appicon_trans.png',
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  AutoSizeText(
                                    'Simplex Chapter',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'Google Sans',
                                      color: Colors.white,
                                      fontSize: 30,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 251, 0, 0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F6F7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 31, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                      fontFamily: 'Google Sans',
                                      color: Color(0xFF3B58F4),
                                      fontSize: 24,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              24, 0, 24, 0),
                                      child: TextFormField(
                                        controller: emailController,
                                        onChanged: (value) {
                                          email = value;
                                        },
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Email',
                                          hintStyle: const TextStyle(
                                            fontFamily: 'Google Sans',
                                            color: Color(0xFFC7C7C7),
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEF),
                                              width: 0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEF),
                                              width: 0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEF),
                                              width: 0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEF),
                                              width: 0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFEEEEEF),
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(18, 15, 18, 15),
                                        ),
                                        style: const TextStyle(
                                          fontFamily: 'Google Sans',
                                          color: Color(0xFF333333),
                                          fontSize: 18,
                                          letterSpacing: 0.0,
                                        ),
                                        cursorColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              24, 0, 24, 0),
                                      child: TextFormField(
                                        controller: passwordController,
                                        onChanged: (value) {
                                          password = value;
                                        },
                                        autofocus: false,
                                        obscureText: !viewPassword,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Password',
                                          hintStyle: const TextStyle(
                                            fontFamily: 'Google Sans',
                                            color: Color(0xFFC7C7C7),
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEF),
                                              width: 0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEF),
                                              width: 0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEF),
                                              width: 0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color(0xFFEEEEEF),
                                              width: 0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFEEEEEF),
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(18, 15, 18, 15),
                                          suffixIcon: InkWell(
                                            onTap: () => setState(() {
                                              viewPassword = !viewPassword;
                                            }),
                                            focusNode:
                                                FocusNode(skipTraversal: true),
                                            child: Icon(
                                              viewPassword
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: const Color(0xFFC7C7C7),
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontFamily: 'Google Sans',
                                          color: Color(0xFF333333),
                                          fontSize: 18,
                                          letterSpacing: 0.0,
                                        ),
                                        cursorColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 18, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontFamily: 'Google Sans',
                                      color: Color(0xFF868686),
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 24, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if (!isSigningIn) {
                                          try {
                                            await _auth
                                                .signInWithEmailAndPassword(
                                              email: email,
                                              password: password,
                                            );

                                            try {
                                              setState(() {
                                                isSigningIn = true;
                                              });
                                              await AppInfo.loadData();
                                            } catch (e) {
                                              // Navigator.pushAndRemoveUntil(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const ErrorPage()),
                                              //   (route) =>
                                              //       false, // This condition removes all previous routes
                                              // );
                                              print(
                                                  "-------------------------------------------\n" +
                                                      "Erorr: " +
                                                      e.toString());
                                              Fluttertoast.showToast(
                                                msg: "Error",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }

                                            if (AppInfo.currentUser.email ==
                                                    "mahiremran1@gmail.com" ||
                                                AppInfo.currentUser.email ==
                                                    "ibarnes@nsd.org" ||
                                                AppInfo.currentUser.email ==
                                                    "thuesch@nsd.org") {
                                              AppInfo.isAdmin = true;
                                            }

                                            if (AppInfo.currentUser.approved &&
                                                AppInfo.currentUser
                                                    .openedAppSinceApproved) {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ChapterSelectWidget()),
                                                (route) =>
                                                    false, // This condition removes all previous routes
                                              );
                                            } else if (AppInfo
                                                    .currentUser.approved &&
                                                !AppInfo.currentUser
                                                    .openedAppSinceApproved) {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ChapterSelectWidget()),
                                                (route) =>
                                                    false, // This condition removes all previous routes
                                              );
                                            } else {
                                              // Navigator.pushAndRemoveUntil(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           ApprovalWaitPage(
                                              //             uid: AppInfo.currentUser.id,
                                              //           )),
                                              //   (route) =>
                                              //       false, // This condition removes all previous routes
                                              // );
                                              Fluttertoast.showToast(
                                                msg: "Waiting for approval",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }

                                            // Successfully signed in
                                          } catch (e) {
                                            if (e is FirebaseAuthException) {
                                              switch (e.code) {
                                                case 'invalid-email':
                                                  // Handle invalid email address format
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Error: Email is invalid. Did you make a typo?",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                  break;
                                                case 'user-not-found':
                                                  // Handle when the user does not exist
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Error: User not found. Make a new account.",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                  break;
                                                case 'wrong-password':
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Error: Incorrect password.",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );

                                                  break;
                                                case 'user-disabled':
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Error: User account is disabled.",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );

                                                  break;
                                                default:
                                                  // Handle other Firebase Authentication errors

                                                  break;
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "other error",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  textColor: Colors.white,
                                                  backgroundColor: Colors.red,
                                                  fontSize: 16);
                                              // Handle other non-authentication related errors
                                            }
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 46,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF3B58F4),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              fontFamily: 'Google Sans',
                                              color: Colors.white,
                                              fontSize: 20,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 30, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Opacity(
                                      opacity: 0.2,
                                      child: Container(
                                        width: 100,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCFCFCF),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        38, 0, 38, 0),
                                    child: Text(
                                      'Or login with',
                                      style: TextStyle(
                                        fontFamily: 'Google Sans',
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Opacity(
                                      opacity: 0.2,
                                      child: Container(
                                        width: 100,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCFCFCF),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 20, 0),
                                  child: InkWell(
                                    onTap: () {
                                      // SIGN IN WITH GOOGLE
                                      _signInWithGoogle();
                                    },
                                    child: Container(
                                      width: 144,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFE0E0E0),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(0, 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: Image.asset(
                                            'assets/images/google_logo.png',
                                            width: 23,
                                            height: 23,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // SIGN IN WITH APPLE
                                    _signInWithApple();
                                  },
                                  child: Container(
                                    width: 144,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFE0E0E0),
                                        width: 0,
                                      ),
                                    ),
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Image.asset(
                                          'assets/images/apple_logo.png',
                                          width: 23,
                                          height: 23,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 50, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    textScaler:
                                        MediaQuery.of(context).textScaler,
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Don\'t have an account? ',
                                          style: TextStyle(),
                                        ),
                                        TextSpan(
                                          text: 'Register',
                                          style: const TextStyle(
                                            color: Color(0xFF3B58F4),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CreateAccountWidget()),
                                                (route) =>
                                                    false, // This condition removes all previous routes
                                              );
                                            },
                                        )
                                      ],
                                      style: const TextStyle(
                                        fontFamily: 'Google Sans',
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        letterSpacing: 0.0,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
