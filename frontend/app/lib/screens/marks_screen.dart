import 'package:flutter/material.dart';

class MarksScreen extends StatelessWidget {
  const MarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockMarks = [
      {"subject": "Mathematics", "score": "95/100", "grade": "A+", "color": const Color(0xFF667EEA)},
      {"subject": "Science", "score": "88/100", "grade": "A", "color": const Color(0xFF11998E)},
      {"subject": "History", "score": "78/100", "grade": "B", "color": const Color(0xFFFF8008)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(title: const Text("Grade Center"), backgroundColor: const Color(0xFF667EEA)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockMarks.length,
        itemBuilder: (context, index) {
          final mark = mockMarks[index];
          final color = mark['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.school, color: color)),
              title: Text(mark['subject'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              subtitle: Text("Score: ${mark['score']}", style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: Text(mark['grade'] as String, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
            ),
          );
        },
      ),
    );
  }
}
