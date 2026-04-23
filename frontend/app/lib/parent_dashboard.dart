import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for Haptic Feedback
import 'login.dart';
// 🔹 Import the new AI Chat Screen
import 'ai_chat_screen.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _selectedChild = 0;
  late AnimationController _animController;

  // 🎨 Parent Theme: Emerald Green + Teal
  static const Color primary = Color(0xFF11998E);
  static const Color secondary = Color(0xFF38EF7D);
  static const Color bgColor = Color(0xFFECFDF5);
  static const Color cardBg = Colors.white;

  final List<Map<String, dynamic>> _children = [
    {'name': 'Priya Sharma', 'class': 'Class X - A', 'emoji': '👧', 'attendance': 94, 'gpa': 8.7},
    // 🔹 Lowered Arjun's attendance to 72% to trigger the Smart Alert UI
    {'name': 'Arjun Sharma', 'class': 'Class VII - B', 'emoji': '👦', 'attendance': 72, 'gpa': 7.9},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
       vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = _children[_selectedChild];
    return Scaffold(
      backgroundColor: bgColor,
      // 💡 IndexedStack allows seamless switching between bottom navigation tabs without losing state
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboardContent(child), // Tab 0: Home Page
          _buildPlaceholderScreen("Child Reports & Progress"), // Tab 1: Child info
          _buildPlaceholderScreen("Fee Management Center"), // Tab 2: Fees
          _buildPlaceholderScreen("School Messages Inbox"), // Tab 3: Messages 
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      
      // 🔹 New AI Chat Button Floating on Dashboard
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AIChatScreen()));
              },
              backgroundColor: primary,
              elevation: 4,
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 26),
            )
          : null,
    );
  }

  // Wrapped the dashboard in its own modular method to facilitate tab-switching
  Widget _buildDashboardContent(Map<String, dynamic> child) {
    return CustomScrollView(
      slivers: [
        _buildHeader(child),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildChildSelector(),
                
                // 🔹 Smart Attendance Alert (Conditional based on attendance < 75)
                if ((child['attendance'] as int) < 75) ...[
                  const SizedBox(height: 22),
                  _buildSmartAttendanceAlert(child),
                ],

                const SizedBox(height: 22),
                _buildQuickStats(child),
                const SizedBox(height: 22),
                
                // 🔹 AI Insights Card
                _buildSectionTitle("AI Insights ✨"),
                const SizedBox(height: 14),
                _buildAIInsightsCard(child),
                const SizedBox(height: 22),

                // 🔹 Study Suggestions Card
                _buildSectionTitle("Study Suggestions 📚"),
                const SizedBox(height: 14),
                _buildStudySuggestionsCard(child),
                const SizedBox(height: 22),

                _buildAttendanceCard(child),
                const SizedBox(height: 22),
                _buildSectionTitle("Recent Activities"),
                const SizedBox(height: 14),
                _buildRecentActivities(),
                const SizedBox(height: 22),
                _buildSectionTitle("Fee Status"),
                const SizedBox(height: 14),
                _buildFeeCard(),
                const SizedBox(height: 22),

                // 🔹 Smart Notifications Section with Priority Tags
                _buildSectionTitle("Smart Notifications 🔔"),
                const SizedBox(height: 14),
                _buildSmartNotifications(),
                
                const SizedBox(height: 100), // Spacing for floating action button
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Map<String, dynamic> child) {
    return SliverAppBar(
      expandedHeight: 190,
      pinned: true,
      backgroundColor: primary,
      elevation: 0,
      leading: const SizedBox(),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          tooltip: 'Notifications',
          onPressed: () {
            HapticFeedback.lightImpact();
          },
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (_) => const LogInScreen()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, Color(0xFF0F7B71)],
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.family_restroom, color: Colors.white, size: 14),
                        SizedBox(width: 5),
                        Text('Parent Portal',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hello,\nRajesh Sharma! 🙏',
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

  Widget _buildChildSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Your Children'),
        const SizedBox(height: 12),
        Row(
          children: _children.asMap().entries.map((e) {
            final idx = e.key;
            final child = e.value;
            final isSelected = _selectedChild == idx;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: idx == 0 ? 8 : 0),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(colors: [primary, Color(0xFF0F7B71)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                      : null,
                  color: isSelected ? null : cardBg,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? primary.withOpacity(0.3) : Colors.black.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedChild = idx);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Text(child['emoji'], style: const TextStyle(fontSize: 26)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  child['name'].split(' ').first,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isSelected ? Colors.white : const Color(0xFF1A1A2E),
                                  ),
                                ),
                                Text(
                                  child['class'],
                                  style: TextStyle(fontSize: 11, color: isSelected ? Colors.white.withOpacity(0.8) : Colors.black45),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 🔹 New UI: Smart Attendance Alert
  Widget _buildSmartAttendanceAlert(Map<String, dynamic> child) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Action Required: Low Attendance',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFFFC5C7D)),
                ),
                const SizedBox(height: 5),
                Text(
                  '${child['name'].split(" ").first}\'s attendance dropped to ${child['attendance']}% this week. Please ensure regular attendance to maintain academic steady growth.',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E), height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic> child) {
    final stats = [
      {'label': 'Attendance', 'value': '${child['attendance']}%', 'icon': Icons.check_circle_outline, 'color': primary},
      {'label': 'GPA', 'value': '${child['gpa']}', 'icon': Icons.stars_rounded, 'color': const Color(0xFFFC5C7D)},
      {'label': 'Rank', 'value': '#3', 'icon': Icons.emoji_events_outlined, 'color': const Color(0xFFFF8008)},
    ];
    return Row(
      children: stats.map((s) {
        final color = s['color'] as Color;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 14, offset: const Offset(0, 5))],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => HapticFeedback.lightImpact(), 
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    children: [
                      Icon(s['icon'] as IconData, color: color, size: 22),
                      const SizedBox(height: 7),
                      Text(s['value'] as String, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 2),
                      Text(s['label'] as String, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 🔹 New UI: AI Insights Content Based on GPA Dynamically
  Widget _buildAIInsightsCard(Map<String, dynamic> child) {
    bool isImproving = child['gpa'] >= 8.0;
    String insightText = isImproving 
        ? 'Your child is improving in Maths & Science rapidly. Overall engagement is up by 15% this month!' 
        : '${child['name'].split(" ").first} has been struggling slightly in recent physics tests. Extra focus is suggested.';
    
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primary.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6))],
        border: Border.all(color: primary.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [primary, Color(0xFF0F7B71)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EduAI Performance Insight',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 6),
                Text(
                  insightText,
                  style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 New UI: Relevant Study Suggestions
  Widget _buildStudySuggestionsCard(Map<String, dynamic> child) {
    List<String> suggestions = (child['gpa'] >= 8.0) 
        ? ['Participate in Advanced Math prep', 'Solve 2 complex logic puzzles daily']
        : ['Focus more on Science core concepts', 'Revise daily for 1 hour extra', 'Consult with Mr. Verma for help'];

    return Column(
      children: suggestions.map((s) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                   padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(color: const Color(0xFFFF8008).withOpacity(0.12), shape: BoxShape.circle),
                   child: const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFFF8008), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(s, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1A1A2E)))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> child) {
    final pct = (child['attendance'] as int) / 100;
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: primary.withOpacity(0.1), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => HapticFeedback.lightImpact(), // View detailed attendance
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Monthly Attendance', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1A1A2E))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Text('${child['attendance']}%', style: const TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(value: pct, minHeight: 10, backgroundColor: primary.withOpacity(0.1), valueColor: const AlwaysStoppedAnimation(primary)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _attendancePill('Present', '22', primary),
                    _attendancePill('Absent', '1', const Color(0xFFFC5C7D)),
                    _attendancePill('Late', '1', const Color(0xFFFF8008)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _attendancePill(String label, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(val, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16)),
          Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    final activities = [
      {'icon': Icons.assignment_turned_in_rounded, 'text': 'Submitted Maths Assignment', 'time': '2h ago', 'color': primary},
      {'icon': Icons.star_rounded, 'text': 'Got A+ in Science Test', 'time': 'Yesterday', 'color': const Color(0xFFFF8008)},
      {'icon': Icons.warning_amber_rounded, 'text': 'Late arrival noted', 'time': '2 days ago', 'color': const Color(0xFFFC5C7D)},
    ];
    return Column(
      children: activities.map((a) {
        final color = a['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => HapticFeedback.lightImpact(),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(a['icon'] as IconData, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(a['text'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A1A2E)))),
                    Text(a['time'] as String, style: const TextStyle(fontSize: 11, color: Colors.black38)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tuition Fee', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text('Q3 2024-25', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: primary.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                child: const Text('PAID', style: TextStyle(color: secondary, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('₹12,500 / Quarterly', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    HapticFeedback.lightImpact();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Text('View Receipt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 New UI: Smart Notifications replacing regular messages format
  Widget _buildSmartNotifications() {
    final msgs = [
      {'title': 'Urgent: Tomorrow is a public holiday due to heavy rains', 'type': 'High', 'time': '1h ago', 'color': const Color(0xFFFC5C7D), 'icon': Icons.priority_high_rounded},
      {'title': 'Science project progress requested by Mr. Verma', 'type': 'Medium', 'time': '9:30 AM', 'color': const Color(0xFFFF8008), 'icon': Icons.assignment_rounded},
      {'title': 'School Annual monthly newsletter published', 'type': 'Low', 'time': 'Yesterday', 'color': primary, 'icon': Icons.mail_outline_rounded},
    ];
    
    return Column(
      children: msgs.map((m) {
        final color = m['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
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
                     const SizedBox(width: 12),
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                 decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                 child: Text(m['type'] as String, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                               ),
                               const Spacer(),
                               Text(m['time'] as String, style: const TextStyle(fontSize: 11, color: Colors.black38)),
                             ],
                           ),
                           const SizedBox(height: 6),
                           Text(m['title'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: const Color(0xFF1A1A2E))),
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

  // 🔹 The fully restored Top/Bottom Navigation Bar logic
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.child_care_rounded, 'label': 'Child'},
      {'icon': Icons.payment_rounded, 'label': 'Fees'},
      {'icon': Icons.message_outlined, 'label': 'Messages'},
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x12000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.asMap().entries.map((e) {
          final idx = e.key;
          final item = e.value;
          final isSelected = _selectedIndex == idx;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
               if (_selectedIndex != idx) {
                 HapticFeedback.lightImpact(); 
                 setState(() => _selectedIndex = idx);
               }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected ? const LinearGradient(colors: [primary, Color(0xFF0F7B71)]) : null,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData, color: isSelected ? Colors.white : Colors.black38, size: 24),
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