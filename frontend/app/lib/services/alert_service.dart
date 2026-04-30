import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alert_model.dart';

class AlertService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Keyword list to detect parent pressure
  final List<String> _pressureKeywords = [
    'pressure', 'force', 'forcing', 'parents', 'mom', 'dad', 
    'scold', 'marks', 'stress', 'study too much', 'angry'
  ];

  // Logic to determine if an alert should be triggered
  Future<void> checkForParentPressure({
    required String studentId,
    required String studentName,
    required String mood,
    required String message,
  }) async {
    // Only care about negative moods
    if (mood == 'Sad' || mood == 'Stressed' || mood == 'Scared') {
      String lowerMessage = message.toLowerCase();
      bool containsKeyword = _pressureKeywords.any((keyword) => lowerMessage.contains(keyword));

      if (containsKeyword) {
        // Bonus: Calculate severity based on mood and strong keywords
        String severity = (mood == 'Scared' || lowerMessage.contains('force') || lowerMessage.contains('angry')) 
            ? 'High' 
            : 'Medium';

        // For the hackathon, route this to a placeholder teacher ID 
        // In prod, fetch from the student's assigned teacher field
        String assignedTeacherId = 'TEACHER_123'; 

        await _createAlert(
          studentId: studentId,
          studentName: studentName,
          teacherId: assignedTeacherId,
          message: message,
          mood: mood,
          severity: severity,
        );
      }
    }
  }

  Future<void> _createAlert({
    required String studentId,
    required String studentName,
    required String teacherId,
    required String message,
    required String mood,
    required String severity,
  }) async {
    try {
      await _db.collection('alerts').add({
        'studentId': studentId,
        'studentName': studentName,
        'teacherId': teacherId,
        'type': 'Parent Pressure',
        'message': message,
        'mood': mood,
        'severity': severity,
        'status': 'unread',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating alert: $e');
    }
  }

  // Stream for Teacher Dashboard (Only pulls unread alerts)
  Stream<List<AlertModel>> getUnreadAlerts() {
    return _db
        .collection('alerts')
        // .where('teacherId', isEqualTo: currentTeacherId) // Uncomment if using real Teacher Auth
        .where('status', isEqualTo: 'unread')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => AlertModel.fromFirestore(doc)).toList());
  }

  // Mark alert as read/resolved
  Future<void> markAsRead(String alertId) async {
    await _db.collection('alerts').doc(alertId).update({
      'status': 'read',
    });
  }
}
