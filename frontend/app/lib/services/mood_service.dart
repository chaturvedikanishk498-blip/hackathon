import 'package:cloud_firestore/cloud_firestore.dart';
import 'alert_service.dart';

class MoodService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AlertService _alertService = AlertService();

  Future<void> submitMoodReport({
    required String studentId,
    required String studentName,
    required String mood,
    required String message,
  }) async {
    try {
      // 1. Save the mood report
      await _db.collection('mood_reports').add({
        'studentId': studentId,
        'studentName': studentName,
        'mood': mood,
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Check and trigger alerts in the background (No delay for user)
      await _alertService.checkForParentPressure(
        studentId: studentId,
        studentName: studentName,
        mood: mood,
        message: message,
      );
    } catch (e) {
      throw Exception('Failed to submit mood: $e');
    }
  }
}
