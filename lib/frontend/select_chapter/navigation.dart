import 'dart:io';

import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:simplex_chapter_x/app_info.dart';
import 'package:simplex_chapter_x/frontend/select_chapter/chapter_card.dart';

class Navigation extends StatefulWidget {
  final int pIndex;
  final int messagesPIndex;

  const Navigation({
    Key? key,
    required this.pIndex,
    required this.messagesPIndex,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<Navigation> createState() => _NavigationState(pIndex, messagesPIndex);
}

class _NavigationState extends State<Navigation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int pI;
  late int mPI;

  _NavigationState(
    int pIndex,
    int messagesPIndex,
  ) {
    pI = pIndex;
    mPI = messagesPIndex;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Color(0x80000000),
      systemNavigationBarContrastEnforced: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    ValueKey<int> key = const ValueKey(0);
    var bottomBarController = BottomBarWithSheetController(initialIndex: pI);
    PageController pageController = PageController(initialPage: pI);

    double height = 75.0;
    if (!kIsWeb && Platform.isIOS) {
      height += 10.0;
    }

    List<BottomBarWithSheetItem> items = [
      const BottomBarWithSheetItem(
        icon: Symbols.home,
        label: "Home",
      ),
      const BottomBarWithSheetItem(icon: Symbols.chat, label: "Messages"),
      const BottomBarWithSheetItem(
        icon: Symbols.task_alt,
        label: "Actions",
      ),
      const BottomBarWithSheetItem(
          icon: Symbols.folder_open, label: "Resources"),
    ];

    // if (AppInfo.currentUser.isExec) {
    //   items = [
    //     const BottomBarWithSheetItem(
    //       icon: Symbols.home,
    //       label: "Home",
    //     ),
    //     const BottomBarWithSheetItem(icon: Symbols.chat, label: "Messages"),
    //     const BottomBarWithSheetItem(icon: Symbols.add_circle, label: "Create"),
    //     const BottomBarWithSheetItem(
    //       icon: Symbols.task_alt,
    //       label: "Actions",
    //     ),
    //     const BottomBarWithSheetItem(
    //         icon: Symbols.folder_open, label: "Resources"),
    //   ];
    // }

    List<Widget> pages = [
      Container(),
      Container(),
      Container(),
      Container(),
    ];

    // if (AppInfo.currentUser.isExec) {
    //   pages = [
    //     Container(),
    //     Container(),
    //     Container(),
    //     Container(),
    //     Container(),
    //   ];
    // }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          for (Widget item in pages) (item),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(0), topLeft: Radius.circular(0)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(18, 0, 0, 0),
                spreadRadius: 0,
                blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
          ),
          child: BottomBarWithSheet(
            disableMainActionButton: true,
            controller: bottomBarController,
            mainActionButtonTheme: const MainActionButtonTheme(
              color: Color.fromARGB(255, 76, 56, 239),
            ),
            bottomBarTheme: BottomBarTheme(
              heightOpened: 630,
              heightClosed: height,
              mainButtonPosition: MainButtonPosition.middle,
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              itemIconColor: const Color.fromARGB(255, 159, 159, 159),
              itemIconSize: 22,
              selectedItemIconSize: 26,
              itemTextStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 159, 159, 159),
                fontSize: 10.0,
              ),
              selectedItemTextStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 12.0,
              ),
              selectedItemIconColor: const Color.fromARGB(255, 0, 0, 0),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(241, 244, 248, 1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
            ),
            onSelectItem: (index) {
              key = ValueKey(index);
              pageController.jumpToPage(index);
            },
            items: items,
          ),
        ),
      ),
    );
  }
}
