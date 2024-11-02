import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simplex_chapter_x/app_info.dart';
import 'package:simplex_chapter_x/backend/models.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class PacketsPage extends StatefulWidget {
  const PacketsPage({super.key});

  @override
  State<PacketsPage> createState() => _PacketsPageState();
}

class _PacketsPageState extends State<PacketsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? _currentChapter;

  @override
  void initState() {
    setState(() {
      _currentChapter = AppInfo.currentUser.currentChapter;
    });
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentChapter == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF5F6F7),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
          .collection('chapters')
          .doc(_currentChapter)
          .collection('packets')
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          
          final allPackets = (docs as List<dynamic>?)
                  ?.where((packet) => (packet.data() as Map<String, dynamic>).containsKey("title"))
                  .map((packet) => PacketModel.fromDocumentSnapshot(packet))
                  .toList() ??
              [];

          return Container(
            width: MediaQuery.sizeOf(context).width,
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height * 1,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6F7),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 251,
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 251,
                            decoration: BoxDecoration(
                              color:
                                  FlutterFlowTheme.of(context).secondaryBackground,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Image.asset(
                                  'assets/images/PacketsBG.png',
                                ).image,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  color: Color(0x16000000),
                                  offset: Offset(
                                    0,
                                    3,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(
                                color: Color(0xFF021633),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 251,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0x004C3339), Color(0xFF4C3339)],
                                stops: [0, 1],
                                begin: AlignmentDirectional(0, -1),
                                end: AlignmentDirectional(0, 1),
                              ),
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(
                                width: 0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(22, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 65, 22, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(0, 0),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Packets',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Google Sans',
                                                  color: Colors.white,
                                                  fontSize: 35,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts: false,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 5, 0, 20),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Explore external links for information!',
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Google Sans',
                                                    color: Color(0xFFFFE7EC),
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: false,
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(22, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'ALL PACKETS',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Google Sans',
                                      fontSize: 20,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Divider(
                          height: 0,
                          thickness: 1.5,
                          color: Color(0xFFEDEEEF),
                        ),
                        allPackets.isEmpty
                          ? const Center(child: Text('No packets available'))
                          : Column(
                              children: allPackets
                                  .map((packet) => _buildPacketItem(packet))
                                  .toList(),
                        ),
                        Divider(
                          height: 0,
                          thickness: 1.5,
                          color: Color(0xFFEDEEEF),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      )
    );
  }

  Widget _buildPacketItem(PacketModel packet) {
    return InkWell(
      onTap: () {
        _launchURL(packet.url);
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: Color(int.parse(packet.color, radix: 16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:
                  EdgeInsetsDirectional.fromSTEB(22, 15, 22, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [Text(
                    packet.title,
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                          fontFamily: 'Google Sans',
                          color: Color(0xFF333333),
                          fontSize: 15,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: false,
                        ),
                    ),
                    Text(packet.description,
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                          fontFamily: 'Google Sans',
                          color: Color.fromARGB(255, 99, 99, 99),
                          fontSize: 15,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w300,
                          useGoogleFonts: false,
                        ),
                    )],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_forever_sharp,
                      color: Color(0xFFD3D3D3),
                      size: 26,
                    ),
                    onPressed: () {
                      PacketModel.removePacketById(packet.id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> _launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}
}
