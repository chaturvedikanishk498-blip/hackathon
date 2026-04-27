import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockTimetable = [
      {"time": "08:00 AM - 08:45 AM", "subject": "Mathematics", "room": "Room 101", "color": const Color(0xFF667EEA)},
      {"time": "08:50 AM - 09:35 AM", "subject": "Physics", "room": "Lab 2", "color": const Color(0xFFFC5C7D)},
      {"time": "09:40 AM - 10:25 AM", "subject": "English", "room": "Room 204", "color": const Color(0xFF11998E)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(title: const Text("Full Timetable"), backgroundColor: const Color(0xFF667EEA)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockTimetable.length,
        itemBuilder: (context, index) {
          final item = mockTimetable[index];
          final color = item['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border(left: BorderSide(color: color, width: 5)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
            child: ListTile(
              leading: Icon(Icons.access_time_filled, color: color, size: 30),
              title: Text(item['subject'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              subtitle: Text(item['time'] as String, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
              trailing: Text(item['room'] as String, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
}
