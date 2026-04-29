import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'login.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const Color primary = Color(0xFFFF8008);
  static const Color secondary = Color(0xFFFFC837);
  static const Color darkBg = Color(0xFF1A1A2E);
  static const Color cardDark = Color(0xFF16213E);
  static const Color bgColor = Color(0xFFFFF8EE);
  static const Color cardBg = Colors.white;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboardContent(), 
          _buildPlaceholderScreen('Students Management'), 
          _buildPlaceholderScreen('Analytics Center'), 
          _buildPlaceholderScreen('System Settings'), 
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDashboardContent() {
    return CustomScrollView(
      slivers: [
        _buildHeader(),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  _buildLiveStats(),
                  const SizedBox(height: 22),
                  _buildQuickActions(),
                  const SizedBox(height: 22),
                  _buildSectionTitle('School Overview'),
                  const SizedBox(height: 14),
                  _buildOverviewCards(),
                  const SizedBox(height: 22),
                  _buildSectionTitle('Department Performance'),
                  const SizedBox(height: 14),
                  _buildDeptPerformance(),
                  const SizedBox(height: 22),
                  _buildSectionTitle('Recent Alerts'),
                  const SizedBox(height: 14),
                  _buildAlerts(),
                  const SizedBox(height: 22),
                  _buildSectionTitle('Staff Overview'),
                  const SizedBox(height: 14),
                  _buildStaffCards(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 210,
      pinned: true,
      backgroundColor: darkBg,
      elevation: 0,
      leading: const SizedBox(),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF38EF7D), shape: BoxShape.circle)),
              const SizedBox(width: 5),
              const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ],
          ),
        ),
        
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
                backgroundColor: primary.withOpacity(0.3),
                child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [darkBg, cardDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Stack(
            children: [
              Positioned(top: -30, right: -30, child: Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, color: primary.withOpacity(0.1)))),
              Positioned(bottom: -20, right: 60, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: secondary.withOpacity(0.08)))),
              SafeArea(
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
                            decoration: BoxDecoration(color: primary.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.shield_rounded, color: secondary, size: 13),
                                const SizedBox(width: 5),
                                const Text('System Administrator', style: TextStyle(color: secondary, fontSize: 11, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('Control Center', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1)),
                      const SizedBox(height: 4),
                      Text('Delhi Public School • Academic Year 2024-25', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

     Widget _buildLiveStats() {
    final stats = [
      {'label': 'Present Today', 'value': '1,248', 'sub': 'of 1,320', 'icon': Icons.people_rounded, 'color': const Color(0xFF11998E)},
      {'label': 'Total Teachers', 'value': '84', 'sub': '80 present', 'icon': Icons.cast_for_education_rounded, 'color': primary},
      {'label': 'Live Classes', 'value': '32', 'sub': 'right now', 'icon': Icons.video_call_rounded, 'color': const Color(0xFF667EEA)},
      {'label': 'Pending Fees', 'value': '₹2.4L', 'sub': '18 students', 'icon': Icons.account_balance_rounded, 'color': const Color(0xFFFC5C7D)},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.85, 
      children: stats.map((s) {
        final color = s['color'] as Color;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6), 
                    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                    child: Icon(s['icon'] as IconData, color: color, size: 16), 
                  ),
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                ],
              ),
              const Spacer(),
              Text(s['value'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E), height: 1.1)),
              const SizedBox(height: 2),
              Text(s['label'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E), height: 1.1)),
              Text(s['sub'] as String, style: const TextStyle(fontSize: 9.5, color: Colors.black45, height: 1.1)),
            ],
          ),
        );
      }).toList(),
    );
  }



  Widget _buildQuickActions() {
    final actions = [
      {'label': 'Announcements', 'icon': Icons.campaign_rounded, 'color': primary},
      {'label': 'Timetable', 'icon': Icons.calendar_month_rounded, 'color': const Color(0xFF667EEA)},
      {'label': 'Fee Report', 'icon': Icons.receipt_long_rounded, 'color': const Color(0xFF11998E)},
      {'label': 'Add Staff', 'icon': Icons.person_add_rounded, 'color': const Color(0xFFFC5C7D)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Quick Actions'),
        const SizedBox(height: 14),
        Row(
          children: actions.map((a) {
            final color = a['color'] as Color;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      splashColor: color.withOpacity(0.15),
                      highlightColor: color.withOpacity(0.05),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: Text(a['label'] as String)))));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(a['icon'] as IconData, color: color, size: 22),
                            ),
                            const SizedBox(height: 8),
                            Text(a['label'] as String, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)), textAlign: TextAlign.center),
                          ],
                        ),
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

  Widget _buildOverviewCards() {
    final overviews = [
      {'title': 'Total Students', 'value': '1,320', 'change': '+24 this month', 'positive': true, 'gradient': [darkBg, cardDark], 'icon': Icons.school_rounded},
      {'title': 'Pass Rate', 'value': '94.2%', 'change': '+2.1% vs last yr', 'positive': true, 'gradient': [primary, secondary], 'icon': Icons.trending_up_rounded},
    ];

    return Row(
      children: overviews.asMap().entries.map((e) {
        final o = e.value;
        final isFirst = e.key == 0;
        final colors = o['gradient'] as List<Color>;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: isFirst ? 8 : 0),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: colors[0].withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 7))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(o['icon'] as IconData, color: Colors.white.withOpacity(0.8), size: 24),
                const SizedBox(height: 14),
                Text(o['value'] as String, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -1)),
                const SizedBox(height: 4),
                Text(o['title'] as String, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(o['positive'] as bool ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, color: const Color(0xFF38EF7D), size: 14),
                    const SizedBox(width: 4),
                    Text(o['change'] as String, style: const TextStyle(color: Color(0xFF38EF7D), fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeptPerformance() {
    final depts = [
      {'dept': 'Science', 'score': 88, 'color': const Color(0xFF667EEA)},
      {'dept': 'Mathematics', 'score': 82, 'color': primary},
      {'dept': 'Humanities', 'score': 79, 'color': const Color(0xFF11998E)},
      {'dept': 'Commerce', 'score': 75, 'color': const Color(0xFFFC5C7D)},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Column(
        children: depts.map((d) {
          final color = d['color'] as Color;
          final score = d['score'] as int;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                SizedBox(width: 85, child: Text(d['dept'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E)))),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: score / 100, minHeight: 10, backgroundColor: color.withOpacity(0.1), valueColor: AlwaysStoppedAnimation(color)))),
                const SizedBox(width: 12),
                SizedBox(width: 38, child: Text('$score%', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAlerts() {
    final alerts = [
      {'msg': '3 students absent for 5+ days', 'type': 'warning', 'time': '10 min ago'},
      {'msg': 'Server maintenance tonight', 'type': 'info', 'time': '1h ago'},
      {'msg': 'Fee collection deadline tomorrow', 'type': 'urgent', 'time': '2h ago'},
    ];

    final typeColors = {'warning': const Color(0xFFFF8008), 'info': const Color(0xFF667EEA), 'urgent': const Color(0xFFFC5C7D)};
    final typeIcons = {'warning': Icons.warning_amber_rounded, 'info': Icons.info_outline_rounded, 'urgent': Icons.error_outline_rounded};

    return Column(
      children: alerts.map((a) {
        final color = typeColors[a['type']]!;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: color.withOpacity(0.1),
              onTap: () => HapticFeedback.selectionClick(),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                      child: Icon(typeIcons[a['type']]!, color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(a['msg'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: Color(0xFF1A1A2E)))),
                    const SizedBox(width: 8),
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

  Widget _buildStaffCards() {
    final staff = [
      {'name': 'Mrs. Sinha', 'role': 'Physics HOD', 'status': 'Present', 'color': const Color(0xFF11998E)},
      {'name': 'Mr. Gupta', 'role': 'Math Teacher', 'status': 'Present', 'color': const Color(0xFF11998E)},
      {'name': 'Ms. Rao', 'role': 'English Teacher', 'status': 'On Leave', 'color': const Color(0xFFFC5C7D)},
    ];

    return Column(
      children: staff.map((s) {
        final color = s['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => HapticFeedback.selectionClick(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: primary.withOpacity(0.15), child: Text(s['name'] as String, style: const TextStyle(color: primary, fontWeight: FontWeight.w800))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A2E))),
                          Text(s['role'] as String, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(s['status'] as String, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
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
      {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
      {'icon': Icons.people_rounded, 'label': 'Students'},
      {'icon': Icons.analytics_rounded, 'label': 'Analytics'},
      {'icon': Icons.settings_rounded, 'label': 'Settings'},
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
                gradient: isSelected ? const LinearGradient(colors: [primary, secondary]) : null,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData, color: isSelected ? Colors.white : Colors.black38, size: 24),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
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
            Text('$title Screen', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: darkBg)),
            const Text('Coming Soon', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
