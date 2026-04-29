import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudyTimerWidget extends StatefulWidget {
  const StudyTimerWidget({super.key});

  @override
  State<StudyTimerWidget> createState() => _StudyTimerWidgetState();
}

class _StudyTimerWidgetState extends State<StudyTimerWidget> {
  static const int focusDurationInSeconds = 25 * 60; 
  int _remainingSeconds = focusDurationInSeconds;
  Timer? _timer;
  bool _isRunning = false;

  void _toggleTimer() {
    HapticFeedback.mediumImpact();
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          timer.cancel();
          _isRunning = false;
          HapticFeedback.vibrate();
        }
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _resetTimer() {
    HapticFeedback.lightImpact();
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = focusDurationInSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    String timeText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer_rounded, color: Color(0xFF667EEA), size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pomodoro Session', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                  const SizedBox(height: 2),
                  Text(timeText, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: Color(0xFF1A1A2E), letterSpacing: 1)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              if (_remainingSeconds < focusDurationInSeconds)
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.black45),
                  onPressed: _resetTimer,
                ),
              GestureDetector(
                onTap: _toggleTimer,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: const Color(0xFF667EEA).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Text(
                    _isRunning ? 'PAUSE' : 'START',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
