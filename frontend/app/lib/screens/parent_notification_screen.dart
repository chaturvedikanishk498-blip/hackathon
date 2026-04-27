import 'package:flutter/material.dart';

class ParentNotificationsScreen extends StatelessWidget {
  const ParentNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Comprehensive mock notifications covering multiple hackathon scenarios
    final notifications = [
      {'title': 'CRITICAL: Risk alert due to low attendance', 'desc': 'Attendance is currently at 55%. Immediate intervention required to prevent academic drop.', 'type': 'Urgent', 'time': '1h ago', 'color': const Color(0xFFFC5C7D), 'icon': Icons.warning_rounded},
      {'title': 'Assignment Pending', 'desc': 'Mathematics Chapter 5 assignment is due tomorrow. Please ensure it is completed.', 'type': 'Reminder', 'time': '3h ago', 'color': const Color(0xFFFF8008), 'icon': Icons.assignment_late_rounded},
      {'title': 'Fee Reminder', 'desc': 'Tuition fee for Q4 is due next week. Tap to view payment portal.', 'type': 'Finance', 'time': 'Yesterday', 'color': const Color(0xFF2575FC), 'icon': Icons.payment_rounded},
      {'title': 'Message from Mr. Verma', 'desc': 'Please review the science project proposal sent via email.', 'type': 'Teacher', 'time': 'Yesterday', 'color': const Color(0xFF11998E), 'icon': Icons.message_rounded},
      {'title': 'Bus Safety Update', 'desc': 'Bus route #4 will be delayed by 10 mins due to traffic near Sector 15.', 'type': 'Transport', 'time': '2 days ago', 'color': const Color(0xFF6A11CB), 'icon': Icons.directions_bus_rounded},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF11998E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_rounded, size: 64, color: Colors.black26),
                  const SizedBox(height: 16),
                  const Text('No new urgent notifications', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600)),
                ],
              ),
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
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
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
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
