import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplex_chapter_x/app_info.dart';
import 'package:simplex_chapter_x/backend/models.dart';
import 'package:simplex_chapter_x/frontend/events/event_landing_page.dart';
import 'package:simplex_chapter_x/frontend/tasks/show_all_tasks.dart';
import 'package:simplex_chapter_x/frontend/tasks/task_landing_page.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class ShowEvents extends StatefulWidget {
  DateTime startDate;
  DateTime endDate;

  ShowEvents({
    required this.startDate,
    required this.endDate,
    Key? key
  }) : super(key: key);

  @override
  _ShowEventsState createState() => _ShowEventsState();
}

class _ShowEventsState extends State<ShowEvents> {
  String? _currentChapter;

  @override
  void initState() {
    super.initState();
    _loadCurrentChapter();
  }

  void _loadCurrentChapter() async {
    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   final userDoc = await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(user.uid)
    //       .get();
    //   setState(() {
    //     _currentChapter = userDoc.data()?['currentChapter'];
    //   });
    // }
    setState(() {
      _currentChapter = AppInfo.currentUser.currentChapter;
    });
  }

  bool dateRangesOverlap(DateTime startDate1, DateTime endDate1, DateTime startDate2, DateTime endDate2) {
    bool overlap = false;

    if (startDate1.compareTo(startDate2) > 0 && startDate1.compareTo(endDate2) < 0) {
      overlap = true;
    } else if (endDate1.compareTo(startDate2) > 0 && endDate1.compareTo(endDate2) < 0) {
      overlap = true;
    } else if (startDate1.compareTo(startDate2) < 0 && endDate1.compareTo(endDate2) > 0) {
      overlap = true;
    }

    return overlap;
  }

  List<EventModel> _filterEvents(List<EventModel> allEvents, DateTime startDate, DateTime endDate) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final now = DateTime.now();

    // Sort events by startt date
    allEvents.sort((a, b) => a.startDate.compareTo(b.startDate));

    // Filter events by range
    final filteredEvents = allEvents
        .where((event) => dateRangesOverlap(event.startDate, event.endDate, startDate, endDate))
        .toList();

    // if (filteredEvents.length >= 2) {
    //   // Return the three soonest events
    //   return filteredEvents.take(3).toList();
    // } else 
    if (filteredEvents.isNotEmpty) {
      // Return all events in that range
      return filteredEvents;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentChapter == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chapters')
          .doc(_currentChapter)
          .collection('events')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        
        final allEvents = (docs as List<dynamic>?)
                ?.map((event) => EventModel.fromDocumentSnapshot(event))
                .toList() ??
            [];

        final eventsToDisplay = _filterEvents(allEvents, widget.startDate, widget.endDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'EVENTS',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Google Sans',
                            color: const Color(0xFF333333),
                            fontSize: 18,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: false,
                          ),
                    ),
                    if (eventsToDisplay.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD90000),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            eventsToDisplay.isEmpty
                ? const Center(child: Text('No events available'))
                : Column(
                    children: eventsToDisplay
                        .map((event) => _buildEventItem(event))
                        .toList(),
                  ),
          ],
        );
      },
    );
  }

  Widget _buildEventItem(EventModel event) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            //TODO Fix Event Landing Page Widget
            builder: (context) => EventLandingPageWidget(
              event: event,
              chapterId: _currentChapter!,
            ),
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            // TODO Event types?
            color: true
                ? const Color.fromARGB(255, 208, 242, 255)
                : false
                    ? const Color(0xFFFFE5E5)
                    : const Color(0xFFEEEFEF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(17, 15, 18, 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 39,
                        height: 39,
                        decoration: BoxDecoration(
                          // TODO Event colors
                          color: true
                              ? const Color.fromARGB(255, 0, 119, 255)
                              : false
                                  ? const Color(0xFFFF6B6B)
                                  : const Color(0xFFC1AD83),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          // Event icons
                          true
                              ? Icons.calendar_month
                              : false
                                  ? Icons.warning
                                  : Icons.access_time,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 8, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // TODO event type names
                                event.eventType,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Google Sans',
                                      // TODO event colors
                                      color: true
                                          ? const Color.fromARGB(255, 5, 0, 77)
                                          : false
                                              ? const Color(0xFFFF6B6B)
                                              : const Color(0xFFC1AD83),
                                      fontSize: 12,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: false,
                                    ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                event.name,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Google Sans',
                                      color: const Color(0xFF333333),
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts: false,
                                    ),
                              ),
                              const SizedBox(height: 3),
                              Visibility(
                                visible: !event.allDay,
                                child: Text(
                                  '${_formatDate(event.startDate, event.endDate)}',
                                  style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Google Sans',
                                    // TODO color changes?
                                    color: true
                                        ? const Color.fromARGB(255, 21, 0, 138)
                                        : const Color(0xFF666666),
                                    fontSize: 12,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFC8C8C8),
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime startDate, DateTime endDate) {
    return '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')} - ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}';
  }
}
