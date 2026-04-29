import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}
class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  
  static const Color primary = Color(0xFF11998E);
  static const Color bgColor = Color(0xFFECFDF5);
  
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! I am EduAI, your smart school assistant. How can I help you today regarding your children\'s progress?',
      'isBot': true
    },
    {
      'text': 'How is Arjun performing in Physics?',
      'isBot': false
    },
    {
      'text': 'Arjun has seen a slight drop in Physics scores over the past 2 weeks. I suggest reviewing the "Electromagnetism" chapters. Mr. Verma has shared extra worksheets in the Student Portal.',
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
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': 'I understand. I will notify the respective teachers to pay closer attention and will update your dashboard with a new study plan shortly!',
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
            Icon(Icons.smart_toy_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('EduAI Assistant', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
          ],
        ),
        backgroundColor: primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
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
                      color: isBot ? Colors.white : primary,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isBot ? 0 : 20),
                        bottomRight: Radius.circular(isBot ? 20 : 0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
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
                          hintText: 'Ask about grades, attendance, tips...',
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
                        color: primary,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Color(0x3311998E), blurRadius: 12, offset: Offset(0, 4))],
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