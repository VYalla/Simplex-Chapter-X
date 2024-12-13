import 'package:flutter/material.dart';
import 'package:simplex_chapter_x/app_info.dart';
import 'package:simplex_chapter_x/frontend/profile/profile_page.dart';

class CreateScreen extends StatelessWidget {
  List<String> firstLast = AppInfo.currentUser.name.split(' ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 8.0), // Add space from the edge
            child: SizedBox(
              width: 46,
              height: 46,
              child: Stack(
                children: [
                  Align(
                    alignment: const AlignmentDirectional(-1, -1),
                    child: Container(
                      width: 43,
                      height: 43,
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
                            fontSize: 15,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(1, 1),
                    child: GestureDetector(
                      onTap: () {
                        Profile.showProfilePage(context);
                      },
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: const BoxDecoration(
                          color: Color(0x99000000),
                          shape: BoxShape.circle,
                        ),
                        child: const Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Create',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem('Packets', Icons.grid_view),
                _buildMenuItem('Channels', Icons.chat),
                _buildMenuItem('Events', Icons.event),
                _buildMenuItem('Tasks', Icons.check_box),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(54, 82, 106, 244),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF526BF4)),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF526BF4),
            ),
          ),
          onTap: () {
            //navigation
          },
        ),
      ),
    );
  }
}
