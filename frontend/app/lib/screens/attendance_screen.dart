import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockData = [
      {"date": "Oct 25, 2023", "status": "Present", "color": const Color(0xFF11998E)},
      {"date": "Oct 24, 2023", "status": "Present", "color": const Color(0xFF11998E)},
      {"date": "Oct 23, 2023", "status": "Absent", "color": const Color(0xFFFC5C7D)},
      {"date": "Oct 22, 2023", "status": "Present", "color": const Color(0xFF11998E)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(title: const Text("Attendance Log"), backgroundColor: const Color(0xFF667EEA)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockData.length,
        itemBuilder: (context, index) {
          final item = mockData[index];
          final color = item['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
            child: ListTile(
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.co_present, color: color)),
              title: Text(item['date'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              subtitle: Text("Status: ${item['status']}", style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: Icon(item['status'] == 'Present' ? Icons.check_circle : Icons.cancel, color: color, size: 28),
            ),
          );
        },
      ),
    );
  }
}
