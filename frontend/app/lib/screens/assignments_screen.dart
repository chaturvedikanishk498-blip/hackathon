import 'package:flutter/material.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockAssignments = [
      {"title": "Physics Lab Report", "due": "Tomorrow, 10:00 AM", "status": "Pending", "color": const Color(0xFFFC5C7D)},
      {"title": "History Essay", "due": "Oct 20, 2023", "status": "Submitted", "color": const Color(0xFF11998E)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(title: const Text("Assignments"), backgroundColor: const Color(0xFF667EEA)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockAssignments.length,
        itemBuilder: (context, index) {
          final item = mockAssignments[index];
          final color = item['color'] as Color;
          final isPending = item['status'] == 'Pending';
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
            child: ListTile(
              leading: Icon(isPending ? Icons.pending_actions : Icons.check_circle, color: color, size: 32),
              title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              subtitle: Text("Due: ${item['due']}", style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(item['status'] as String, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          );
        },
      ),
    );
  }
}
