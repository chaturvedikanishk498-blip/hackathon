import 'package:flutter/material.dart';

class TeacherNotificationsScreen extends StatelessWidget {
  const TeacherNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Mock Data Covering Multiple Teacher Scenarios
    final notifications = [
      {'title': 'Parent Meeting Request', 'desc': 'Amit Verma requested a meeting regarding Rohan\'s performance.', 'type': 'Action Needed', 'time': '10 mins ago', 'color': const Color(0xFF11998E), 'icon': Icons.handshake_rounded},
      {'title': 'Attendance Pending', 'desc': 'You have not marked attendance for Class IX-B yet.', 'type': 'Reminder', 'time': '1h ago', 'color': const Color(0xFFFF8008), 'icon': Icons.access_time_rounded},
      {'title': 'Assignment Submission Alert', 'desc': '42 students have successfully submitted the Physics assignment.', 'type': 'Info', 'time': '2h ago', 'color': const Color(0xFF6A82FB), 'icon': Icons.assignment_turned_in_rounded},
      {'title': 'Low Performance Alert', 'desc': 'Harsh\'s score dropped by 15% in the recent periodic test.', 'type': 'Risk', 'time': '5h ago', 'color': const Color(0xFFFC5C7D), 'icon': Icons.trending_down_rounded},
      {'title': 'Admin Announcement', 'desc': 'Mandatory staff meeting scheduled at 3:00 PM today in the AV Room.', 'type': 'Announcement', 'time': 'Yesterday', 'color': Colors.purple, 'icon': Icons.campaign_rounded},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFFFC5C7D),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text('No urgent notifications', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                final color = n['color'] as Color;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(n['icon'] as IconData, color: color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Text(n['type'] as String, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                                Text(n['time'] as String, style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(n['title'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A2E))),
                            const SizedBox(height: 4),
                            Text(n['desc'] as String, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
