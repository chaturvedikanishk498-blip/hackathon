import 'package:flutter/material.dart';
import 'login.dart';

import 'screens/teacher_notification_screen.dart';
import 'screens/mark_attendance_screen.dart';
import 'screens/meeting_requests_screen.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animController;

  static const Color primary = Color(0xFFFC5C7D);
  static const Color secondary = Color(0xFF6A82FB);
  static const Color bgColor = Color(0xFFFFF5F7);
  static const Color cardBg = Colors.white;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  _buildTodayClasses(),
                  const SizedBox(height: 22),
                  _buildStatsRow(),
                  const SizedBox(height: 22),

                  _buildSectionTitle('Teacher Action Center'),
                  const SizedBox(height: 14),
                  _buildActionCenter(),
                  const SizedBox(height: 22),

                  _buildSectionTitle('My Classes'),
                  const SizedBox(height: 14),
                  _buildClassesList(),
                  const SizedBox(height: 22),

                  _buildSectionTitle('AI Class Performance Insight ✨'),
                  const SizedBox(height: 14),
                  _buildAIInsightsCard(),
                  const SizedBox(height: 22),

                  _buildSectionTitle('At-Risk Student Detector 📉'),
                  const SizedBox(height: 14),
                  _buildAtRiskDetector(),
                  const SizedBox(height: 22),

                  _buildSectionTitle('Pending Tasks'),
                  const SizedBox(height: 14),
                  _buildPendingTasks(),
                  const SizedBox(height: 22),

                  _buildSectionTitle('Top Students'),
                  const SizedBox(height: 14),
                  _buildTopStudents(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 195,
      pinned: true,
      backgroundColor: primary,
      elevation: 0,
      leading: const SizedBox(),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TeacherNotificationsScreen(),
              ),
            );
          },
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LogInScreen()),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cast_for_education,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Science Dept.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome Back,\nMrs. Sinha! 📚',
                    style: TextStyle(
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
    );
  }

  Widget _buildTodayClasses() {
    final classes = [
      {
        'class': 'X - A',
        'subject': 'Physics',
        'startTime': const TimeOfDay(hour: 8, minute: 0),
        'endTime': const TimeOfDay(hour: 8, minute: 45),
        'students': 42,
      },
      {
        'class': 'IX - B',
        'subject': 'Chemistry',
        'startTime': const TimeOfDay(hour: 10, minute: 30),
        'endTime': const TimeOfDay(hour: 11, minute: 15),
        'students': 38,
      },
      {
        'class': 'XI - A',
        'subject': 'Physics',
        'startTime': const TimeOfDay(hour: 13, minute: 0),
        'endTime': const TimeOfDay(hour: 13, minute: 45),
        'students': 35,
      },
    ];

    bool isClassNow(TimeOfDay start, TimeOfDay end) {
      final now = TimeOfDay.now();
      final nowMinutes = now.hour * 60 + now.minute;
      final startMinutes = start.hour * 60 + start.minute;
      final endMinutes = end.hour * 60 + end.minute;
      return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
    }

    String formatTimeOfDay(TimeOfDay time) {
      final hour = time.hour > 12
          ? time.hour - 12
          : (time.hour == 0 ? 12 : time.hour);
      final minute = time.minute.toString().padLeft(2, '0');
      final amPm = time.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $amPm';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Today's Classes"),
        const SizedBox(height: 14),
        SizedBox(
          height: 115,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: classes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final c = classes[i];
              final start = c['startTime'] as TimeOfDay;
              final end = c['endTime'] as TimeOfDay;
              final isNow = isClassNow(start, end);
              final timeString = formatTimeOfDay(start);

              return Container(
                width: 155,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isNow
                      ? const LinearGradient(
                          colors: [primary, secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isNow ? null : cardBg,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isNow
                          ? primary.withOpacity(0.35)
                          : Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Class ${c['class']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isNow
                                ? Colors.white.withOpacity(0.85)
                                : Colors.black45,
                          ),
                        ),
                        if (isNow)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'NOW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      c['subject'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: isNow ? Colors.white : const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: isNow ? Colors.white70 : Colors.black38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeString,
                          style: TextStyle(
                            fontSize: 11,
                            color: isNow ? Colors.white70 : Colors.black45,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.people_rounded,
                          size: 12,
                          color: isNow ? Colors.white70 : Colors.black38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${c['students']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isNow ? Colors.white70 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {
        'label': 'Students',
        'value': '65',
        'icon': Icons.groups_rounded,
        'color': secondary,
      },
      {
        'label': 'Classes',
        'value': '3',
        'icon': Icons.class_rounded,
        'color': primary,
      },
      {
        'label': 'At-Risk',
        'value': '8',
        'icon': Icons.warning_amber_rounded,
        'color': const Color(0xFF11998E),
      },
    ];
    return Row(
      children: stats.map((s) {
        final color = s['color'] as Color;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(s['icon'] as IconData, color: color, size: 22),
                const SizedBox(height: 7),
                Text(
                  s['value'] as String,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s['label'] as String,
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionCenter() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF11998E).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MeetingRequestsScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11998E),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF11998E).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.handshake_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parent Meeting Requests',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Review 2 new meeting approvals',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF11998E),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassesList() {
    final classes = [
      {
        'class': 'X - A',
        'subject': 'Physics',
        'students': 42,
        'avg': 82,
        'color': primary,
      },
      {
        'class': 'IX - B',
        'subject': 'Chemistry',
        'students': 38,
        'avg': 75,
        'color': secondary,
      },
      {
        'class': 'XI - A',
        'subject': 'Physics',
        'students': 35,
        'avg': 79,
        'color': const Color(0xFF11998E),
      },
    ];
    return Column(
      children: classes.map((c) {
        final color = c['color'] as Color;
        final avg = (c['avg'] as int) / 100;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Class ${c['class']}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        c['subject'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_rounded,
                        size: 14,
                        color: Colors.black38,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${c['students']} students',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: avg,
                        minHeight: 8,
                        backgroundColor: color.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${c['avg']}% avg',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAIInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: primary.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primary, secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Class X-A Physics Trend',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Overall score dropped by 5% in the last test. AI suggests revising "Optics" before starting the next chapter.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAtRiskDetector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFC5C7D).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFC5C7D),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Action Required: 8 Students At-Risk',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFFFC5C7D),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Harsh and 7 others have attendance < 60% and declining scores. AI recommends triggering parent notifications.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFC5C7D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 36),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Notify Parents Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTasks() {
    final tasks = [
      {
        'task': 'Grade X-A Physics test papers',
        'count': '42 papers',
        'due': 'Today',
        'color': primary,
      },
      {
        'task': 'Submit IX-B attendance report',
        'count': '',
        'due': 'Tomorrow',
        'color': const Color(0xFFFF8008),
      },
      {
        'task': 'Prepare question paper for XI',
        'count': '',
        'due': 'In 3 days',
        'color': secondary,
      },
    ];
    return Column(
      children: tasks.map((t) {
        final color = t['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(Icons.task_alt_rounded, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t['task'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    if ((t['count'] ?? '').toString().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        t['count'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: color.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  t['due'] as String,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopStudents() {
    final students = [
      {'name': 'Ananya Gupta', 'score': '96%', 'class': 'X-A', 'rank': '🥇'},
      {'name': 'Rohit Kumar', 'score': '93%', 'class': 'X-A', 'rank': '🥈'},
      {'name': 'Sneha Patel', 'score': '91%', 'class': 'XI-A', 'rank': '🥉'},
    ];
    return Column(
      children: students.asMap().entries.map((e) {
        final s = e.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(s['rank']!, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: primary.withOpacity(0.15),
                child: Text(
                  s['name']![0],
                  style: const TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      'Class ${s['class']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  s['score']!,
                  style: const TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MarkAttendanceScreen()),
        );
      },
      backgroundColor: primary,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'Mark Attendance',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
      elevation: 8,
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.class_rounded, 'label': 'Classes'},
      {'icon': Icons.assignment_rounded, 'label': 'Tasks'},
      {'icon': Icons.people_rounded, 'label': 'Students'},
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.asMap().entries.map((e) {
          final idx = e.key;
          final item = e.value;
          final isSelected = _selectedIndex == idx;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = idx),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16 : 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(colors: [primary, secondary])
                    : null,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isSelected ? Colors.white : Colors.black38,
                    size: 22,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 7),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
