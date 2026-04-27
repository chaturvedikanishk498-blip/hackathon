import 'package:flutter/material.dart';

class MeetingRequestsScreen extends StatefulWidget {
  const MeetingRequestsScreen({super.key});

  @override
  State<MeetingRequestsScreen> createState() => _MeetingRequestsScreenState();
}

class _MeetingRequestsScreenState extends State<MeetingRequestsScreen> {
  final List<Map<String, dynamic>> requests = [
    {
      'id': '1',
      'parentName': 'Amit Verma',
      'studentName': 'Rohan Verma',
      'class': 'IX - B',
      'date': 'Tomorrow',
      'time': '10:00 AM',
      'reason': 'Discuss low attendance and recent physics test scores.',
      'status': 'pending'
    },
    {
      'id': '2',
      'parentName': 'Sunita Sharma',
      'studentName': 'Priya Sharma',
      'class': 'X - A',
      'date': 'Friday',
      'time': '2:00 PM',
      'reason': 'Regular parent-teacher connect.',
      'status': 'pending'
    },
  ];

  void _handleAction(int index, bool approve) {
    if (approve) {
      setState(() => requests[index]['status'] = 'approved');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting Approved ✅', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Color(0xFF11998E), behavior: SnackBarBehavior.floating),
      );
    } else {
      _showRejectDialog(index);
    }
  }

  void _showRejectDialog(int index) {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Reject Meeting', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(hintText: 'Enter rejection reason...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancel', style: TextStyle(color: Colors.black54))
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFC5C7D)),
              onPressed: () {
                if (reasonController.text.isEmpty) return;
                Navigator.pop(context);
                setState(() => requests[index]['status'] = 'rejected');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Meeting Rejected ❌', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Color(0xFFFC5C7D), behavior: SnackBarBehavior.floating),
                );
              },
              child: const Text('Reject', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingRequests = requests.where((r) => r['status'] == 'pending').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Meeting Requests', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF11998E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: pendingRequests.isEmpty
          ? const Center(
              child: Text('No pending meeting requests', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: pendingRequests.length,
              itemBuilder: (context, index) {
                final r = pendingRequests[index];
                // Finding original index logic to ensure correct updates
                final realIndex = requests.indexWhere((element) => element['id'] == r['id']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF11998E),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${r['parentName']}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                Text('Parent of ${r['studentName']} (${r['class']})', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF11998E)),
                          const SizedBox(width: 6),
                          Text('${r['date']} at ${r['time']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Reason: ${r['reason']}', style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _handleAction(realIndex, false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFFC5C7D),
                                side: const BorderSide(color: Color(0xFFFC5C7D)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _handleAction(realIndex, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF11998E),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Approve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
