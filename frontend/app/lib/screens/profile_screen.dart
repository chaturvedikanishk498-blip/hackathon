import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login.dart'; 

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const ProfileScreen({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF667EEA),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF5F3FF),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF667EEA), width: 2),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF667EEA).withOpacity(0.15),
                  child: const Icon(Icons.person, size: 55, color: Color(0xFF667EEA)),
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                studentData['name'] ?? 'Student',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 6),
              Text(
                studentData['class'] ?? 'Class X',
                style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF667EEA).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.email_outlined, color: Color(0xFF667EEA)),
                      ),
                      title: const Text('Email Address', style: TextStyle(fontSize: 13, color: Colors.black54)),
                      subtitle: Text(
                        FirebaseAuth.instance.currentUser?.email ?? 'Not Logged In',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    const Divider(height: 1, indent: 65, endIndent: 20),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFFC5C7D).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.analytics_outlined, color: Color(0xFFFC5C7D)),
                      ),
                      title: const Text('Academic GPA', style: TextStyle(fontSize: 13, color: Colors.black54)),
                      subtitle: Text(
                        studentData['gpa'] ?? 'N/A',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),

           
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shadowColor: Colors.redAccent.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text(
                    'Logout Securely',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  onPressed: () async {
                   
                    await FirebaseAuth.instance.signOut();
                    
                    if (context.mounted) {
                      
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LogInScreen()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
