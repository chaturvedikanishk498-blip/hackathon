import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

// 🔹 Import New AI and Feature Files
import 'student_ai_chat.dart';
import 'study_timer_widget.dart';

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

  @override
  void initState() {
    super.initState();
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
          _buildHomeDashboard(), // Tab 0: Home Page
          _buildPlaceholderScreen("Courses Overview"), // Tab 1
          _buildPlaceholderScreen("Tasks & Homework"), // Tab 2
          _buildPlaceholderScreen("Grade Center"), // Tab 3
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      
      // 🔹 New: AI Chat Assistant Floating Button
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

  // 🔹 Modularized main scroll view for clean tab transitions
  Widget _buildHomeDashboard() {
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
                _buildTodaySchedule(),
                const SizedBox(height: 24),
                _buildStatsRow(),
                const SizedBox(height: 24),
                
                // --- 🔹 NEW AI FEATURES INJECTED HERE ---
                
                _buildSectionTitle('AI Insights ✨'),
                const SizedBox(height: 14),
                _buildAIInsightsCard(),
                const SizedBox(height: 24),

                _buildSectionTitle('Focus Mode ⏱️'),
                const SizedBox(height: 14),
                const StudyTimerWidget(), // Imported custom widget
                const SizedBox(height: 24),

                _buildSectionTitle('Smart Study Planner 📝'),
                const SizedBox(height: 14),
                _buildSmartStudyPlanner(),
                const SizedBox(height: 24),

                _buildSectionTitle('Weak Subject Detection 📉'),
                const SizedBox(height: 14),
                _buildWeakSubjectCard(),
                const SizedBox(height: 24),

                _buildSectionTitle('Current Goals 🎯'),
                const SizedBox(height: 14),
                _buildGoalTracker(),
                const SizedBox(height: 24),

                // --- 🔹 EXISTING SECTIONS ---
                
                _buildSectionTitle('Upcoming Assignments'),
                const SizedBox(height: 14),
                _buildAssignmentsList(),
                const SizedBox(height: 24),
                
                _buildSectionTitle('Recent Grades'),
                const SizedBox(height: 14),
                _buildGradesList(),
                const SizedBox(height: 24),

                // 🔹 New Smart Notifications
                _buildSectionTitle('Smart Notifications 🔔'),
                const SizedBox(height: 14),
                _buildSmartNotifications(),
                
                const SizedBox(height: 100), // Spacing for floating button
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
          onPressed: () {},
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.school, color: Colors.white, size: 14),
                              SizedBox(width: 5),
                              Text('Class X - A',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Good Morning,\nRahul! 👋',
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
      ),
    );
  }

  Widget _buildTodaySchedule() {
    final periods = [
      {'subject': 'Mathematics', 'time': '8:00 - 8:45', 'icon': '📐', 'room': 'Room 101'},
      {'subject': 'Physics', 'time': '8:50 - 9:35', 'icon': '⚛️', 'room': 'Lab 2'},
      {'subject': 'English', 'time': '9:40 - 10:25', 'icon': '📖', 'room': 'Room 203'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Today's Schedule"),
        const SizedBox(height: 14),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: periods.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final p = periods[i];
              final isNow = i == 1;
              return Container(
                width: 150,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: isNow
                      ? const LinearGradient(
                          colors: [primary, secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isNow ? null : cardBg,
                  borderRadius: BorderRadius.circular(18),
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
                        Text(p['icon']!, style: const TextStyle(fontSize: 22)),
                        if (isNow)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('NOW',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800)),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      p['subject']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isNow ? Colors.white : const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      p['time']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isNow
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black45,
                      ),
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
      {'label': 'Attendance', 'value': '94%', 'icon': Icons.check_circle_outline, 'color': const Color(0xFF11998E)},
      {'label': 'GPA', 'value': '8.7', 'icon': Icons.stars_rounded, 'color': const Color(0xFFFC5C7D)},
      {'label': 'Rank', 'value': '#3', 'icon': Icons.emoji_events_outlined, 'color': const Color(0xFFFF8008)},
    ];

    return Row(
      children: stats.map((s) {
        final color = s['color'] as Color;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 16),
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
                Icon(s['icon'] as IconData, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  s['value'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  s['label'] as String,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.black.withOpacity(0.45),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // 🔹 New: AI Performance Insights
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Great job on Physics! 🚀',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E)),
                ),
                SizedBox(height: 6),
                Text(
                  'Your recent assignments show consistent improvement in Physics. However, your Chemistry scores dropped slightly. Consider revising the Atomic Structure chapter.',
                  style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 New: Smart Study Planner
  Widget _buildSmartStudyPlanner() {
    final tasks = [
      {'task': 'Revise Chemistry Chapter 3', 'time': '30 mins', 'done': false},
      {'task': 'Complete pending History essay', 'time': '45 mins', 'done': true},
      {'task': 'Solve 10 Math problems', 'time': '20 mins', 'done': false},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: tasks.map((t) {
          final isDone = t['done'] as bool;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(
                  isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isDone ? primary : Colors.black26,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t['task'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                      color: isDone ? Colors.black45 : const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    t['time'] as String,
                    style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 🔹 New: Weak Subject Detection
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
              decoration: BoxDecoration(color: const Color(0xFFFC5C7D), shape: BoxShape.circle, boxShadow: [
                BoxShadow(color: const Color(0xFFFC5C7D).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
              ]),
              child: const Icon(Icons.trending_down_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Focus Required: Chemistry', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E))),
                  SizedBox(height: 4),
                  Text('Current average is 65%. EduAI recommends revising daily for 20 mins to improve.', style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 New: Goal Tracker (Progress Bar)
  Widget _buildGoalTracker() {
    const double progress = 0.85; // 85% towards goal
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 5))],
      ),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Color(0xFFF0F0F0),
              valueColor: AlwaysStoppedAnimation(primary),
            ),
          ),
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
      {'subject': 'History', 'task': 'Essay on Mughal Empire', 'due': 'In 5 days', 'priority': 'Low', 'color': const Color(0xFF11998E)},
    ];

    return Column(
      children: assignments.map((a) {
        final color = a['color'] as Color;
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
          child: Row(
            children: [
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a['subject'] as String,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(a['task'] as String,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(a['priority'] as String,
                        style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
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
      {'subject': 'Chemistry', 'grade': 'B+', 'marks': '82/100', 'color': const Color(0xFFFC5C7D)},
    ];

    return Column(
      children: grades.map((g) {
        final color = g['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
               Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(g['grade'] as String,
                      style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 14),
               Expanded(
                child: Text(g['subject'] as String,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF1A1A2E))),
              ),
              Text(g['marks'] as String,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black45)),
            ],
          ),
        );
      }).toList(),
    );
  }

  // 🔹 New: Smart Notifications
  Widget _buildSmartNotifications() {
    final msgs = [
      {'title': 'Math Final Exam Tomorrow', 'type': 'High', 'color': const Color(0xFFFC5C7D), 'icon': Icons.priority_high_rounded},
      {'title': 'Chemistry Lab Report Missing', 'type': 'Medium', 'color': const Color(0xFFFF8008), 'icon': Icons.assignment_late_rounded},
      {'title': 'Sports Day Registration Open', 'type': 'Low', 'color': const Color(0xFF11998E), 'icon': Icons.sports_basketball_rounded},
    ];
    
    return Column(
      children: msgs.map((m) {
        final color = m['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: Material(
             color: Colors.transparent,
             child: InkWell(
               borderRadius: BorderRadius.circular(16),
               onTap: () => HapticFeedback.selectionClick(),
               child: Padding(
                 padding: const EdgeInsets.all(16),
                 child: Row(
                   children: [
                     Container(
                       padding: const EdgeInsets.all(10),
                       decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                       child: Icon(m['icon'] as IconData, color: color, size: 20),
                     ),
                     const SizedBox(width: 14),
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                             decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                             child: Text(m['type'] as String, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                           ),
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

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.book_outlined, 'label': 'Courses'},
      {'icon': Icons.assignment_outlined, 'label': 'Tasks'},
      {'icon': Icons.bar_chart_rounded, 'label': 'Grades'},
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
                  horizontal: isSelected ? 16 : 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(colors: [primary, secondary])
                    : null,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData,
                      color: isSelected ? Colors.white : Colors.black38,
                      size: 22),
                  if (isSelected) ...[
                    const SizedBox(width: 7),
                    Text(item['label'] as String,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
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
