import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentAIChatScreen extends StatefulWidget {
  const StudentAIChatScreen({super.key});

  @override
  State<StudentAIChatScreen> createState() => _StudentAIChatScreenState();
}

class _StudentAIChatScreenState extends State<StudentAIChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  
  static const Color primary = Color(0xFF667EEA);
  static const Color secondary = Color(0xFF764BA2);
  static const Color bgColor = Color(0xFFF5F3FF);
  
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hi Rahul! I am your EduAI guide. Need help planning your study schedule or analyzing your past test scores?',
      'isBot': true
    },
    {
      'text': 'What should I study today?',
      'isBot': false
    },
    {
      'text': 'Based on your upcoming tests, I recommend focusing on Chemistry. Your "Atomic Structure" quiz is in 3 days, and your previous score was 65%. Should I generate a 30-minute flashcard quiz for you?',
      'isBot': true
    },
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add({'text': _msgController.text, 'isBot': false});
      _msgController.clear();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': 'Sure! I will adapt your study planner and remind you regarding weak topics. Happy learning!',
            'isBot': true
          });
        });
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text('EduAI Guide', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [primary, secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isBot = msg['isBot'] as bool;
                
                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      gradient: isBot ? null : const LinearGradient(colors: [primary, secondary]),
                      color: isBot ? Colors.white : null,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isBot ? 0 : 20),
                        bottomRight: Radius.circular(isBot ? 20 : 0),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Text(
                      msg['text'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: isBot ? const Color(0xFF1A1A2E) : Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, -4))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _msgController,
                        decoration: const InputDecoration(
                          hintText: 'Ask for study advice...',
                          hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [primary, secondary]),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Color(0x33667EEA), blurRadius: 12, offset: Offset(0, 4))],
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
