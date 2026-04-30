import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/mood_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodCheckinScreen extends StatefulWidget {
  @override
  _MoodCheckinScreenState createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends State<MoodCheckinScreen> {
  final TextEditingController _messageController = TextEditingController();
  final MoodService _moodService = MoodService();
  
  String? _selectedMood;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Happy', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.green},
    {'label': 'Normal', 'icon': Icons.sentiment_satisfied, 'color': Colors.blue},
    {'label': 'Sad', 'icon': Icons.sentiment_dissatisfied, 'color': Colors.orange},
    {'label': 'Stressed', 'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.deepOrange},
    {'label': 'Scared', 'icon': Icons.mood_bad, 'color': Colors.red},
  ];

  Future<void> _submit() async {
    // Basic Error Handling
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a mood.')));
      return;
    }
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please tell us what happened.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get Real Student Data (Falls back to dummy data if auth is missing)
      final user = FirebaseAuth.instance.currentUser;
      String studentId = user?.uid ?? 'STUDENT_123';
      String studentName;

if (user?.email?.toLowerCase() == 'kanishk@gmail.com') {
  studentName = 'Kanishk';
} else if (user?.email?.toLowerCase() == 'harsh@gmail.com') {
  studentName = 'Harsh';
} else {
  studentName = user?.email?.split('@').first ?? 'Student';
}

      await _moodService.submitMoodReport(
  studentId: studentId,
  studentName: studentName,
  mood: _selectedMood!,
  message: _messageController.text.trim(),
);

// 🚨 Alert logic (ADD THIS BELOW)
if (_selectedMood == 'Stressed' || _selectedMood == 'Sad' || _selectedMood == 'Scared') {
  await FirebaseFirestore.instance.collection('alerts').add({
    'type': 'Home Pressure Alert',
    'title': 'Student may be feeling pressure at home',
    'message': 'Student reported feeling pressure at home. Please check in privately.',
    'severity': 'High',
    'status': 'unread',
    'studentName': studentName,
    'studentId': studentId,
    'mood': _selectedMood,
    'concern': 'Parent/Home Pressure',
    'studentMessage': _messageController.text.trim(),
    'createdAt': FieldValue.serverTimestamp(),
  });
}

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Thank you for sharing!'),
        backgroundColor: Colors.green,
      ));
      
      Navigator.pop(context); // Go back to dashboard
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Could not submit report.'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Check-in', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            
            // Modern Grid Mood Selector
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: _moods.map((mood) {
                bool isSelected = _selectedMood == mood['label'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood['label']),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? mood['color'].withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? mood['color'] : Colors.grey.shade300,
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: isSelected ? [BoxShadow(color: mood['color'].withOpacity(0.2), blurRadius: 8)] : [],
                    ),
                    child: Column(
                      children: [
                        Icon(mood['icon'], color: isSelected ? mood['color'] : Colors.grey, size: 40),
                        SizedBox(height: 8),
                        Text(mood['label'], style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, 
                          color: isSelected ? mood['color'] : Colors.grey[700]
                        )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            
            SizedBox(height: 40),
            Text('What happened today?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
            SizedBox(height: 12),
            
            // Text Input Field
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your thoughts safely here...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.indigo, width: 2),
                ),
              ),
            ),
            
            SizedBox(height: 40),
            
            // Submit Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit Check-in', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
