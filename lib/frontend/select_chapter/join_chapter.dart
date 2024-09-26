import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class JoinChapterWidget extends StatefulWidget {
  const JoinChapterWidget({super.key});

  @override
  State<JoinChapterWidget> createState() => _JoinChapterWidgetState();
}

class _JoinChapterWidgetState extends State<JoinChapterWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController pin;

  @override
  void initState() {
    super.initState();

    pin = TextEditingController();
  }

  @override
  void dispose() {
    pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 1,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/images/join_chapter_bg.png',
            ).image,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 65, 24, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 37,
                      height: 37,
                      decoration: const BoxDecoration(
                        color: Color(0x59000000),
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
              padding: const EdgeInsetsDirectional.fromSTEB(40, 4, 40, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AutoSizeText(
                        'Enter join code:',
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
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 250,
                          child: PinCodeTextField(
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              activeColor: Colors.white,
                              inactiveColor:
                                  const Color.fromARGB(102, 255, 255, 255),
                              fieldWidth: 38,
                              borderWidth: 1,
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'Google Sans',
                              color: Colors.white,
                              fontSize: 44,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w700,
                            ),
                            controller: pin,
                            cursorWidth: 1.5,
                            cursorColor: Colors.white,
                            showCursor: true,
                            appContext: context,
                            backgroundColor: Colors.transparent,
                            length: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 40),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    color: Colors.transparent,
                    elevation: 3,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        // handle when user submits pin
                      },
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF3B58F4),
                            size: 30,
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
      ),
    );
  }
}
