import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: const Text("Attendance Log"),
        backgroundColor: const Color(0xFF667EEA),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendance')
            .doc(uid)
            .collection('records')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final records = snapshot.data?.docs ?? [];

          if (records.isEmpty) {
            return const Center(
              child: Text("No attendance records found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final item = records[index].data() as Map<String, dynamic>;

              final status = (item['status'] ?? '').toString();
              final isPresent = status.toLowerCase() == 'present';

              return ListTile(
                leading: Icon(
                  isPresent ? Icons.check_circle : Icons.cancel,
                  color: isPresent ? Colors.green : Colors.red,
                ),
                title: Text(item['date'] ?? 'No date'),
                subtitle: Text("Status: $status"),
              );
            },
          );
        },
      ),
    );
  }
}