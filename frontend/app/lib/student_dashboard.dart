import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// 🔹 Import Firebase Auth for user detection
import 'package:firebase_auth/firebase_auth.dart';

// 🔹 Import New AI and Feature Files
import 'student_ai_chat.dart';
import 'study_timer_widget.dart';

// 🔹 Import New Screens
import 'screens/attendance_screen.dart';
import 'screens/marks_screen.dart';
import 'screens/assignments_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/profile_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _headerAnim;
  late Animation<double> _headerFade;

  // 🎨 Student Theme: Deep Purple + Indigo
  static const Color primary = Color(0xFF667EEA);
  static const Color secondary = Color(0xFF764BA2);
  static const Color bgColor = Color(0xFFF5F3FF);
  static const Color cardBg = Colors.white;

  // 🔹 Dynamic Student Data Map
  final Map<String, Map<String, dynamic>> _studentDataMap = {
    'harsh@gmail.com': {
      'name': 'Harsh',
      'class': 'Class X - A',
      'attendance': '58', // Intentionally low
      'gpa': '8.4',
      'rank': '#5',
      'weak_subject': 'Chemistry',
      'insight': 'Your recent assignments show consistent improvement in Physics. However, low attendance is an academic risk. Please attend upcoming classes regularly.',
    },
    'kanishk@gmail.com': {
      'name': 'Kanishk',
      'class': 'Class X - B',
      'attendance': '96',
      'gpa': '9.1',
      'rank': '#2',
      'weak_subject': 'Mathematics',
      'insight': 'Outstanding performance in Science! However, your Mathematics scores have slightly dropped. Focus on Calculus.',
    },
    'default': {
      'name': 'Rahul',
      'class': 'Class X - A',
      'attendance': '94',
      'gpa': '8.7',
      'rank': '#3',
      'weak_subject': 'Physics',
      'insight': 'Great job on Chemistry! 🚀 Your recent assignments show consistent improvement.',
    }
  };

  late Map<String, dynamic> _currentStudent;

  final List<Map<String, dynamic>> _studyTasks = [
    {'task': 'Revise Chemistry Ch 3', 'due': 'Today, 5:00 PM', 'priority': 'High', 'done': false, 'color': const Color(0xFFFC5C7D)},
    {'task': 'Complete History essay', 'due': 'Tomorrow, 10:00 AM', 'priority': 'Med', 'done': true, 'color': const Color(0xFFFF8008)},
    {'task': 'Solve 10 Math problems', 'due': 'Today, 8:00 PM', 'priority': 'High', 'done': false, 'color': const Color(0xFFFC5C7D)},
    {'task': 'Read Physics Ch 4', 'due': 'Friday, 4:00 PM', 'priority': 'Low', 'done': false, 'color': const Color(0xFF11998E)},
  ];

  final List<Map<String, dynamic>> _schedule = [
    {'subject': 'Mathematics', 'startTime': const TimeOfDay(hour: 8, minute: 0), 'endTime': const TimeOfDay(hour: 8, minute: 45), 'icon': '📐', 'room': 'Room 101'},
    {'subject': 'Physics', 'startTime': const TimeOfDay(hour: 8, minute: 50), 'endTime': const TimeOfDay(hour: 9, minute: 35), 'icon': '⚛️', 'room': 'Lab 2'},
    {'subject': 'English', 'startTime': const TimeOfDay(hour: 9, minute: 40), 'endTime': const TimeOfDay(hour: 10, minute: 25), 'icon': '📖', 'room': 'Room 203'},
    {'subject': 'Chemistry', 'startTime': const TimeOfDay(hour: 10, minute: 30), 'endTime': const TimeOfDay(hour: 11, minute: 15), 'icon': '🧪', 'room': 'Lab 1'},
  ];

  bool _isClassNow(TimeOfDay start, TimeOfDay end) {
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  @override
  void initState() {
    super.initState();
    
    // 🔹 Dynamically Detect Logged-In User Profile
    final email = FirebaseAuth.instance.currentUser?.email?.toLowerCase() ?? '';
    _currentStudent = _studentDataMap[email] ?? _studentDataMap['default']!;

    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut),
    );
    _headerAnim.forward();
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeDashboard(),
          _buildPlaceholderScreen("Courses Overview"),
          const AssignmentsScreen(),
          const MarksScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentAIChatScreen()));
              },
              backgroundColor: primary,
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 28),
            )
          : null,
    );
  }

  Widget _buildHomeDashboard() {
    int attendanceVal = int.tryParse(_currentStudent['attendance'].toString()) ?? 100;
    
    return CustomScrollView(
      slivers: [
        _buildSliverHeader(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildSectionHeader("Today's Schedule", onTapViewAll: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TimetableScreen()));
                }),
                const SizedBox(height: 14),
                _buildTodaySchedule(),
                
                // 🔹 Low Attendance Alert Logic
                if (attendanceVal < 75) ...[
                  const SizedBox(height: 24),
                  _buildAttendanceAlert(),
                ],
                
                const SizedBox(height: 24),
                _buildStatsRow(),
                const SizedBox(height: 24),
                _buildSectionTitle('AI Insights ✨'),
                const SizedBox(height: 14),
                _buildAIInsightsCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('Smart Study Planner 📝'),
                const SizedBox(height: 14),
                _buildSmartStudyPlanner(),
                const SizedBox(height: 24),
                _buildSectionTitle('Focus Mode ⏱️'),
                const SizedBox(height: 14),
                const StudyTimerWidget(),
                const SizedBox(height: 24),
                _buildSectionTitle('Upcoming Exams ⏰'),
                const SizedBox(height: 14),
                _buildUpcomingExams(),
                const SizedBox(height: 24),
                _buildSectionTitle('Subject Progress 📊'),
                const SizedBox(height: 14),
                _buildSubjectProgress(),
                const SizedBox(height: 24),
                _buildSectionTitle('Weak Subject Detection 📉'),
                const SizedBox(height: 14),
                _buildWeakSubjectCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('Current Goals 🎯'),
                const SizedBox(height: 14),
                _buildGoalTracker(),
                const SizedBox(height: 24),
                _buildSectionHeader('Pending Assignments', onTapViewAll: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AssignmentsScreen()));
                }),
                const SizedBox(height: 14),
                _buildAssignmentsList(),
                const SizedBox(height: 24),
                _buildSectionHeader('Recent Grades', onTapViewAll: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MarksScreen()));
                }),
                const SizedBox(height: 14),
                _buildGradesList(),
                const SizedBox(height: 24),
                _buildSectionTitle('Smart Notifications 🔔'),
                const SizedBox(height: 14),
                _buildSmartNotifications(),
                const SizedBox(height: 100), 
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: primary,
      elevation: 0,
      leading: const SizedBox(),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (_) => _buildNotificationSheet(),
            );
          },
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            // 🔹 Passing dynamic student data to ProfileScreen
            MaterialPageRoute(builder: (_) => ProfileScreen(studentData: _currentStudent)),
          ),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _headerFade,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.school, color: Colors.white, size: 14),
                              const SizedBox(width: 5),
                              Text(_currentStudent['class'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.orangeAccent, width: 1),
                          ),
                          child: const Row(
                            children: [
                              Text('🔥', style: TextStyle(fontSize: 14)),
                              SizedBox(width: 4),
                              Text('12 Day Streak', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Good Morning,\n${_currentStudent['name']}! 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Custom Attendance Warning Alert Widget
  Widget _buildAttendanceAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFC5C7D).withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFC5C7D).withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFC5C7D),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: const Color(0xFFFC5C7D).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Action Required: Low Attendance',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFFFC5C7D)),
                ),
                SizedBox(height: 5),
                Text(
                  'Attendance Alert: Your attendance is critically low. Please attend upcoming classes regularly.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1A1A2E), height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSheet() {
    final notifications = [
      {
        'title': 'Math Final Exam Tomorrow',
        'subtitle': 'Prepare well – exam at 10:00 AM',
        'color': const Color(0xFFFC5C7D),
        'icon': Icons.priority_high_rounded,
        'type': 'High',
      },
      {
        'title': 'Chemistry Lab Report Missing',
        'subtitle': 'Submit before 5:00 PM today',
        'color': const Color(0xFFFF8008),
        'icon': Icons.assignment_late_rounded,
        'type': 'Medium',
      },
      {
        'title': 'New Timetable Updated',
        'subtitle': 'Check your updated schedule',
        'color': const Color(0xFF667EEA),
        'icon': Icons.calendar_today_rounded,
        'type': 'Info',
      },
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Text(
            'Notifications 🔔',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)),
          ),
          const SizedBox(height: 16),
          ...notifications.map((n) {
            final color = n['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.25), width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(n['icon'] as IconData, color: color, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            n['type'] as String,
                            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          n['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          n['subtitle'] as String,
                          style: const TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onTapViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle(title),
        GestureDetector(
          onTap: onTapViewAll,
          child: const Text(
            "View All >",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: primary),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySchedule() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _schedule.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final p = _schedule[i];
          final start = p['startTime'] as TimeOfDay;
          final end = p['endTime'] as TimeOfDay;
          final isNow = _isClassNow(start, end);
          final timeString = '${_formatTimeOfDay(start)} - ${_formatTimeOfDay(end)}';

          return Container(
            width: 150,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: isNow
                  ? const LinearGradient(colors: [primary, secondary], begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : null,
              color: isNow ? null : cardBg,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: isNow ? primary.withOpacity(0.35) : Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p['icon'] as String, style: const TextStyle(fontSize: 22)),
                    if (isNow)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                        child: const Text('NOW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                      ),
                  ],
                ),
                const Spacer(),
                Text(p['subject'] as String, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isNow ? Colors.white : const Color(0xFF1A1A2E))),
                const SizedBox(height: 3),
                Text(timeString, style: TextStyle(fontSize: 11, color: isNow ? Colors.white.withOpacity(0.8) : Colors.black45)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'label': 'Attendance', 'value': '${_currentStudent['attendance']}%', 'icon': Icons.check_circle_outline, 'color': const Color(0xFF11998E), 'route': const AttendanceScreen()},
      {'label': 'GPA', 'value': '${_currentStudent['gpa']}', 'icon': Icons.stars_rounded, 'color': const Color(0xFFFC5C7D), 'route': const MarksScreen()},
      {'label': 'Rank', 'value': '${_currentStudent['rank']}', 'icon': Icons.emoji_events_outlined, 'color': const Color(0xFFFF8008), 'route': const MarksScreen()},
    ];

    return Row(
      children: stats.map((s) {
        final color = s['color'] as Color;
        final targetRoute = s['route'] as Widget;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(context, MaterialPageRoute(builder: (_) => targetRoute));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 14, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Icon(s['icon'] as IconData, color: color, size: 24),
                  const SizedBox(height: 8),
                  Text(s['value'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 3),
                  Text(s['label'] as String, style: TextStyle(fontSize: 11.5, color: Colors.black.withOpacity(0.45), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSmartStudyPlanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: _studyTasks.asMap().entries.map((entry) {
          final int index = entry.key;
          final t = entry.value;
          final isDone = t['done'] as bool;
          final color = t['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _studyTasks[index]['done'] = !isDone;
                    });
                  },
                  child: Icon(
                    isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    color: isDone ? primary : Colors.black26,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t['task'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                          color: isDone ? Colors.black45 : const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 13, color: Colors.black45),
                          const SizedBox(width: 4),
                          Text(t['due'] as String, style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(t['priority'] as String, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUpcomingExams() {
    final exams = [
      {'subject': 'Physics Mid-Term', 'date': 'Oct 30', 'daysLeft': '4 Days', 'color': const Color(0xFF667EEA)},
      {'subject': 'Math Final', 'date': 'Nov 12', 'daysLeft': '17 Days', 'color': const Color(0xFFFC5C7D)},
    ];

    return SizedBox(
      height: 125,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: exams.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final e = exams[i];
          final color = e['color'] as Color;
          return Container(
            width: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.04),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.event_note_rounded, color: color, size: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                      child: Text(e['daysLeft'] as String, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const Spacer(),
                Text(e['subject'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 4),
                Text('Date: ${e['date']}', style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubjectProgress() {
    final subjects = [
      {'name': 'Mathematics', 'progress': 0.85, 'color': const Color(0xFF667EEA)},
      {'name': 'Physics', 'progress': 0.60, 'color': const Color(0xFFFC5C7D)},
      {'name': 'English', 'progress': 0.90, 'color': const Color(0xFF11998E)},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: subjects.map((s) {
          final color = s['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A2E))),
                    Text('${((s['progress'] as double) * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: color)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: s['progress'] as double,
                    minHeight: 8,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAIInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primary.withOpacity(0.1), blurRadius: 18, offset: const Offset(0, 6))],
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [primary, secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.insights_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('EduAI Performance Insight', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 6),
                Text(_currentStudent['insight'] as String, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeakSubjectCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFC5C7D).withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFC5C7D).withOpacity(0.4), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFFC5C7D), shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFFFC5C7D).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]),
              child: const Icon(Icons.trending_down_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Focus Required: ${_currentStudent['weak_subject']}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 4),
                  const Text('EduAI recommends revising daily for 20 mins to improve your score.', style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalTracker() {
    const double progress = 0.85;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Score 90% in Maths Finals', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A2E))),
              Text('85%', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: primary)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(10), child: const LinearProgressIndicator(value: progress, minHeight: 10, backgroundColor: Color(0xFFF0F0F0), valueColor: AlwaysStoppedAnimation(primary))),
          const SizedBox(height: 8),
          const Text('Almost there! Keep up the practice.', style: TextStyle(fontSize: 12, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _buildAssignmentsList() {
    final assignments = [
      {'subject': 'Mathematics', 'task': 'Chapter 7 - Exercises', 'due': 'Tomorrow', 'priority': 'High', 'color': const Color(0xFFFC5C7D)},
      {'subject': 'Physics', 'task': 'Lab Report Submission', 'due': 'In 3 days', 'priority': 'Medium', 'color': const Color(0xFFFF8008)},
    ];

    return Column(
      children: assignments.map((a) {
        final color = a['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: const Offset(0, 4))]),
          child: Row(
            children: [
              Container(width: 4, height: 50, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a['subject'] as String, style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(a['task'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Text(a['priority'] as String, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700))),
                  const SizedBox(height: 5),
                  Text(a['due'] as String, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGradesList() {
    final grades = [
      {'subject': 'Mathematics', 'grade': 'A+', 'marks': '95/100', 'color': const Color(0xFF667EEA)},
      {'subject': 'Physics', 'grade': 'A', 'marks': '88/100', 'color': const Color(0xFF11998E)},
    ];

    return Column(
      children: grades.map((g) {
        final color = g['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))]),
          child: Row(
            children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)), child: Center(child: Text(g['grade'] as String, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w800)))),
              const SizedBox(width: 14),
              Expanded(child: Text(g['subject'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1A1A2E)))),
              Text(g['marks'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black45)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSmartNotifications() {
    final msgs = [
      {'title': 'Math Final Exam Tomorrow', 'type': 'High', 'color': const Color(0xFFFC5C7D), 'icon': Icons.priority_high_rounded},
      {'title': 'Chemistry Lab Report Missing', 'type': 'Medium', 'color': const Color(0xFFFF8008), 'icon': Icons.assignment_late_rounded},
    ];
    
    return Column(
      children: msgs.map((m) {
        final color = m['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.3), width: 1.5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3))]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => HapticFeedback.selectionClick(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(m['icon'] as IconData, color: color, size: 20)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(m['type'] as String, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold))),
                          const SizedBox(height: 6),
                          Text(m['title'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E), letterSpacing: -0.3));
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.book_outlined, 'label': 'Courses'},
      {'icon': Icons.assignment_outlined, 'label': 'Tasks'},
      {'icon': Icons.bar_chart_rounded, 'label': 'Grades'},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x12000000), blurRadius: 20, offset: Offset(0, -4))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.asMap().entries.map((e) {
          final idx = e.key;
          final item = e.value;
          final isSelected = _selectedIndex == idx;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _selectedIndex = idx);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 10),
              decoration: BoxDecoration(gradient: isSelected ? const LinearGradient(colors: [primary, secondary]) : null, borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData, color: isSelected ? Colors.white : Colors.black38, size: 22),
                  if (isSelected) ...[
                    const SizedBox(width: 7),
                    Text(item['label'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 60, color: primary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const Text('Coming Soon', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
