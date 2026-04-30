import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Ensure intl is in pubspec.yaml

class AlertModel {
  final String id;
  final String studentId;
  final String studentName;
  final String teacherId;
  final String type;
  final String message;
  final String mood;
  final String severity;
  final String status;
  final DateTime createdAt;

  AlertModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.teacherId,
    required this.type,
    required this.message,
    required this.mood,
    required this.severity,
    required this.status,
    required this.createdAt,
  });

  factory AlertModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AlertModel(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      teacherId: data['teacherId'] ?? '',
      type: data['type'] ?? '',
      message: data['message'] ?? '',
      mood: data['mood'] ?? '',
      severity: data['severity'] ?? 'Medium',
      status: data['status'] ?? 'unread',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Bonus: Timestamp formatting for clean UI
  String get formattedTime {
    return DateFormat('MMM d, h:mm a').format(createdAt);
  }
}
