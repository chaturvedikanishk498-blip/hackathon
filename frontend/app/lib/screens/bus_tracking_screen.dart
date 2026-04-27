import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BusTrackingScreen extends StatelessWidget {
  final String childName;

  static const Color primary = Color(0xFF11998E);
  static const Color bgColor = Color(0xFFECFDF5);
  static const Color cardBg = Colors.white;

  const BusTrackingScreen({
    super.key,
    required this.childName,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 Theme Colors matching the Parent Dashboard
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: const Text("Live Bus Tracking", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.sos_rounded, color: Colors.redAccent, size: 30),
            onPressed: () {
              HapticFeedback.heavyImpact();
              // Mock SOS action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emergency Alert Sent to School Admin!'), backgroundColor: Colors.red),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Mock Live Location Map Area
            Container(
              height: 250,
              width: double.infinity,
              color: const Color(0xFFBFE6E0), // Soft map-like placeholder background
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.map_outlined, size: 100, color: Colors.white54), // Background map icon
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                        ),
                        child: const Icon(Icons.directions_bus, color: primary, size: 40),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: primary, 
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: primary.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]
                        ),
                        child: const Text("Bus 42 - Moving", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            
            // 🔹 Bottom Detail Sheet
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trip Info Card
                      _buildTripInfoCard(cardBg, primary),
                      const SizedBox(height: 20),

                      // Driver Info
                      _buildDriverInfo(cardBg, primary),
                      const SizedBox(height: 24),

                      // Timeline / Route Progress
                      const Text("Route Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 16),
                      _buildRouteTimeline(primary),
                      const SizedBox(height: 24),

                      // Child Status Alerts
                      const Text("Recent Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 14),
                      _buildAlert(Icons.check_circle_rounded, "$childName safely boarded the bus.", Colors.green, "07:30 AM"),
                      _buildAlert(Icons.directions_bus_rounded, "Bus departed from pickup point.", Colors.blue, "07:35 AM"),
                      _buildAlert(Icons.notifications_active_rounded, "Approaching school gate.", const Color(0xFFFF8008), "Now"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripInfoCard(Color cardBg, Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Estimated Arrival", style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text("08:15 AM", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: primary, size: 18),
                    const SizedBox(width: 6),
                    Text("10 mins", style: TextStyle(color: primary, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 30, thickness: 1, color: Color(0xFFF0F0F0)),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Destination", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text("Delhi Public School, Sector 45", style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E), fontSize: 14)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDriverInfo(Color cardBg, Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primary, width: 2)),
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, color: Colors.grey, size: 30), // Placeholder avatar
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ramesh Kumar", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1A1A2E))),
                SizedBox(height: 2),
                Text("Driver • Bus 42", style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call, color: Colors.green),
            style: IconButton.styleFrom(backgroundColor: Colors.green.withOpacity(0.1)),
          )
        ],
      ),
    );
  }

  Widget _buildRouteTimeline(Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _buildTimelineTile("Home Pickup Point", "07:30 AM", isPast: true, isLast: false, color: primary),
          _buildTimelineTile("Sector 14 Crossroad", "07:50 AM", isPast: true, isLast: false, color: primary),
          _buildTimelineTile("Current Location", "On the way", isPast: false, isCurrent: true, isLast: false, color: primary),
          _buildTimelineTile("School Main Gate", "ETA 08:15 AM", isPast: false, isLast: true, color: primary),
        ],
      ),
    );
  }

  Widget _buildTimelineTile(String title, String subtitle, {required bool isPast, bool isCurrent = false, required bool isLast, required Color color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isPast || isCurrent ? color : Colors.grey.shade300,
                shape: BoxShape.circle,
                border: isCurrent ? Border.all(color: color.withOpacity(0.3), width: 4) : null,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isPast ? color : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600, fontSize: 14, color: isPast || isCurrent ? const Color(0xFF1A1A2E) : Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: isCurrent ? color : Colors.black45, fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlert(IconData icon, String message, Color color, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E)))),
          Text(time, style: const TextStyle(fontSize: 11, color: Colors.black45, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
