import 'package:flutter/material.dart';

class TeacherMeetingScreen extends StatefulWidget {
  final String childName;
  final String childClass;

  const TeacherMeetingScreen({super.key, required this.childName, required this.childClass});

  @override
  State<TeacherMeetingScreen> createState() => _TeacherMeetingScreenState();
}

class _TeacherMeetingScreenState extends State<TeacherMeetingScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _reasonController = TextEditingController();
  bool isSubmitting = false;

  void _scheduleMeeting() {
    if (selectedDate == null || selectedTime == null || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date, time, and provide a reason.'))
      );
      return;
    }

    setState(() => isSubmitting = true);
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meeting request sent to class teacher! ✅', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            backgroundColor: Color(0xFF11998E),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          )
        );
        Navigator.pop(context); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      appBar: AppBar(
        title: const Text('Schedule Meeting', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF11998E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF11998E),
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mr. A. Verma', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1A1A2E))),
                        const SizedBox(height: 4),
                        Text('Class Teacher • ${widget.childClass}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF11998E).withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF11998E).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFF11998E)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('You are requesting a meeting regarding ${widget.childName}.', 
                    style: const TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            const Text('Meeting Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            
            
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade300)),
              tileColor: Colors.white,
              leading: const Icon(Icons.calendar_today_rounded, color: Color(0xFF11998E)),
              title: Text(selectedDate == null ? 'Select Date' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}', style: const TextStyle(fontWeight: FontWeight.w600)),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(primary: Color(0xFF11998E)),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) setState(() => selectedDate = date);
              },
            ),
            const SizedBox(height: 12),
            
          
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade300)),
              tileColor: Colors.white,
              leading: const Icon(Icons.access_time_rounded, color: Color(0xFF11998E)),
              title: Text(selectedTime == null ? 'Select Time' : selectedTime!.format(context), style: const TextStyle(fontWeight: FontWeight.w600)),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 10, minute: 0),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(primary: Color(0xFF11998E)),
                      ),
                      child: child!,
                    );
                  },
                );
                if (time != null) setState(() => selectedTime = time);
              },
            ),
            const SizedBox(height: 24),
            
            
            const Text('Reason for Meeting', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'e.g. Discuss academic progress, low attendance, or extra support needed...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF11998E), width: 2)),
              ),
            ),
            const SizedBox(height: 40),
            
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _scheduleMeeting,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF11998E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: isSubmitting
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Confirm Meeting', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
