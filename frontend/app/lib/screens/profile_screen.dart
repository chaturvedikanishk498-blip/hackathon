import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: const Text("Student Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF667EEA),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF667EEA)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Rahul Sharma", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
            const Text("Class X - A | Roll No: 24", style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),
            _buildProfileItem(Icons.email, "Email", "rahul.sharma@school.edu"),
            _buildProfileItem(Icons.phone, "Phone", "+91 9876543210"),
            _buildProfileItem(Icons.location_on, "Address", "123, Green Park, New Delhi"),
            _buildProfileItem(Icons.bloodtype, "Blood Group", "O+"),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Adjust route to point to your login screen
                  Navigator.of(context).pushReplacementNamed('/login'); 
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout Securely", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC5C7D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF667EEA).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF667EEA)),
        ),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A2E), fontWeight: FontWeight.w700)),
      ),
    );
  }
}
