import 'package:flutter/material.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  String selectedClass = 'X - A';
  final List<String> classes = ['X - A', 'IX - B', 'XI - A'];

  // 🔹 Top 5 Mock Students
  final List<Map<String, dynamic>> students = [
    {'name': 'Ananya Gupta', 'roll': '101', 'isPresent': true},
    {'name': 'Harsh Sharma', 'roll': '102', 'isPresent': true},
    {'name': 'Kanishk Singh', 'roll': '103', 'isPresent': true},
    {'name': 'Rohit Kumar', 'roll': '104', 'isPresent': true},
    {'name': 'Sneha Patel', 'roll': '105', 'isPresent': true},
  ];

  void _submitAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance submitted successfully! ✅', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF11998E),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context); // Go back to dashboard on submit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Mark Attendance', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFFFC5C7D),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Class', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedClass,
                  isExpanded: true,
                  items: classes.map((String c) {
                    return DropdownMenuItem<String>(
                      value: c,
                      child: Text('Class $c', style: const TextStyle(fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) setState(() => selectedClass = newValue);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Student List', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final s = students[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: CheckboxListTile(
                      activeColor: const Color(0xFF11998E),
                      title: Text(s['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      subtitle: Text('Roll No: ${s['roll']}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      value: s['isPresent'],
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() => s['isPresent'] = value);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC5C7D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: const Text('Submit Attendance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
