import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simplex_chapter_x/frontend/chapter/chapter_landing_page.dart';

class ChapterCard extends StatelessWidget {
  final String bgImg;
  final String school;
  final String clubImg;
  final String clubName;

  const ChapterCard(
      {Key? key,
      required this.bgImg,
      required this.school,
      required this.clubImg,
      required this.clubName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChapterLandingPage(
                      chapterName: clubName,
                    ),
                  ),
                );
              },
              child: Container(
                height: 161,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(bgImg),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                      color: Color(0x19000000),
                      offset: Offset(0, 1),
                    )
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 20, 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: CachedNetworkImage(
                                imageUrl: clubImg,
                                height: 22,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            school,
                            style: const TextStyle(
                              fontFamily: 'Google Sans',
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
